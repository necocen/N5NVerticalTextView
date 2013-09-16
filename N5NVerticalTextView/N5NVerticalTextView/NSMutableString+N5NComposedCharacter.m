//
//  NSMutableString+N5NComposedCharacter.m
//  NSMutableString-N5NComposedCharacter
//
//  Created by κねこせん on 2013/09/11.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "NSMutableString+N5NComposedCharacter.h"
#import "NSString+N5NComposedCharacter.h"



@implementation NSMutableString (N5NComposedCharacter)

- (void)N5N_replaceCharactersInComposedRange:(NSRange)aRange
                                  withString:(NSString*)aString
{
    [self replaceCharactersInRange:[self N5N_decomposedRangeFromComposedRange:aRange] withString:aString];
}

- (void)N5N_insertString:(NSString*)aString
         atComposedIndex:(NSUInteger)anIndex
{
    [self insertString:aString atIndex:[self N5N_decomposedIndexFromComposedIndex:anIndex]];
}

- (void)N5N_deleteCharactersInComposedRange:(NSRange)aRange
{
    [self deleteCharactersInRange:[self N5N_decomposedRangeFromComposedRange:aRange]];
}

@end
