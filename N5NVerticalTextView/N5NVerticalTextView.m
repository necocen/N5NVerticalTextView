//
//  N5NVerticalTextView.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "N5NVerticalTextView.h"

@interface N5NVerticalTextView () <UIKeyInput, UITextInput, UITextInputDelegate>

@end

@implementation N5NVerticalTextView
{
    
}

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self N5N_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self N5N_commonInit];
    }
    return self;
}


#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

#pragma mark - Private
/// Common intializer
- (id)N5N_commonInit
{
    return self;
}


@end
