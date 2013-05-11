//
//  TKAppDelegate.h
//  TwoSips
//
//  Created by Thomas Kober on 5/9/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

// App Icon: http://www.iconarchive.com/show/i-love-you-icons-by-kzzu/Coffee-icon.html
// Drop Here Img: http://iconify.it/icon/target/

#import <Cocoa/Cocoa.h>

@class TKImageConverter;

@interface TKAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imgDropHere;
@property (assign) IBOutlet NSTextField *lblOutputFolder;
@property (assign) IBOutlet NSTextField *txtOutputFolder;
@property (assign) IBOutlet NSButton *btnOpenFileDialog;
@property (assign) IBOutlet NSTextField *lblOutputFormat;
@property (assign) IBOutlet NSComboBox *cmbOutputFormat;
@property (assign) IBOutlet NSButton *btnConvert;
@property (assign) IBOutlet NSTextField *lblProgress;
@property (assign) IBOutlet NSProgressIndicator *piProgress;
@property (assign) IBOutlet NSTextField *lblProgressText;

@property (strong, readonly) TKImageConverter *imgConverter;

- (IBAction)handleOpenFileDialogClicked:(id)sender;

- (IBAction)handleConvertClicked:(id)sender;

- (IBAction)handleResourceDropped:(id)sender;

@end
