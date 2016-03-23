//
//  CoreTextView.m
//  ColumnarLayout
//
//  Created by yanmingjun on 16/3/23.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import "CoreTextView.h"
#import <CoreText/CoreText.h>

@implementation CoreTextView

- (CFArrayRef)createColumnsWithColumnCount:(int)columnCount
{
    int column;
    
    CGRect* columnRects = (CGRect*)calloc(columnCount, sizeof(*columnRects));
    // Set the first column to cover the entire view.
    columnRects[0] = self.bounds;
    
    // Divide the columns equally across the frame's width.
    CGFloat columnWidth = CGRectGetWidth(self.bounds) / columnCount;
    for (column = 0; column < columnCount - 1; column++) {
        CGRectDivide(columnRects[column], &columnRects[column],
                     &columnRects[column + 1], columnWidth, CGRectMinXEdge);
    }
    
    // Inset all columns by a few pixels of margin.
    for (column = 0; column < columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column], 8.0, 15.0);
    }
    
    // Create an array of layout paths, one for each column.
    CFMutableArrayRef array =
    CFArrayCreateMutable(kCFAllocatorDefault,
                         columnCount, &kCFTypeArrayCallBacks);
    
    for (column = 0; column < columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    free(columnRects);
    return array;
}

// Override drawRect: to draw the attributed string into columns.
// (In OS X, the drawRect: method of NSView takes an NSRect parameter,
//  but that parameter is not used in this listing.)
- (void)drawRect:(CGRect)rect
{
    // Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context coordinates in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Initializing a graphic context in OS X is different:
    // CGContextRef context =
    //     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           (CFAttributedStringRef)self.attributedString);
    
    // Call createColumnsWithColumnCount function to create an array of
    // three paths (columns).
    CFArrayRef columnPaths = [self createColumnsWithColumnCount:3];
    
    CFIndex pathCount = CFArrayGetCount(columnPaths);
    CFIndex startIndex = 0;
    int column;
    
    // Create a frame for each column (path).
    for (column = 0; column < pathCount; column++) {
        // Get the path for this column.
        CGPathRef path = (CGPathRef)CFArrayGetValueAtIndex(columnPaths, column);
        
        // Create a frame for this column and draw it.
        CTFrameRef frame = CTFramesetterCreateFrame(
                                                    framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        
        // Start the next frame at the first character not visible in this frame.
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
        
    }
    CFRelease(columnPaths);
    CFRelease(framesetter);
    
}

@end
