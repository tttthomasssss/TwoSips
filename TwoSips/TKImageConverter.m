//
//  TKImageConverter.m
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

#import "TKImageConverter.h"
#import "TKUtils.h"

@implementation TKImageConverter

- (BOOL)convertImages:(NSArray *)images toType:(NSString *)imgFileType destinationDirectoryURL:(NSURL *)dirURL
{
    BOOL success = YES;
    
    for (NSImage *img in images) {
        success = success && [self convertImage:img toType:imgFileType destinationDirectoryURL:dirURL];
    }
    
    return success;
}

- (BOOL)convertImage:(NSImage *)image toType:(NSString *)imgFileType destinationDirectoryURL:(NSURL *)dirURL
{
    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    
    NSData *convertedData = [bitmapRep representationUsingType:[TKUtils bitmapImageFileTypeForExtension:imgFileType] properties:nil];
    
    NSString *convertedFileName = [[image name] stringByAppendingPathExtension:imgFileType];
    NSURL *targetFileURL = [dirURL URLByAppendingPathComponent:convertedFileName];
    
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:dirURL withIntermediateDirectories:YES attributes:nil error:nil];
    success = success && [convertedData writeToURL:targetFileURL atomically:YES];
    
    return success;
}

@end
