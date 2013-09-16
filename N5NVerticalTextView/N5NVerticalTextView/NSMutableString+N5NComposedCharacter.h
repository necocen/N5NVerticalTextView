//
//  NSMutableString+N5NComposedCharacter.h
//  NSMutableString-N5NComposedCharacter
//
//  Created by κねこせん on 2013/09/11.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 絵文字の使われた文字列に対応するためのカテゴリです
 */
@interface NSMutableString (N5NComposedCharacter)

/**
 結合文字を一字として扱うaRangeの範囲の文字列をaStringで置き換えます

 @param composedRange  結合文字を一字として扱う文字列の範囲
 @param string 置き換える文字列
 */
- (void)N5N_replaceCharactersInComposedRange:(NSRange)composedRange
                                  withString:(NSString*)string;

/**
 結合文字を一字として扱うanIndexの位置にaStringを挿入します
 
 @param string 挿入する文字列
 @param composedIndex 結合文字を一字として扱う文字列の位置
 */
- (void)N5N_insertString:(NSString*)string
         atComposedIndex:(NSUInteger)composedIndex;

/**
 結合文字を一字として扱うaRangeの範囲の文字列を削除します
 
 @param composedRange 結合文字を一字として扱う文字列の範囲
 */
- (void)N5N_deleteCharactersInComposedRange:(NSRange)composedRange;

@end
