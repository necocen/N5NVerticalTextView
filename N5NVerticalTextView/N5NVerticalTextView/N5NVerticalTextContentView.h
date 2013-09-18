//
//  N5NVerticalTextContentView.h
//  N5NVerticalTextView
//
//  Created by κねこせん on 2013/09/19.
//  Copyright (c) 2013年 κねこせん. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol N5NVerticalTextContentViewDelegate;

@interface N5NVerticalTextContentView : UIView

/// Delegate to the drawing task.
@property (nonatomic, weak) id<N5NVerticalTextContentViewDelegate> delegate;

@end

/// delegate the drawing
@protocol N5NVerticalTextContentViewDelegate <NSObject>
@required
/// Draw content in the given rect with given context.
- (void)N5N_drawContentInRect:(CGRect)rect
                    inContext:(CGContextRef)context;
@end