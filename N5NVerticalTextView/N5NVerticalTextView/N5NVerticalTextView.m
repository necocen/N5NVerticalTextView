//
//  N5NVerticalTextView.m
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import "N5NVerticalTextView.h"

#import "NSString+N5NComposedCharacter.h"
#import "NSMutableString+N5NComposedCharacter.h"

#import "N5NVerticalTextContentView.h"
#import "N5NTextPosition.h"
#import "N5NTextRange.h"

#import <CoreText/CoreText.h>

/// キャレットの太さ
static const CGFloat kCaretThickness = 3;

@interface N5NVerticalTextView () <UITextInputTraits, N5NVerticalTextContentViewDelegate>

/// Text range for selection.
@property(nonatomic, assign) NSRange selectedRange;
/// Text range for mark.
@property(nonatomic, assign) NSRange markedRange;

@end

@implementation N5NVerticalTextView
{
    /// input string
    NSMutableString* _string;
    /// font
    UIFont* _font;
    /// color
    UIColor* _color;
    /// attributes(internal)
    NSDictionary* _attributes;
    
    id<UITextInputTokenizer> _textInputTokenizer;
    id<UITextInputDelegate> _textInputDelegate;
    
    /// content view
    N5NVerticalTextContentView* _contentView;
    
    /// CoreText Framesetter
    CTFramesetterRef _framesetter;
    /// CoreText Frame
    CTFrameRef _frame;
}

#pragma mark - Init and dealloc
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

- (void)dealloc
{
    if(_framesetter) CFRelease(_framesetter);
    if(_frame) CFRelease(_frame);
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
    
    [self N5N_textChanged];
}

- (void)insertText:(NSString *)text
{
    NSRange selectedRange = self.selectedRange;
    NSRange markedRange = self.markedRange;

    if(markedRange.location != NSNotFound) // has marked text
    {
        [_string N5N_replaceCharactersInComposedRange:markedRange withString:text];
        selectedRange.location = markedRange.location + [text N5N_composedLength];
        selectedRange.length = 0;
        markedRange = NSMakeRange(NSNotFound, 0);
    }
    else if(selectedRange.length > 0) // has non-zero selection
    {
        [_string N5N_replaceCharactersInComposedRange:selectedRange withString:text];
        selectedRange.length = 0;
        selectedRange.location += [text N5N_composedLength];
    }
    else
    {
        [_string N5N_insertString:text atComposedIndex:selectedRange.location];
        selectedRange.location += [text N5N_composedLength];
    }
    self.selectedRange = selectedRange;
    self.markedRange = markedRange;
    
    [self N5N_textChanged];
}


#pragma mark - UITextInput - Replacing and Returning Text
- (NSString*)textInRange:(UITextRange*)range
{
    NSRange textRange = ((N5NTextRange*)range).range;
    return [_string N5N_substringInComposedRange:textRange];
}

- (void)replaceRange:(UITextRange*)range
            withText:(NSString *)text
{
    NSRange textRange = ((N5NTextRange*)range).range;
    [_string N5N_replaceCharactersInComposedRange:textRange withString:text];
}


#pragma mark - UITextInput - Working with Marked and Selected Text
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

- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
{
    _markedTextStyle = [markedTextStyle copy];
    // TODO: rewdraw marked text
}

- (void)setMarkedText:(NSString*)markedText
        selectedRange:(NSRange)selectedRange
{
    NSRange selectedTextRange = self.selectedRange;
    NSRange markedTextRange = self.markedRange;

    if(markedTextRange.location != NSNotFound)
    {
        if(!markedText) markedText = @"";
        [_string N5N_replaceCharactersInComposedRange:markedTextRange withString:markedText];
        markedTextRange.length = markedText.length;
    }
    else if(selectedTextRange.length > 0)
    {
        [_string N5N_replaceCharactersInComposedRange:selectedTextRange withString:markedText];
        markedTextRange.location = selectedTextRange.location;
        markedTextRange.length = markedText.length;
    }
    else
    {
        [_string N5N_insertString:markedText atComposedIndex:selectedTextRange.location];
        markedTextRange.location = selectedTextRange.location;
        markedTextRange.length = markedText.length;
    }

    selectedTextRange = NSMakeRange(markedTextRange.location + selectedRange.location, selectedTextRange.length);
    
    [self N5N_textChanged];
    
    self.selectedRange = selectedTextRange;
    self.markedRange = markedTextRange;
}

- (void)unmarkText
{
    NSRange markedTextRange = self.markedRange;
    markedTextRange.location = NSNotFound;
    self.markedRange = markedTextRange;
}


#pragma mark - UITextInput - Computing Text Ranges and Text Positions
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
    // WARN: ignoring out-of-bound newIndex.
    NSInteger newIndex = ((N5NTextPosition*)position).index + offset;
    if(newIndex > [_string N5N_composedLength] || newIndex < 0)
        return nil;
    
    return [N5NTextPosition textPositionWithIndex:newIndex];
}

