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
@interface N5NVerticalTextView : UIScrollView

/// text.
@property (nonatomic, strong) NSString* text;
/// attributed string.
@property (nonatomic, strong) NSAttributedString* attributedString;

// @property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;

@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic, assign)     UITextAutocorrectionType autocorrectionType;
@property (nonatomic, assign)      UITextSpellCheckingType spellCheckingType;
@property (nonatomic, assign)                         BOOL enablesReturnKeyAutomatically;
@property (nonatomic, assign)         UIKeyboardAppearance keyboardAppearance;
@property (nonatomic, assign)               UIKeyboardType keyboardType;
@property (nonatomic, assign)              UIReturnKeyType returnKeyType;
@property (nonatomic, assign)                         BOOL secureTextEntry;

@end
