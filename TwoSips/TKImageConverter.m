//
//  TKImageConverter.m
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import "TKImageConverter.h"
#import "TKUtils.h"

@implementation TKImageConverter

- (BOOL)convertImages:(NSArray *)images toType:(NSString *)imgFileType destinationDirectoryURL:(NSURL *)dirURL
{
    NSLog(@"CONVERTING IMAGES...");
    BOOL success = YES;
    
    for (NSImage *img in images) {
        success = success && [self convertImage:img toType:imgFileType destinationDirectoryURL:dirURL];
    }
    
    return success;
}

- (BOOL)convertImage:(NSImage *)image toType:(NSString *)imgFileType destinationDirectoryURL:(NSURL *)dirURL
{
    NSLog(@"CONVERTING ONE IMAGE...");
    
    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    
    NSData *convertedData = [bitmapRep representationUsingType:[TKUtils bitmapImageFileTypeForExtension:imgFileType] properties:nil];
    
    NSString *convertedFileName = [[image name] stringByAppendingPathExtension:imgFileType];
    NSURL *targetFileURL = [dirURL URLByAppendingPathComponent:convertedFileName];
    
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:dirURL withIntermediateDirectories:YES attributes:nil error:nil];
    success = success && [convertedData writeToURL:targetFileURL atomically:YES];
    
    return success;
}

@end
