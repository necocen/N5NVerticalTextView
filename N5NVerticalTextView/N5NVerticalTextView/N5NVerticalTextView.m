//
//  N5NVerticalTextView.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "N5NVerticalTextView.h"

#import "NSString+N5NComposedCharacter.h"
#import "NSMutableAttributedString+N5NComposedCharacter.h"

#import <CoreText/CoreText.h>

@interface N5NVerticalTextView () <UITextInput, UITextInputTraits>

/// Text range for selection.
@property (nonatomic, assign) NSRange selectedRange;
/// Text range for mark.
@property (nonatomic, assign) NSRange markedRange;

@end

@implementation N5NVerticalTextView
{
    /// input string
    NSMutableAttributedString* _string;
    /// default attributes
    NSDictionary* _defaultAttributes;
}

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self N5N_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self N5N_commonInit];
    }
    return self;
}

#pragma mark - UIKeyInput
- (BOOL)hasText
{
    return ([_string length] > 0);
}

- (void)deleteBackward
{
    NSRange selectedRange = self.selectedRange;
    NSRange markedRange = self.markedRange;
    
    if(markedRange.location != NSNotFound) // has marked text.
    {
        [_string N5N_deleteCharactersInComposedRange:markedRange];
        selectedRange.location = markedRange.location;
        selectedRange.length = 0;
        markedRange = NSMakeRange(NSNotFound, 0);
    }
    else if(selectedRange.length > 0) // has non-zero selection
    {
        [_string N5N_deleteCharactersInComposedRange:selectedRange];
        selectedRange.length = 0;
    }
    else if(selectedRange.location > 0) // has zero selection(caret)
    {
        selectedRange.location--;
        selectedRange.length = 1;
        [_string N5N_deleteCharactersInComposedRange:selectedRange];
        selectedRange.length = 0;
    }
    
    self.selectedRange = selectedRange;
    self.markedRange = markedRange;
}

- (void)insertText:(NSString *)text
{
    NSRange selectedRange = self.selectedRange;
    NSRange markedRange = self.markedRange;

    if(markedRange.location != NSNotFound) // has marked text
    {
        [_string N5N_replaceCharactersInComposedRange:markedRange withAttributedString:nil];
        selectedRange.location = markedRange.location + [text N5N_composedLength];
        selectedRange.length = 0;
        markedRange = NSMakeRange(NSNotFound, 0);
    }
    else if(selectedRange.length > 0) // has non-zero selection
    {
        [_string N5N_replaceCharactersInComposedRange:selectedRange withAttributedString:[[NSAttributedString alloc] initWithString:text attributes:_defaultAttributes]];
        selectedRange.length = 0;
        selectedRange.location += [text N5N_composedLength];
    }
    self.selectedRange = selectedRange;
    self.markedRange = markedRange;
}


#pragma mark - Drawing
// TODO: todo


#pragma mark - Private
/// Common intializer
- (id)N5N_commonInit
{
    _string = [[NSMutableAttributedString alloc] init];
    _defaultAttributes = @{};
    return self;
}


@end
