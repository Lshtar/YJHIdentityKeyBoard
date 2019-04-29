//
//  ViewController.m
//  YJHIdentityKeyBoard
//
//  Created by D on 2018/6/4.
//  Copyright © 2018年 D. All rights reserved.
//

#import "ViewController.h"
#import "NSString+YJHRegularCheck.h"
#import "YJHIdentityKeyBoardView.h"

//typedef NSString * YJHScreenType NS_STRING_ENUM;
//FOUNDATION_EXPORT YJHScreenType const YJHScreenWidth;
//FOUNDATION_EXPORT YJHScreenType const YJHScreenHeight;
//
//YJHScreenType const YJHScreenWidth = @"INKPayTypeKeyInstallment";
//YJHScreenType const YJHScreenHeight =

#define YJHScreenWidth    [UIScreen mainScreen].bounds.size.width
#define YJHScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ViewController () <YJHIdentityKeyBoardVDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField* identityCardTextField;
@property (nonatomic, copy) NSString* idcardNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupIdentityCardView];
    
    UIGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRTap:)];
    [self.view addGestureRecognizer:tapGR];
    
}

- (void) setupIdentityCardView
{
    int boardViewWidth = self.view.frame.size.width;
    int boardViewheight = 200;
    int boardViewX = 0;
    int boardeViewY = self.view.frame.size.height - boardViewheight;
    
    YJHIdentityKeyBoardView* customKeyBoardView = [YJHIdentityKeyBoardView customIdentityKeyBoardView:CGRectMake(boardViewX, boardeViewY, boardViewWidth, boardViewheight)];
    customKeyBoardView.identityKeyBoardViewDelegate = self;
    
    
    _identityCardTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, YJHScreenWidth-100, 80)];
    _identityCardTextField.placeholder = @"请输入身份证号";
    //_identityCardTextField.text = @"";
    _identityCardTextField.backgroundColor = [UIColor orangeColor];
    _identityCardTextField.textAlignment = NSTextAlignmentLeft;
    _identityCardTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_identityCardTextField addTarget:self action:@selector(idCardTap:) forControlEvents:UIControlEventEditingChanged];
    [_identityCardTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_identityCardTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_identityCardTextField setInputView:customKeyBoardView];
    
    [self.view addSubview:_identityCardTextField];
}

#pragma mark - 手势事件
-(void)tapGRTap:(UITapGestureRecognizer *)sneder{
    [self.view endEditing:YES];
}

- (void) idCardTap:(UITextField*) sender
{
    if ([NSString stringContainsEmoji:sender.text]) {
        sender.text = @"";
    }else
    {
        if (sender.text.length == 18) {
            self.idcardNumber = sender.text;
            if (![sender.text isAccurateIDCard]) {
               // return;
                
            }else
            {
               // self re
            }
        }else if (sender.text.length > 18)
        {
            sender.text = self.idcardNumber;
        }
    }
}

#pragma 自定义键盘代理方法
- (id) findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

- (void)numberKeyBoardBackspace
{
    UIView *textView = [self findFirstResponder];
    if ([textView isMemberOfClass:[UITextField class]]) {
        _identityCardTextField = (UITextField *)textView;
    }
    NSMutableString *mutableString = [[NSMutableString alloc]initWithFormat:@"%@",_identityCardTextField.text];
    if ([mutableString length] >= 1) {
        NSRange tmpRange;
        tmpRange.location = [mutableString length] - 1;
        tmpRange.length = 1;
        [mutableString deleteCharactersInRange:tmpRange];
    }
    _identityCardTextField.text = mutableString;
    if (_identityCardTextField.text.length > 18){
        _identityCardTextField.text = [_identityCardTextField.text substringToIndex:18];
    }
}
- (void) identityKeyBoardViewInput:(NSInteger) number
{
    UIView *textView = [self findFirstResponder];
    if ([textView isMemberOfClass:[UITextField class]]) {
        _identityCardTextField = (UITextField *)textView;
    }
    NSString *str = @"";
    
    if (number < 10) {
        str = [NSString stringWithFormat:@"%ld",number];
    }else{
        str = [NSString stringWithFormat:@"X"];
    }
    NSMutableString *textString = [[NSMutableString alloc]initWithFormat:@"%@%@",_identityCardTextField.text,str];
    _identityCardTextField.text = textString;
    if (_identityCardTextField.text.length > 18){
        _identityCardTextField.text = [_identityCardTextField.text substringToIndex:18];
    }
    
    if (_identityCardTextField.text.length ==18) {
        self.idcardNumber = _identityCardTextField.text;
        if (![_identityCardTextField.text isAccurateIDCard]) {
           
        }else{
            
        }
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
