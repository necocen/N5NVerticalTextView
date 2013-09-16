//
//  NSAttributedString+N5NComposedCharacter.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/17.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "NSAttributedString+N5NComposedCharacter.h"
#import "NSString+N5NComposedCharacter.h"

@implementation NSAttributedString (N5NComposedCharacter)

- (NSAttributedString*)N5N_attributedSubstringFromComposedRange:(NSRange)composedRange
{
    return [self attributedSubstringFromRange:[self.string N5N_decomposedRangeFromComposedRange:composedRange]];
}

- (NSUInteger)N5N_composedLength
{
    return [self.string N5N_composedLength];
}

@end
