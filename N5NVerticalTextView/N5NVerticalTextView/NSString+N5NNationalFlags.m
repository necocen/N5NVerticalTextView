//
//  NSString+N5NNationalFlags.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/11/13.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "NSString+N5NNationalFlags.h"

/// iOSで現在表示される国旗の数
static const int kNumberOfNationalFlags = 10;
/// iOSで現在表示される国旗に対応するISO3166-1の国コード
static char* kNationalFlags[kNumberOfNationalFlags] = {"CN", "DE", "ES", "FR", "GB", "IT", "JP", "KR", "RU", "US"};

/// サロゲート・ペアがRegionalIndicatorであれば対応するアルファベットを、違うときは'\0'を返す
static char isRegionalIndicator(NSString* string)
{
    // RI must be 2 letters
    if([string length] != 2) return 0;
    
    // extract
    unichar c = [string characterAtIndex:0];
    unichar d = [string characterAtIndex:1];
    
    // out of bounds
    if(c != 0xD83C || 0xDDE6 > d || d > 0xDDFF)
        return 0;
    
    // convert into ordinary alphabets
    return (char)((int)d - 0xDDE6 + (int)'A');
}

/// 受けとった文字列がkNationalFlagsに含まれるかどうかを返す
static BOOL isNationalFlag(char* buffer)
{
    for(int i = 0; i < kNumberOfNationalFlags; i++)
    {
        if(strncmp(buffer, kNationalFlags[i], 2) == 0) return YES;
    }
    return NO;
}

@implementation NSString (N5NNationalFlags)

- (NSRange)rangeOfComposedCharacterSequenceAndNationalFlagEmojiAtIndex:(NSUInteger)index
{
    NSRange composedSequenceRange = [self rangeOfComposedCharacterSequenceAtIndex:index];
    
    NSLog(@"%c", isRegionalIndicator([self substringWithRange:composedSequenceRange]));
    
    // For ordinary composed sequence, do nothing.
    if(!isRegionalIndicator([self substringWithRange:composedSequenceRange]))
        return composedSequenceRange;
    return NSMakeRange(0, 0);
}

@end
