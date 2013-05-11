//
//  TKImageView.m
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import "TKImageView.h"
#import "TKImageConverter.h"
#import "TKAppDelegate.h"
#import "NSFileManager+Utils.h"
#import "NSImage+Utils.h"

@interface TKImageView (Private)
- (BOOL)isSupportedFileType:(NSURL *)fileURL;
- (BOOL)directoryContainsSupportedFileType:(NSURL *)dirURL;
- (BOOL)validFiles:(NSArray *)pasteboardItems;
- (NSSet *)supportedFileTypes;
- (NSString *)predicateString;
- (NSArray *)getImagePaths:(NSArray *)pasteboardItems;
- (NSArray *)getImages:(NSArray *)imagePathURLs;
@end

@implementation TKImageView

- (id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        _imgConverter = [[TKImageConverter alloc] init];
    }
    
    return self;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

# pragma mark - NSDraggingDestination Protocol implementation
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    [self becomeFirstResponder];
    /* TODO: Focus Ring Drawing
    [self becomeFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setFocusRingType:NSFocusRingTypeExterior];
    });
    */
    
    NSPasteboard *thePastboard = [sender draggingPasteboard];
    
    NSDragOperation dragOp = NSDragOperationNone;
    
    if ([self validFiles:[thePastboard pasteboardItems]]) {
        dragOp = NSDragOperationCopy;
    }
    
    NSLog(@"VALID STUFF: %d", [self validFiles:[thePastboard pasteboardItems]]);
    
    NSLog(@"Dragging entered!");
    
    return dragOp;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *thePasteboard = [sender draggingPasteboard];
    BOOL success = NO;
    
    if ([self validFiles:[thePasteboard pasteboardItems]]) {
        
        NSArray *imgPathURLs = [self getImagePaths:[thePasteboard pasteboardItems]];
        NSArray *imgs = [self getImages:imgPathURLs];
        
        TKAppDelegate *delegate = (TKAppDelegate *)[NSApp delegate];
        
        NSInteger index = [[delegate cmbOutputFormat] indexOfSelectedItem];
        
        success = [_imgConverter convertImages:imgs toType:[[delegate cmbOutputFormat] itemObjectValueAtIndex:index] destinationDirectory:nil];
    }
    
    return success;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    [self setFocusRingType:NSFocusRingTypeDefault];
    NSLog(@"PARENT FOLDER: %@", [@"/etc/usr/bin/" stringByDeletingLastPathComponent]);
    NSLog(@"PARENT FOLDER OF FILE: %@", [@"/etc/usr/bin.txt" stringByDeletingLastPathComponent]);
    NSLog(@"Dragging exited!");
}


@end

@implementation TKImageView (Private)

- (BOOL)isSupportedFileType:(NSURL *)fileURL
{
    return [[self supportedFileTypes] containsObject:[[fileURL pathExtension] lowercaseString]];
}

- (BOOL)directoryContainsSupportedFileType:(NSURL *)dirURL
{
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[dirURL path] error:nil];
    NSArray *supportedFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[self predicateString]]];
    
    return [supportedFiles count] > 0;
}

- (BOOL)validFiles:(NSArray *)pasteboardItems
{
    BOOL valid = NO;
    NSInteger i = 0;
    NSURL *theURL = nil;
    
    while (!valid && i < [pasteboardItems count]) {
        
        theURL = [NSURL URLWithString:[[pasteboardItems objectAtIndex:i] stringForType:kURLType]];
        
        if ([[NSFileManager defaultManager] isDirectory:theURL]) {
            valid = [self directoryContainsSupportedFileType:theURL];
        } else {
            valid = [self isSupportedFileType:theURL];
        }
        
        i++;
    }
    
    return valid;
}

- (NSSet *)supportedFileTypes
{
    // Ugly but I don't care atm...
    return [NSSet setWithObjects:@"bmp", @"gif", @"jpg", @"jpeg", @"png", @"tif", @"tiff", nil];
}

- (NSString *)predicateString
{
    // Even uglier but how cares???
    return @"self ENDSWITH '.bmp' OR self ENDSWITH '.gif' OR self ENDSWITH '.jpg' OR self ENDSWITH '.jpeg' OR self ENDSWITH '.png' OR self ENDSWITH '.tif' OR self ENDSWITH '.tiff'";
}

- (NSArray *)getImagePaths:(NSArray *)pasteboardItems
{
    NSURL *theURL = nil;
    NSMutableArray *imgPaths = [NSMutableArray array];
    
    for (NSPasteboardItem *item in pasteboardItems) {
        theURL = [NSURL URLWithString:[item stringForType:kURLType]];
        
        if ([[NSFileManager defaultManager] isDirectory:theURL]) {
            NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[theURL path] error:nil];
            [imgPaths addObjectsFromArray:[dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[self predicateString]]]];
        } else {
            if ([self isSupportedFileType:theURL]) {
                [imgPaths addObject:theURL];
            }
        }
    }
    
    return (NSArray *)imgPaths;
}

- (NSArray *)getImages:(NSArray *)imagePathURLs
{
    NSMutableArray *imgs = [NSMutableArray array];
    
    for (NSURL *theURL in imagePathURLs) {
        [imgs addObject:[NSImage imageWithContentsOfURL:theURL]];
    }
    
    return (NSArray *)imgs;
}

@end