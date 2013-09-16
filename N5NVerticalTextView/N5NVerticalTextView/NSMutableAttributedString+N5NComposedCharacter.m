//
//  NSMutableAttributedString+N5NComposedCharacter.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/17.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "NSMutableAttributedString+N5NComposedCharacter.h"
#import "NSString+N5NComposedCharacter.h"

@implementation NSMutableAttributedString (N5NComposedCharacter)

- (void)N5N_replaceCharactersInComposedRange:(NSRange)composedRange
                        withAttributedString:(NSAttributedString *)attributedString
{
    [self replaceCharactersInRange:[self.string N5N_decomposedRangeFromComposedRange:composedRange] withAttributedString:attributedString];
}

- (void)N5N_insertAttributedString:(NSAttributedString *)attributedString
                   atComposedIndex:(NSUInteger)composedIndex
{
    [self insertAttributedString:attributedString atIndex:[self.string N5N_decomposedIndexFromComposedIndex:composedIndex]];
}

- (void)N5N_deleteCharactersInComposedRange:(NSRange)composedRange
{
    [self deleteCharactersInRange:[self.string N5N_decomposedRangeFromComposedRange:composedRange]];
}

@end