- (UITextPosition*)positionFromPosition:(UITextPosition*)position
                            inDirection:(UITextLayoutDirection)direction
                                 offset:(NSInteger)offset
{
    NSInteger index = ((N5NTextPosition*)position).index;
    switch(direction)
    {
        case UITextLayoutDirectionUp:
            index += offset;
            break;
        case UITextLayoutDirectionDown:
            index -= offset;
            break;
        case UITextLayoutDirectionLeft:
        case UITextLayoutDirectionRight:
            // TODO: support left/right offset.
            break;
    }

    // boundary case
    if(index < 0) index = 0;
    if(index >= [_string N5N_composedLength]) index = [_string N5N_composedLength];

    return [N5NTextPosition textPositionWithIndex:index];
}

- (UITextPosition*)beginningOfDocument
{
    return [N5NTextPosition textPositionWithIndex:0];
}

- (UITextPosition*)endOfDocument
{
    return [N5NTextPosition textPositionWithIndex:[_string N5N_composedLength]];
}


#pragma mark - UITextInput - Evaluating Text Positions
- (NSComparisonResult)comparePosition:(UITextPosition*)position
                           toPosition:(UITextPosition*)other
{
    NSUInteger index = ((N5NTextPosition*)position).index;
    NSUInteger otherIndex = ((N5NTextPosition*)other).index;
    
    if(index < otherIndex)
        return NSOrderedAscending;
    else if(index > otherIndex)
        return NSOrderedDescending;
    return NSOrderedSame;
}

- (NSInteger)offsetFromPosition:(UITextPosition*)fromPosition
                     toPosition:(UITextPosition*)toPosition
{
    NSInteger fromIndex = ((N5NTextPosition*)fromPosition).index;
    NSInteger toIndex = ((N5NTextPosition*)toPosition).index;
    return (toIndex - fromIndex);
}


#pragma mark - UITextInput - Determining Layout and Writing Direction

- (UITextRange*)characterRangeByExtendingPosition:(UITextPosition*)position
                                      inDirection:(UITextLayoutDirection)direction
{
    // TODO: たぶんこれじゃだめ（なんに使ってるのかわからないけど）
    NSInteger index = ((N5NTextPosition*)position).index;
    switch(direction)
    {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionRight:
            if(index == 0)
                return [N5NTextRange textRangeWithRange:NSMakeRange(0, 1)];
            else
                return [N5NTextRange textRangeWithRange:NSMakeRange(index - 1, 1)];
            break;
        case UITextLayoutDirectionDown:
        case UITextLayoutDirectionLeft:
            if(index == [_string N5N_composedLength] - 1)
                return [N5NTextRange textRangeWithRange:NSMakeRange([_string N5N_composedLength] - 1, 1)];
            else
                return [N5NTextRange textRangeWithRange:NSMakeRange(index + 1, 1)];
    }
}

- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition*)position
                                              inDirection:(UITextStorageDirection)direction
{
    // TODO: これでいいの？
    return UITextWritingDirectionRightToLeft;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection
                       forRange:(UITextRange*)range
{
    // do nothing.
    // TODO: 必要？
}


#pragma mark - UITextInput - Geometry and Hit-Testing Methods
- (CGRect)firstRectForRange:(UITextRange*)range
{
    NSRange decomposedRange = [_string N5N_decomposedRangeFromComposedRange:((N5NTextRange*)range).range];
    NSArray* lines = (NSArray *) CTFrameGetLines(_frame);
    NSInteger lineCount = [lines count];

    for(NSInteger i = 0; i < lineCount; i++)
    {
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        CFRange lineRange = CTLineGetStringRange(line);
        
        if(decomposedRange.location >= lineRange.location && lineRange.location + lineRange.length > decomposedRange.location)
        {
            NSInteger finalIndex = MIN(lineRange.location + lineRange.length, decomposedRange.location + decomposedRange.length);
            
            CGFloat yStart = CTLineGetOffsetForStringIndex(line, decomposedRange.location, NULL);
            CGFloat yEnd = CTLineGetOffsetForStringIndex(line, finalIndex, NULL);
            
            CGPoint lineOrigin;
            CTFrameGetLineOrigins(_frame, CFRangeMake(i, 1), &lineOrigin);
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            // TODO: これはほんとうに正しいのか？
            CGRect contentRect = CGRectMake(lineOrigin.y + ascent, lineOrigin.x - yStart, ascent + descent, yEnd - yStart);
            return [_contentView convertRect:contentRect toView:self];
        }
    }
    return CGRectZero;
}

- (CGRect)caretRectForPosition:(UITextPosition*)position
{
    NSUInteger decomposedIndex = [_string N5N_decomposedIndexFromComposedIndex:((N5NTextPosition*)position).index];
    if([_string N5N_composedLength] == 0 || decomposedIndex == 0)
    {
        CGPoint origin = CGPointMake(CGRectGetMaxX(_contentView.bounds) - _font.leading, CGRectGetMinY(_contentView.bounds));
        return CGRectMake(origin.x, origin.y, _font.ascender + fabs(_font.descender), kCaretThickness);
    }
    
    NSArray* lines = (NSArray *) CTFrameGetLines(_frame);
    NSInteger lineCount = [lines count];
    
    if(decomposedIndex == [_string length] && [_string characterAtIndex:decomposedIndex - 1] == '\n') // at the new line
    {
        CTLineRef line = (__bridge CTLineRef)lines[lineCount - 1];
        CFRange lineRange = CTLineGetStringRange(line);
        CGFloat yPos = CTLineGetOffsetForStringIndex(line, lineRange.location, NULL);
        CGFloat ascent, descent;
        CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
        CGPoint origin;
        CTFrameGetLineOrigins(_frame, CFRangeMake(lineCount - 1, 1), &origin);
        origin.y -= _font.leading;
        
        // こっちは変換しなくていいの？
        // 自信がない計算
        return CGRectMake(_contentView.bounds.size.width - (origin.y + descent), _contentView.bounds.size.height - (origin.x + yPos), ascent + descent, kCaretThickness);
    }

    for(int i = 0; i < lineCount; i++)
    {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CFRange lineRange = CTLineGetStringRange(line);
        if(lineRange.location <= decomposedIndex && decomposedIndex <= lineRange.location + lineRange.length)
        {
            CGFloat yPos = CTLineGetOffsetForStringIndex(line, decomposedIndex, NULL);
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGPoint origin;
            CTFrameGetLineOrigins(_frame, CFRangeMake(i, 1), &origin);
            
            return CGRectMake(origin.y - descent, yPos, ascent + descent, kCaretThickness);
        }
    }
    
    return CGRectNull;
}


#pragma mark - UITextInput - Text Input Delegate and Text Input Tokenizer

#pragma mark - Property Accessors
- (NSString *)text
{
    return [_string copy];
}

- (void)setText:(NSString *)text
{
//    [self.inputDelegate textWillChange:self];
    
    _string = [[[NSAttributedString alloc] initWithString:text attributes:_attributes] mutableCopy];
    [self N5N_textChanged];
    
//    [self.inputDelegate textDidChange:self];
}

- (UIFont*)font
{
    return _font;
}

- (void)setFont:(UIFont*)font
{
    _font = font;
    [self N5N_configureAttributes];
}

- (UIColor*)color
{
    return _color;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self N5N_configureAttributes];
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

- (void)setContentSize:(CGSize)contentSize
{
    // Do nothing.
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
    _string = [[NSMutableString alloc] init];
    _font = [UIFont fontWithName:@"HiraKakuProN-W3" size:17];
    _color = [UIColor blackColor];
    [self N5N_configureAttributes];
    
    self.editable = YES;
    
//    _textInputTokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
    
    // set content view
    _contentView = [[N5NVerticalTextContentView alloc] initWithFrame:self.bounds];
    _contentView.delegate = self;
    [self addSubview:_contentView];
    
    // tap gesture recognizer
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(N5N_tapGestureRecognized:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
}

/// re-draw/re-calculate the new text.
- (void)N5N_textChanged
{
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:_string attributes:_attributes];
    
    if(_framesetter) CFRelease(_framesetter);
    _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    

    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(_contentView.frame.size.height, CGFLOAT_MAX), NULL);
    
    // if last letter of the string is linebreak, add additional space for ner line.
    CGFloat lastline = 0.;
    if([_string hasSuffix:@"\n"])
        lastline = _font.lineHeight;
    
    _contentView.frame = CGRectMake(0, 0, MAX(self.bounds.size.width, textSize.height + lastline), self.bounds.size.height);
    [super setContentSize:_contentView.bounds.size];
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0.f, 0.f, _contentView.bounds.size.height, _contentView.bounds.size.width)];
    
    if(_frame) CFRelease(_frame);
    _frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path.CGPath, NULL);
    
    [_contentView setNeedsDisplay];
    
}

/// selected range has changed.
- (void)N5N_selectionChanged
{
    
}

/// configure text attributes with current font and color.
- (void)N5N_configureAttributes
{
    CTFontRef font = CTFontCreateWithName((CFStringRef)_font.fontName, _font.pointSize, NULL);
    _attributes = @{
                    (NSString*)kCTFontAttributeName: (__bridge id)font,
                    (NSString*)kCTForegroundColorAttributeName: (__bridge id)_color.CGColor,
                    (NSString*)kCTVerticalFormsAttributeName: @YES
                    };
    CFRelease(font);
}


#pragma mark - Drawing
- (void)N5N_drawContentInRect:(CGRect)rect
                    inContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, rect.size.height);
    
    
    // rotate context for vertical writing
    CGContextRotateCTM(context, -M_PI / 2.0);
    
    // draw frame
    CTFrameDraw(_frame, context);
    
    CGContextRestoreGState(context);
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
