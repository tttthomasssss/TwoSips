//
//  TKImageView.h
//  TwoSips
//
//  Created by Thomas Kober on 5/11/13.
//  Copyright (c) 2013 tttthomasssss. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKImageConverter;

// TODO: Use NSView instead of NSImageView
// http://juliuspaintings.co.uk/cgi-bin/paint_css/animatedPaint/072-NSView-drag-and-drop.pl
// http://stackoverflow.com/questions/4782636/nsview-subviews-interrupting-drag-operation
// http://stackoverflow.com/questions/1589010/drag-and-drop-app-files-into-nsimageview-and-get-the-file-path
// http://www.developers-life.com/tutorial-drag-and-drop-file-on-nsimageview.html
// Display image in nsview
// http://stackoverflow.com/questions/1257452/drawing-an-image-in-a-nsview
// http://stackoverflow.com/questions/2203542/drawing-a-nsimage-into-nsview-subclass
// Draw border
// http://stackoverflow.com/questions/5004960/adding-border-and-rounded-rect-in-the-nsview
@interface TKImageView : NSView//NSImageView

@property(strong, readonly, nonatomic) NSImage *image;
@property(strong, readonly, nonatomic) TKImageConverter *imgConverter;

@end
