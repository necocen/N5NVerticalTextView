//
//  NSString+N5NComposedCharacter.m
//  NSString-N5NComposedCharacter
//
//  Created by κねこせん on 2013/09/12.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "NSString+N5NComposedCharacter.h"

/// iOSで現在表示される国旗の数
static const int kNumberOfNationalFlags = 10;
/// iOSで現在表示される国旗に対応するISO3166-1の国コード
static char* kNationalFlags[kNumberOfNationalFlags] = {"CN", "DE", "ES", "FR", "GB", "IT", "JP", "KR", "RU", "US"};

/// サロゲート・ペアがReginalIndicatorであれば対応するアルファベットを、違うときは'\0'を返す
static char isRegionalIndicator(NSString* string);
/// 受けとった文字列がkNationalFlagsに含まれるかどうかを返す
static BOOL isNationalFlag(char* buffer);

@implementation NSString (N5NComposedCharacter)

#pragma mark - index calculation

- (NSUInteger)N5N_decomposedIndexFromComposedIndex:(NSUInteger)anIndex
{
    NSUInteger composedLength = [self N5N_composedLength];
    if(anIndex == 0) return 0;
    if(anIndex > composedLength) return NSNotFound;
    if(anIndex == composedLength) return [self length];
    
    __block int location = 0;
    __block int decomposedIndex = 0;
    char* buffer = calloc(2, sizeof(char));
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              char c = isRegionalIndicator(substring);
                              if(c) // is RI
                              {
                                  if(buffer[0]) // last letter was RI
                                  {
                                      buffer[1] = c;
                                      if(isNationalFlag(buffer)) // will show flag
                                      {
                                          location++;
                                          buffer[0] = buffer[1] = 0;
                                      }
                                      else // will not show flag
                                      {
                                          location++;
                                          buffer[0] = c;
                                          buffer[1] = 0;
                                      }
                                  }
                                  else // could be first letter of RI
                                  {
                                      buffer[0] = c;
                                  }
                              }
                              else // is not RI
                              {
                                  if(buffer[0]) // last letter was RI
                                  {
                                      buffer[0] = 0;
                                      location += 2;
                                  }
                                  else // last letter was not RI
                                  {
                                      location++;
                                  }
                              }
                              
                              if(location == anIndex)
                              {
                                  if(buffer[0])
                                      decomposedIndex = substringRange.location;
                                  else
                                      decomposedIndex = substringRange.location + substringRange.length;
                                  *stop = YES;
                              }
                              else if(location > anIndex)
                              {
                                  decomposedIndex = substringRange.location;
                                  *stop = YES;
                              }
                          }];
    
    free(buffer); buffer = NULL;
    
    return decomposedIndex;
}

- (NSRange)N5N_decomposedRangeFromComposedRange:(NSRange)aRange
{
    NSUInteger location = [self N5N_decomposedIndexFromComposedIndex:aRange.location];
    if(location == NSNotFound) return NSMakeRange(NSNotFound, 0);
    
    NSUInteger length = [self N5N_decomposedIndexFromComposedIndex:aRange.location + aRange.length] - location;
    return NSMakeRange(location, length);
}

#pragma mark - counterparts of NSString methods

- (NSUInteger)N5N_composedLength
{
    __block int location = 0;
    char* buffer = calloc(2, sizeof(char)); // it is needed to modify in block
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              char c = isRegionalIndicator(substring);
                              if(c) // is RI
                              {
                                  if(buffer[0]) // last letter was RI
                                  {
                                      buffer[1] = c;
                                      if(isNationalFlag(buffer)) // will show flag
                                      {
                                          location++;
                                          buffer[0] = buffer[1] = 0;
                                      }
                                      else // will not show flag
                                      {
                                          location++;
                                          buffer[0] = c;
                                          buffer[1] = 0;
                                      }
                                  }
                                  else // could be first letter of RI
                                  {
                                      buffer[0] = c;
                                  }
                              }
                              else // is not RI
                              {
                                  if(buffer[0]) // last letter was RI
                                  {
                                      buffer[0] = 0;
                                      location += 2;
                                  }
                                  else // last letter was not RI
                                  {
                                      location++;
                                  }
                              }
                          }];
    
    if(buffer[0]) location++;
    
    free(buffer); buffer = NULL;
    
    return location;
}

- (NSString*)N5N_substringInRange:(NSRange)aRange
{
    return [self substringWithRange:[self N5N_decomposedRangeFromComposedRange:aRange]];
}

@end


#pragma mark - static functions

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

static BOOL isNationalFlag(char* buffer)
{
    for(int i = 0; i < kNumberOfNationalFlags; i++)
    {
        if(strncmp(buffer, kNationalFlags[i], 2) == 0) return YES;
    }
    return NO;
}
