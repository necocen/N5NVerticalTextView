//
//  NSString+N5NComposedCharacter.h
//  NSString-N5NComposedCharacter
//
//  Created by κねこせん on 2013/09/12.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

@import Foundation;

/**
 絵文字の使われた文字列に対応するためのカテゴリです
 */
@interface NSString (N5NComposedCharacter)

/**
  結合文字を一字として扱う文字列位置を受けとって、元の文字列位置を返します

 @param anIndex 結合文字を一字として扱う文字列位置
 @return 結合文字を展開したときの文字列位置
 */
- (NSUInteger)N5N_decomposedIndexFromComposedIndex:(NSUInteger)anIndex;

/**
 結合文字を一字として扱う文字列範囲を受けとって、元の文字列範囲を返します
 
 @param aRange 結合文字を一字として扱う文字列範囲
 @return 結合文字を展開したときの文字列範囲
 */
- (NSRange)N5N_decomposedRangeFromComposedRange:(NSRange)aRange;

/**
 結合文字を一字として扱うaRangeの範囲の文字列を返します
 
 @param aRange 結合文字を一字として扱う文字列の範囲
 @return 結合文字を展開したときの文字列
 */
- (NSString*)N5N_substringInRange:(NSRange)aRange;

/**
 結合文字を一字として扱うときの文字列の長さを返します
 @return 結合文字を展開したときの文字列の長さ
 */
- (NSUInteger)N5N_composedLength;

@end
