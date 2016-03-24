//
//  CoreTextView.m
//  ManualLineBreaking
//
//  Created by 严明俊 on 16/3/24.
//  Copyright © 2016年 严明俊. All rights reserved.
//

#import "CoreTextView.h"
#import <CoreText/CoreText.h>

@implementation CoreTextView

- (void)drawRect:(CGRect)rect {
    double width = rect.size.width * 0.5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGPoint textPosition = CGPointMake(10, 200);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."];
    CFAttributedStringRef attrString = (__bridge CFAttributedStringRef)attributedString;
    // Initialize those variables.
    
    // Create a typesetter using the attributed string.
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(attrString);
    
    // Find a break for line from the beginning of the string to the given width.
    CFIndex start = 0;
    
    while (start < attributedString.length) {
        CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, width);
        
        // Use the returned character count (to the break) to create the line.
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        
        // Get the offset needed to center the line.
        float flush = 0.5; // centered
        double penOffset = CTLineGetPenOffsetForFlush(line, flush, width);
        
        // Move the given text drawing position by the calculated offset and draw the line.
        CGContextSetTextPosition(context, textPosition.x + penOffset, textPosition.y);
        CTLineDraw(line, context);
        
        // Move the index beyond the line break.
        start += count;
        textPosition.y -= CTLineGetBoundsWithOptions(line, kCTLineBoundsExcludeTypographicLeading).size.height;
    }
}


@end
