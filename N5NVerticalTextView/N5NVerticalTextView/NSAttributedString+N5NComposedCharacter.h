//
//  NSAttributedString+N5NComposedCharacter.h
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/17.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (N5NComposedCharacter)

/// attributedString within given character-composed range.
/// @param composedRange character-composed range.
- (NSAttributedString*)N5N_attributedSubstringFromComposedRange:(NSRange)composedRange;

/// return character-composed length.
- (NSUInteger)N5N_composedLength;

@end
