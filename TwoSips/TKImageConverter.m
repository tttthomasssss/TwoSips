//
//  TKImageConverter.m
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import "TKImageConverter.h"

@implementation TKImageConverter

- (BOOL)convertImages:(NSArray *)images toType:(NSString *)imgFileType destinationDirectory:(NSURL *)dirURL
{
    BOOL success = YES;
    
    for (NSImage *img in images) {
        success = success && [self convertImage:img toType:imgFileType destinationDirectory:dirURL];
    }
    
    return success;
}

- (BOOL)convertImage:(NSImage *)image toType:(NSString *)imgFileType destinationDirectory:(NSURL *)dirURL
{
    return NO;
}

@end
