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
    
    NSLog(@"CONVERTED FILENAME: %@", convertedFileName);
    
    NSURL *targetFileURL = [dirURL URLByAppendingPathComponent:convertedFileName];
    
    NSLog(@"TARGET FILE URL: %@", targetFileURL);
    
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:dirURL withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSLog(@"CREATE DIR SUCCESS: %d", success);
    
    success = success && [convertedData writeToURL:targetFileURL atomically:YES];
    
    NSLog(@"WRITE FILE SUCCESS: %d", success);
    
    return success;
}

@end
