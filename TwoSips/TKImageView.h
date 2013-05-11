//
//  TKImageView.h
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKImageConverter;

@interface TKImageView : NSImageView

@property(strong, readonly) TKImageConverter *imgConverter;

@end
