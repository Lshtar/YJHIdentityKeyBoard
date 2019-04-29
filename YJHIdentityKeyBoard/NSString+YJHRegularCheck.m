//
//  NSString+YJHRegularCheck.m
//  YJHIdentityKeyBoard
//
//  Created by D on 2018/6/4.
//  Copyright © 2018年 D. All rights reserved.
//

#import "NSString+YJHRegularCheck.h"

@implementation YJHRegularCheck

@end

@implementation NSString (YJHRegularCheck)

- (BOOL) containCharacterAndNumber
{
    if (self == nil) {
        return NO;
    }else{
        NSPredicate* predicat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,15}$"];
        return [predicat evaluateWithObject:self];
    }
}

- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    
    NSString* MOBILE = @"^1(3[0-9]|5[0-35-9]|8[012345678-9])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    
    NSString* CM = @"1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    
    NSString* CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    
    NSString* CT = @"^1((33|53|77|76|8[09])[0-9]|349)\\d{7}$";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate* predicateMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate* predicateCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate* predicateCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate* predicateCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    
    if (([predicateMobile evaluateWithObject:self] == YES) || ([predicateCM evaluateWithObject:self] == YES) || ([predicateCU evaluateWithObject:self] == YES) || ([predicateCT evaluateWithObject:self] == YES)) {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL) isIDCard
{
    NSString* regex = @"^(\\d{15}|\\d{18})(\\d|[xX])$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isAccurateIDCard
{
    /*
     从1999年10月1日起，全国实行公民身份证号码制度，居民身份证编号由原15位升至18位。前6位为地址码；第七位至14位为出生日期码，此码由6位数改为8位数，其中年份用4位数表示；第15位至17位为顺序码，取消了顺序码中对百岁老人使用的特定编号；第十八位为校验码，主要是为了校验计算机输入公民身份证号码的前17位数字是否正确，其取值范围是0至10，当值等于10时，用罗马数字符X表示。 15位的身份证号我们就不考虑啦
     */
    
    if (self.length != 18) {
        return NO;
    }
    
    //正则表达式判断基本 身份证号是否满足格式
    NSString* regex = @"";
    NSPredicate* identityStringPredicate = [NSPredicate predicateWithFormat:@"",regex];
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if (![identityStringPredicate evaluateWithObject:self]) {
        return NO;
    }
    
    /*--- 开始进行校验 ---*/
    
    //将前17位加权因子保存在数组里
    NSArray* idCardWithArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray* idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWithSum = 0;
    for (int i = 0; i < 17; i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWithIndex = [[idCardWithArray objectAtIndex:i] integerValue];
        idCardWithSum += subStrIndex * idCardWithIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWithSum % 11;
    //得到最后一位身份证号码
    NSString* idCardLast = [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
        if (![idCardLast isEqualToString:@"X"] || [idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else
    {
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if (![idCardLast isEqualToString:[idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) isBankCard
{
    if (self.length == 0) {
        return NO;
    }
    
    NSString* digitsOnly = @"";
    char c;
    for (int i = 0; i < self.length; i ++) {
        c = [self characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly = [digitsOnly stringByAppendingFormat:@"%c", c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length -1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit* 2;
            if (addend > 9)  {
                addend -= 9;
            }
        }else
        {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    if (modulus == 0) {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)testNumberAndPointOfTF
{
    if ((self.length == 2 && [self isEqualToString:@"00"]) || (self.length == 4 && [self isEqualToString:@"0.00"]) || ([self isEqualToString:@"."])) {
        return YES;
    }
    @autoreleasepool {
        NSMutableArray* marr = [NSMutableArray array];
        for (int i = 0; i < self.length; i++) {
            [marr addObject:[self substringWithRange:NSMakeRange(i, 1)]];
            for (int j = 1; j < i; j++) {
                if ([marr[j] isEqualToString:marr[i]] && [marr[j] isEqualToString:@"."] && [marr[i] isEqualToString:@"."]) {
                    return YES;
                }
            }
        }
        [marr removeAllObjects];
    }
    return NO;
}

- (NSString *)substringWithDotBehindLength:(NSInteger)length
{
    NSString* str = [NSString stringWithFormat:@"%f", [self doubleValue]];
    NSInteger location = [str localizedStandardRangeOfString:@"."].location;
    if (length < 0) {
        str = @"0.00";
    }else if (length == 0)
    {
        str = [str substringToIndex:location];
    }else if (str.length >= location + length + 1)
    {
        str = [str substringToIndex:location + length + 1];
    }
    return str;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
        
    }];
    
    return returnValue;
}

- (BOOL)isWeChat
{
    NSString *regex = @"^[A-Za-z0-9]{5,}$";
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [predicat evaluateWithObject:self];
}

- (BOOL)isQQ
{
    NSString *regex = @"[1-9][0-9]{4,}";
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [predicat evaluateWithObject:self];
}

- (BOOL)containSpecialCharacters
{
    NSString *regex = @"[~!/@#$%^&#$%^&amp;*()-_=+\\|[{}];:\'\",&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&gt;/?]+";
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [predicat evaluateWithObject:self];
}

- (BOOL)isName
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [predicat evaluateWithObject:self];
}

/**
    @param realName 名字
    @return 如果是在如下规则下符合的中文名则返回`YES`，否则返回`NO`
    限制规则：
    1. 首先是名字要大于2个汉字，小于8个汉字
    2. 如果是中间带`{•|·}`的名字，则限制长度15位（新疆人的名字有15位左右的，之前公司实名认证就遇到过），如果有更长的，请自行修改长度限制
    3. 如果是不带小点的正常名字，限制长度为8位，若果觉得不适，请自行修改位数限制
    *PS: `•`或`·`具体是那个点具体处理需要注意*
*/
+ (BOOL)isChinaName:(NSString *)realName
{
    if (realName == nil) return NO;
    
    
    NSRange range1 = [realName rangeOfString:@"·"];
    NSRange range2 = [realName rangeOfString:@"•"];
    if(range1.location != NSNotFound ||   // 中文 ·
       range2.location != NSNotFound )    // 英文 •
    {
        //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 15)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    else
    {
        //一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 8) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
}

@end
