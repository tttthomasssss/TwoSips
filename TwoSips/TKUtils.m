//
//  TKUtils.m
//  TwoSips
//
//  Created by Thomas Kober on 5/12/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

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
