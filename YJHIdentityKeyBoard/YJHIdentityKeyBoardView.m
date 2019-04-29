//
//  YJHIdentityKeyBoardView.m
//  YJHIdentityKeyBoard
//
//  Created by D on 2018/6/4.
//  Copyright © 2018年 D. All rights reserved.
//

#import "YJHIdentityKeyBoardView.h"

@implementation YJHIdentityKeyBoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customIdentityKeyBoardView:frame];
    }
    return self;
}

+ (instancetype)customIdentityKeyBoardView:(CGRect)identityKeyBoardViewFrame
{
    return [[YJHIdentityKeyBoardView alloc] initWithFrame:identityKeyBoardViewFrame];
}

- (void) customIdentityKeyBoardView:(CGRect) frame
{
    float buttonWidth = self.frame.size.width / 3;
    float buttonHeight = self.frame.size.height / 4;
    
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backgroundImageView setImage:[UIImage imageNamed:@""]];
    [backgroundImageView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:backgroundImageView];
    
    for (int i = 0; i < 12; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i % 3 * buttonWidth, i / 3 * buttonHeight, buttonWidth, buttonHeight)];
        if (i < 9) {
            [button setTag:(i + 1)];
            [button setTitle:[NSString stringWithFormat:@"%ld",button.tag] forState:UIControlStateNormal];
        }else if (i == 11)
        {
            [button setTag:i];
            [button setTitle:@"<-" forState:UIControlStateNormal];
        }else if (i == 10)
        {
            [button setTag:0];
            [button setTitle:@"0" forState:UIControlStateNormal];
        }else if (i == 9)
        {
            [button setTag:(i + 1)];
            [button setTitle:[NSString stringWithFormat:@"X"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(numberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
}

- (void) numberButtonClicked:(id) sender
{
    UIButton* btn = (UIButton*) sender;
    NSInteger number = btn.tag;
    if (nil == _identityKeyBoardViewDelegate) {
        return;
    }
    
    if (number <= 10 && number >= 0) {
        if ([_identityKeyBoardViewDelegate respondsToSelector:@selector(identityKeyBoardViewInput:)]) {
            [_identityKeyBoardViewDelegate identityKeyBoardViewInput:number];
            return;
        }
    }else
    {
        if ([_identityKeyBoardViewDelegate respondsToSelector:@selector(identityKeyBoardViewSpace)]) {
            [_identityKeyBoardViewDelegate identityKeyBoardViewSpace];
            return;
        }
    }
}



@end
