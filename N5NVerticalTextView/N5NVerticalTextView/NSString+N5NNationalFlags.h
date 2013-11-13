//
//  NSString+N5NNationalFlags.h
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/11/13.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <Foundation/Foundation.h>

/// @category Category to handle national flags emoji.
@interface NSString (N5NNationalFlags)

/// Returns the range in the receiver of the composed character sequence and national flag emoji located at a given index.
/// @param index The index of a character in the receiver.
- (NSRange)rangeOfComposedCharacterSequenceAndNationalFlagEmojiAtIndex:(NSUInteger)index;

@end
