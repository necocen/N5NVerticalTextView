//
//  N5NTextRange.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "N5NTextRange.h"

@implementation N5NTextRange

+ (instancetype)textRangeWithRange:(NSRange)range
{
    return [[self alloc] initWithRange:range];
}

- (instancetype)initWithRange:(NSRange)range
{
    self = [super init];
    if(self)
    {
        self.range = range;
    }
    return self;
}

@end
