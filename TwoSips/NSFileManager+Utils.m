//
//  NSFileManager+Utils.m
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import "NSFileManager+Utils.h"

@implementation NSFileManager (Utils)

- (BOOL)isDirectory:(NSURL *)theURL
{
    BOOL isDir = NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[theURL path] isDirectory:&isDir] && isDir;
}

@end
