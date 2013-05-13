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
#import "NSUserDefaults+Accessor.h"

@interface TKImageView (Private)
- (BOOL)isSupportedFileType:(NSURL *)fileURL;
- (BOOL)directoryContainsSupportedFileType:(NSURL *)dirURL;
- (BOOL)validFiles:(NSArray *)pasteboardItems;
- (NSSet *)supportedFileTypes;
- (NSString *)predicateString;
- (NSArray *)getImagePaths:(NSArray *)pasteboardItems;
- (NSArray *)getImages:(NSArray *)imagePathURLs;
- (NSArray *)expandPathURLs:(NSArray *)imgFiles withBaseURL:(NSURL *)baseURL;
@end

@implementation TKImageView

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSTIFFPboardType, nil]];
    _image = [NSImage imageNamed:@"drophere.png"];
    _imgConverter = [[TKImageConverter alloc] init];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    NSRect bounds = [self bounds];
    [super drawRect:dirtyRect];
    //[_image compositeToPoint:bounds.origin operation:NSCompositeSourceOver];
    [_image drawAtPoint:bounds.origin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
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
    NSLog(@"Dragging entered!");
    
    return dragOp;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *thePasteboard = [sender draggingPasteboard];
    BOOL success = NO;
    
    NSLog(@"Performing Drag Operation...");
    
    if ([self validFiles:[thePasteboard pasteboardItems]]) {
        
        NSArray *imgPathURLs = [self getImagePaths:[thePasteboard pasteboardItems]];
        NSLog(@"IMG PATHS URLS FINISHED!");
        NSArray *imgs = [self getImages:imgPathURLs];
        NSLog(@"IMGS FINISHED");
        
        NSURL *parentDir = [[imgPathURLs objectAtIndex:0] URLByDeletingLastPathComponent];
        
        NSLog(@"SELECTED STUFF: %@", [[NSUserDefaults standardUserDefaults] outputImageType]);
        NSLog(@"IMAGE PATH URLS: %@", imgPathURLs);
        NSLog(@"PARENT DIR: %@", parentDir);
        NSLog(@"TARGET DIR: %@", [parentDir URLByAppendingPathComponent:kOutputFolderName isDirectory:YES]);
        NSLog(@"IMG CONVERTER: %@", _imgConverter);
        
        success = [_imgConverter convertImages:imgs toType:[[[NSUserDefaults standardUserDefaults] outputImageType] lowercaseString] destinationDirectoryURL:[parentDir URLByAppendingPathComponent:kOutputFolderName isDirectory:YES]];
        
        NSLog(@"SUCCESS: %d", success);
    }
    
    NSLog(@"Drag Operation finished!");
    
    return success;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    [self setFocusRingType:NSFocusRingTypeDefault];
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
    NSLog(@"CHECKING VALIDFILES...");
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
    
    NSLog(@"VALID FILES CHECKING FINISHED: %d", valid);
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
    return @"self ENDSWITH[c] '.bmp' OR self ENDSWITH[c] '.gif' OR self ENDSWITH[c] '.jpg' OR self ENDSWITH[c] '.jpeg' OR self ENDSWITH[c] '.png' OR self ENDSWITH[c] '.tif' OR self ENDSWITH[c] '.tiff'";
}

- (NSArray *)getImagePaths:(NSArray *)pasteboardItems
{
    NSURL *theURL = nil;
    NSMutableArray *imgPaths = [NSMutableArray array];
    
    for (NSPasteboardItem *item in pasteboardItems) {
        theURL = [NSURL URLWithString:[item stringForType:kURLType]];
        
        if ([[NSFileManager defaultManager] isDirectory:theURL]) {
            NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[theURL path] error:nil];
            NSArray *imgFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[self predicateString]]];
            [imgPaths addObjectsFromArray:[self expandPathURLs:imgFiles withBaseURL:theURL]];
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
    NSImage *theImage = nil;
    
    for (NSURL *theURL in imagePathURLs) {
        theImage = [NSImage imageWithContentsOfURL:theURL];
        [theImage setName:[[theURL lastPathComponent] stringByDeletingPathExtension]];
        if (theImage) {
            [imgs addObject:theImage];
        }
    }
    
    return (NSArray *)imgs;
}

- (NSArray *)expandPathURLs:(NSArray *)imgFiles withBaseURL:(NSURL *)baseURL
{
    NSMutableArray *fullPathURLs = [NSMutableArray array];
    
    for (NSString *fname in imgFiles) {
        [fullPathURLs addObject:[baseURL URLByAppendingPathComponent:fname]];
    }
    
    return (NSArray *)fullPathURLs;
}

@end