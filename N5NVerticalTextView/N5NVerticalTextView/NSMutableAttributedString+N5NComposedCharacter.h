//
//  NSMutableAttributedString+N5NComposedCharacter.h
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/17.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (N5NComposedCharacter)

/// replace characters in the specified character-composed range.
/// @param composedRange character-composed range
/// @param attributedString the attributed string which will replace that in the specified range.
- (void)N5N_replaceCharactersInComposedRange:(NSRange)composedRange
                        withAttributedString:(NSAttributedString *)attributedString;

/// insert attributed string in the specified character-composed range.
/// @param attributedString the attributed string which will be inserted at the specified index.
/// @param composedIndex character-composed index
- (void)N5N_insertAttributedString:(NSAttributedString *)attributedString
                   atComposedIndex:(NSUInteger)composedIndex;

/// delete characters in the specified character-composed range.
/// @param composedRange character-composed range which will be deleted.
- (void)N5N_deleteCharactersInComposedRange:(NSRange)composedRange;

@end
