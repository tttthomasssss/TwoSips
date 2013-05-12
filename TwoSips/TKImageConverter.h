//
//  TKImageConverter.h
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKImageConverter : NSObject

- (BOOL)convertImages:(NSArray *)images toType:(NSString *)imgFileType destinationDirectoryURL:(NSURL *)dirURL;
- (BOOL)convertImage:(NSImage *)image toType:(NSString *)imgFileType destinationDirectoryURL:(NSURL *)dirURL;

@end
