//
//  N5NTextPosition.h
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Subclass of UITextPosition used to indicate a position in the text.
@interface N5NTextPosition : UITextPosition

/// return a text position which point given index in the text.
/// @param index index to point.
+ (instancetype)textPositionWithIndex:(NSUInteger)index;

/// initialize text position with given index.
/// @param index index to point.
- (instancetype)initWithIndex:(NSUInteger)index;

/// index of pointed position
@property (nonatomic, assign) NSUInteger index;

@end
