//
//  N5NTextRange.h
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Subclass of UITextRange used to indicate a range in the text.
@interface N5NTextRange : UITextRange

/// return a text range which point given range.
/// @param range range to point.
+ (instancetype)textRangeWithRange:(NSRange)range;

/// initialize text range with given range.
/// @param range range to point.
- (instancetype)initWithRange:(NSRange)range;

/// range of pointed text range.
@property (nonatomic, assign) NSRange range;

@end
