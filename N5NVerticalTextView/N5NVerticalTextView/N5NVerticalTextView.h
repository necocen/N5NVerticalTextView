//
//  N5NVerticalTextView.h
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/16.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 UITextView for vertical writing.
 */
//@interface N5NVerticalTextView : UIScrollView <UITextInput>
@interface N5NVerticalTextView : UIScrollView <UIKeyInput>

/// text.
@property (nonatomic, copy) NSString* text;

/// font.
@property (nonatomic, strong) UIFont* font;

/// text color.
@property (nonatomic, strong) UIColor* color;

/// editable?
@property (nonatomic, assign) BOOL editable;

/// input delegate.

// @property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;

@property(nonatomic, copy) NSDictionary* markedTextStyle;

@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic, assign)     UITextAutocorrectionType autocorrectionType;
@property (nonatomic, assign)      UITextSpellCheckingType spellCheckingType;
@property (nonatomic, assign)                         BOOL enablesReturnKeyAutomatically;
@property (nonatomic, assign)         UIKeyboardAppearance keyboardAppearance;
@property (nonatomic, assign)               UIKeyboardType keyboardType;
@property (nonatomic, assign)              UIReturnKeyType returnKeyType;
@property (nonatomic, assign, getter=isSecureTextEntry) BOOL secureTextEntry;

@end
