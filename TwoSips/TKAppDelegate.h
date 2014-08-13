//
//  TKAppDelegate.h
//  TwoSips
//
//  Created by Thomas Kober on 5/9/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//
//  The MIT License (MIT)
//
// 	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in the
//	Software without restriction, including without limitation the rights to use, copy,
//	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
//	and to permit persons to whom the Software is furnished to do so, subject to the
//	following conditions:
//
//	The above copyright notice and this permission notice shall be included in all copies
//	or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//	PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//	FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//	OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//	DEALINGS IN THE SOFTWARE.

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
