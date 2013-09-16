//
//  N5NTextRange.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "N5NTextRange.h"
#import "N5NTextPosition.h"

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

- (UITextPosition*)start
{
    return [N5NTextPosition textPositionWithIndex:self.range.location];
}

- (UITextPosition*)end
{
    return [N5NTextPosition textPositionWithIndex:self.range.location + self.range.length];
}

- (BOOL)isEmpty
{
    return (self.range.length == 0);
}

@end
