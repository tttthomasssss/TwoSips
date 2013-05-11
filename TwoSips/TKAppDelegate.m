//
//  TKAppDelegate.m
//  TwoSips
//
//  Created by Thomas Kober on 5/9/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import "TKAppDelegate.h"
#import "TKImageConverter.h"

@implementation TKAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // TODO: Or use last one used (read from plist)
    [_cmbOutputFormat selectItemAtIndex:3];
    
    _imgConverter = [[TKImageConverter alloc] init];
}

# pragma mark - UI Actions
- (IBAction)handleOpenFileDialogClicked:(id)sender
{
    
}

- (IBAction)handleConvertClicked:(id)sender
{
    
}

- (IBAction)handleResourceDropped:(id)sender
{
    
}

@end
