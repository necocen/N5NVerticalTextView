//
//  NSString_N5NNationalFlagsTest.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/11/13.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+N5NNationalFlags.h"

@interface NSString_N5NNationalFlagsTest : XCTestCase

@end

@implementation NSString_N5NNationalFlagsTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRangeOfComposedCharacterSequenceAndNationalFlagEmojiAtIndex
{
    NSString* string = @"abc🇯🇵🇮🇹🇯🇯🇯🇫🇷🇺🇸";
    XCTAssertEqual(NSMakeRange(0, 1), [string rangeOfComposedCharacterSequenceAndNationalFlagEmojiAtIndex:0], @"Fail");
    XCTAssertEqual(NSMakeRange(3, 2), [string rangeOfComposedCharacterSequenceAndNationalFlagEmojiAtIndex:4], @"Fail");
}

@end
