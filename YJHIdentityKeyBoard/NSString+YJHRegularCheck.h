//
//  NSString+YJHRegularCheck.h
//  YJHIdentityKeyBoard
//
//  Created by D on 2018/6/4.
//  Copyright © 2018年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *      YJHRegularCheck
 *      使用场景
 *      YJHRegularCheck  正则校验
 */

@interface YJHRegularCheck : NSObject

@end


@interface NSString (YJHRegularCheck)

//是否同时包含数字和字母
- (BOOL) containCharacterAndNumber;
//是否是手机号码
- (BOOL) isMobileNumber;
//是否是身份证号
- (BOOL) isIDCard;
//是否是精确的身份证号码
- (BOOL) isAccurateIDCard;
//是否是银行卡号
- (BOOL) isBankCard;
//
- (BOOL) isNumberAndDotError;
//
- (BOOL) testNumberAndPointOfTF;
//小数点后位数
- (NSString*) substringWithDotBehindLength:(NSInteger) length;
//是否含有表情
+ (BOOL) stringContainsEmoji:(NSString*) string;
//是否是微信号
- (BOOL) isWeChat;
//是否是QQ号
- (BOOL) isQQ;
//
- (BOOL) isName;
//是否包含特殊字符
- (BOOL) containSpecialCharacters;
//是否是有效的中文名
+ (BOOL)isChinaName:(NSString *)realName;

@end
