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

- (void)N5N_replaceCharactersInComposedRange:(NSRange)composedRange
                                  withString:(NSString*)string
{
    [self replaceCharactersInRange:[self N5N_decomposedRangeFromComposedRange:composedRange] withString:string];
}

- (void)N5N_insertString:(NSString*)string
         atComposedIndex:(NSUInteger)composedIndex
{
    [self insertString:string atIndex:[self N5N_decomposedIndexFromComposedIndex:composedIndex]];
}

- (void)N5N_deleteCharactersInComposedRange:(NSRange)composedRange
{
    [self deleteCharactersInRange:[self N5N_decomposedRangeFromComposedRange:composedRange]];
}

@end
