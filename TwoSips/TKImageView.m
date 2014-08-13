//
//  TKImageView.m
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//
//  The MIT License (MIT)
//
// 	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in the
//	Software without restriction, including without limitation the rights to use, copy,
//	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
//	and to permit persons to whom the Software is furnished to do so, subject to the
//	following conditions:
//
//	The above copyright notice and this permission notice shall be included in all copies
//	or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//	PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//	FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//	OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//	DEALINGS IN THE SOFTWARE.

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
    _highlight = NO;
    _flash = NO;
}

- (void)drawRect:(NSRect)aRect {
    
    NSRect bounds = [self bounds];
    [super drawRect:aRect];
    
    [_image drawAtPoint:bounds.origin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    if (_flash) {
        [[NSColor keyboardFocusIndicatorColor] set];
        [NSBezierPath setDefaultLineWidth:5];
        [NSBezierPath strokeRect: [self bounds]];
    } else if (_highlight) {
        [[NSColor selectedTextBackgroundColor] set];
        [NSBezierPath setDefaultLineWidth:5];
        [NSBezierPath strokeRect: [self bounds]];
    }
    
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

# pragma mark - NSDraggingDestination Protocol implementation
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    /*
        Some Useful Drag & Drop Resources
        - http://www.cocoabuilder.com/archive/cocoa/163984-nswindow-drag-and-drop-focus-ring.html
        - http://gazapps.com/wp/2011/08/01/drag-and-drop-text-file-on-macos-x-application/
        -https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DragandDrop/Tasks/DraggingFiles.html
     */
   
    // Do the highlighting ring thingy
    _highlight = YES;
    _flash = NO;
    [self setNeedsDisplay:YES];
    
    // To drag or not to drag
    NSPasteboard *thePastboard = [sender draggingPasteboard];
    
    NSDragOperation dragOp = NSDragOperationNone;
    
    if ([self validFiles:[thePastboard pasteboardItems]]) {
        dragOp = NSDragOperationCopy;
    }
    
    return dragOp;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *thePasteboard = [sender draggingPasteboard];
    //BOOL success = NO;
    
    if ([self validFiles:[thePasteboard pasteboardItems]]) {
        
        NSArray *imgPathURLs = [self getImagePaths:[thePasteboard pasteboardItems]];
        NSArray *imgs = [self getImages:imgPathURLs];
        
        NSURL *parentDir = [[imgPathURLs objectAtIndex:0] URLByDeletingLastPathComponent];
        
        // Probably dispatch async
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[NSApp delegate] lblProgressText] setStringValue:@"Converting..."];
            [_imgConverter convertImages:imgs toType:[[[NSUserDefaults standardUserDefaults] outputImageType] lowercaseString] destinationDirectoryURL:[parentDir URLByAppendingPathComponent:kOutputFolderName isDirectory:YES]];
        });
        //success = [_imgConverter convertImages:imgs toType:[[[NSUserDefaults standardUserDefaults] outputImageType] lowercaseString] destinationDirectoryURL:[parentDir URLByAppendingPathComponent:kOutputFolderName isDirectory:YES]];
    }
    
    return YES;
    //return success;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    // Hide the focus ring again
    _highlight = NO;
    _flash = NO;
    [self setNeedsDisplay:YES];
}

// TODO: The highlighting ends too abruptly - fancify a bit
- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    _flash = YES;
    _highlight = NO;
    [self setNeedsDisplay:YES];
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[NSApp delegate] lblProgressText] setStringValue:@"Success! And ready for more!"];
    });
    _flash = NO;
    _highlight = NO;
    [self setNeedsDisplay:YES];
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
    // Even uglier but who cares???
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