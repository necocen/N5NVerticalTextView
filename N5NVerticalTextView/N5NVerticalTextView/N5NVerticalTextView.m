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

#import "N5NVerticalTextContentView.h"
#import "N5NTextPosition.h"
#import "N5NTextRange.h"

#import <CoreText/CoreText.h>

@interface N5NVerticalTextView () <UITextInputTraits, N5NVerticalTextContentViewDelegate>

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
    
    id<UITextInputTokenizer> _textInputTokenizer;
    id<UITextInputDelegate> _textInputDelegate;
    
    /// content view
    N5NVerticalTextContentView* _contentView;
}

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self N5N_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self N5N_commonInit];
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
        [_string N5N_replaceCharactersInComposedRange:markedRange withAttributedString:[[NSAttributedString alloc] initWithString:text attributes:_defaultAttributes]];
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


#pragma mark - UITextInput
- (UITextPosition*)beginningOfDocument
{
    return [N5NTextPosition textPositionWithIndex:0];
}

- (UITextPosition*)endOfDocument
{
    return [N5NTextPosition textPositionWithIndex:[_string.string N5N_composedLength]];
}

- (UITextRange*)textRangeFromPosition:(UITextPosition *)fromPosition
                           toPosition:(UITextPosition *)toPosition
{
    N5NTextPosition* fromN5NPosition = (N5NTextPosition*)fromPosition;
    N5NTextPosition* toN5NPosition = (N5NTextPosition*)toPosition;
    NSRange range = NSMakeRange(MIN(fromN5NPosition.index, toN5NPosition.index), ABS(toN5NPosition.index - fromN5NPosition.index));
    return [N5NTextRange textRangeWithRange:range];
}

- (UITextPosition*)positionFromPosition:(UITextPosition *)position
                                 offset:(NSInteger)offset
{
    NSInteger end = ((N5NTextPosition*)position).index + offset;
    if(end > [_string.string N5N_composedLength] || end < 0)
    {
        // TODO: NSUInteger or NSInteger?
    }
    return nil;
}


#pragma mark - Property Accessors
- (NSString *)text
{
    return [_string.string copy];
}

- (void)setText:(NSString *)text
{
    [self.inputDelegate textWillChange:self];
    
    _string = [[[NSAttributedString alloc] initWithString:text attributes:_defaultAttributes] mutableCopy];
    [self N5N_textChanged];
    
    [self.inputDelegate textDidChange:self];
}

- (NSAttributedString *)attributedString
{
    return [_string copy];
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    [self.inputDelegate textWillChange:self];

    _string = [attributedString mutableCopy];
    [self N5N_textChanged];
    
    [self.inputDelegate textDidChange:self];
}

- (void)setSelectedRange:(NSRange)selectedRange
{
    _selectedRange = selectedRange;
    [self N5N_selectionChanged];
}

- (void)setMarkedRange:(NSRange)markedRange
{
    _markedRange = markedRange;
    [self N5N_selectionChanged];
}

- (UITextRange*)selectedTextRange
{
    UITextRange* textRange;
    @synchronized(self) /// atomic property.
    {
        textRange = [N5NTextRange textRangeWithRange:self.selectedRange];
    }
    return textRange;
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
    @synchronized(self) /// atomic property.
    {
        self.selectedRange = ((N5NTextRange*)selectedTextRange).range;
    }
}

- (UITextRange*)markedTextRange
{
    return [N5NTextRange textRangeWithRange:self.markedRange];
}

- (id<UITextInputTokenizer>)tokenizer
{
    return _textInputTokenizer;
}

- (id<UITextInputDelegate>)inputDelegate
{
    return _textInputDelegate;
}

- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate
{
    _textInputDelegate = inputDelegate;
}


#pragma mark - Private
/// Common intializer
- (void)N5N_commonInit
{
    _string = [[NSMutableAttributedString alloc] init];
    _defaultAttributes = @{};
    
    self.font = [UIFont systemFontOfSize:17];
    self.editable = YES;
    
    _textInputTokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
    
    // set content view
    _contentView = [[N5NVerticalTextContentView alloc] initWithFrame:self.bounds];
    _contentView.delegate = self;
    
    // tap gesture recognizer
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(N5N_tapGestureRecognized:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
}

/// re-draw/re-calculate the new text.
- (void)N5N_textChanged
{
    
}

/// selected range has changed.
- (void)N5N_selectionChanged
{
    
}


#pragma mark - Drawing
- (void)N5N_drawContentInRect:(CGRect)rect
                    inContext:(CGContextRef)context
{
    
}


#pragma mark - Gestures
- (void)N5N_tapGestureRecognized:(UITapGestureRecognizer*)recognizer
{
    if(self.editable && ![self isFirstResponder])
    {
        [self becomeFirstResponder];
        return;
    }
}


#pragma mark - Override UIResponder method
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
