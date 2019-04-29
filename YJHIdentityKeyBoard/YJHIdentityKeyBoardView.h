//
//  YJHIdentityKeyBoardView.h
//  YJHIdentityKeyBoard
//
//  Created by D on 2018/6/4.
//  Copyright © 2018年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *      YJHIdentityKeyBoardView
 *      使用场景
 *      YJHIdentityKeyBoardView  身份证键盘
 */

@protocol YJHIdentityKeyBoardVDelegate<NSObject>

- (void) identityKeyBoardViewInput:(NSInteger) number;

- (void) identityKeyBoardViewSpace;

@end

@interface YJHIdentityKeyBoardView : UIView

@property (nonatomic, assign) id<YJHIdentityKeyBoardVDelegate> identityKeyBoardViewDelegate;

+ (instancetype) customIdentityKeyBoardView:(CGRect) identityKeyBoardViewFrame;

@end
