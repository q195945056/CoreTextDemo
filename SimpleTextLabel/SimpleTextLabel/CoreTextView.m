//
//  CoreTextView.m
//  SimpleTextLabel
//
//  Created by yanmingjun on 16/3/23.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import "CoreTextView.h"
#import <CoreText/CoreText.h>

@implementation CoreTextView

- (void)drawRect:(CGRect)rect {
    CFStringRef string = CFSTR("hello, world!");
    CTFontRef font = (__bridge CTFontRef)([UIFont systemFontOfSize:15]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Initialize the string, font, and context
    
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    
    CFDictionaryRef attributes =
    CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                       (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                       &kCFTypeDictionaryKeyCallBacks,
                       &kCFTypeDictionaryValueCallBacks);
    
    CFAttributedStringRef attrString =
    CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CFRelease(string);
    CFRelease(attributes);
    
    CTLineRef line = CTLineCreateWithAttributedString(attrString);
    
    // Set text position and draw the line into the graphics context
    CGContextSetTextPosition(context, 10.0, 10.0);
    CTLineDraw(line, context);
    CFRelease(line);

}

@end
