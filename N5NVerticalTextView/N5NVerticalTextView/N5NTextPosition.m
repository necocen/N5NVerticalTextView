//
//  N5NTextPosition.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "N5NTextPosition.h"

@implementation N5NTextPosition

+ (instancetype)textPositionWithIndex:(NSUInteger)index
{
    return [[self alloc] initWithIndex:index];
}

- (instancetype)initWithIndex:(NSUInteger)index
{
    self = [super init];
    if(self)
    {
        self.index = index;
    }
    return self;
}

@end
