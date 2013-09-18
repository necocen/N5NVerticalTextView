//
//  N5NVerticalTextContentView.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/19.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "N5NVerticalTextContentView.h"

@implementation N5NVerticalTextContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.layer.geometryFlipped = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.delegate N5N_drawContentInRect:rect inContext:UIGraphicsGetCurrentContext()];
}


@end
