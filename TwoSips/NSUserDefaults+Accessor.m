//
//  NSUserDefaults+Accessor.m
//  TwoSips
//
//  Created by Thomas Kober on 5/12/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import "NSUserDefaults+Accessor.h"

@implementation NSUserDefaults (Accessor)

- (NSString *)outputImageType
{
    return [self valueForKey:kOutputImageType];
}
- (void)setOutputImageType:(NSString *)outType
{
    [self setValue:outType forKey:kOutputImageType];
}

@end
