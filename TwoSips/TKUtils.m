//
//  TKUtils.m
//  TwoSips
//
//  Created by Thomas Kober on 5/12/13.
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

#import "TKUtils.h"

@implementation TKUtils

+ (NSBitmapImageFileType)bitmapImageFileTypeForExtension:(NSString *)extension
{
    if ([extension isEqualToString:@"bmp"]) {
        return NSBMPFileType;
    } else if ([extension isEqualToString:@"gif"]) {
        return NSGIFFileType;
    } else if ([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"]) {
        return NSJPEG2000FileType;
    } else if ([extension isEqualToString:@"png"]) {
        return NSPNGFileType;
    } else if ([extension isEqualToString:@"tif"] || [extension isEqualToString:@"tiff"]) {
        return NSTIFFFileType;
    } else {
        return NSPNGFileType; // Default
    }
}

@end
