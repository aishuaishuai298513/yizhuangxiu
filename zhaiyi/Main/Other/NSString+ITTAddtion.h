//
//  NSString+ITTAddtion.h
//  iTotemFrame
//
//  Created by itotem on 14-10-24.
//  Copyright (c) 2014年 Lisa. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    //以下是枚举成员
    YiDong = 1,
    LianTong,
    DianXin,
    Other
}MobileType;


typedef enum : NSUInteger {
    TelePhone = 0x88,  // 手机
    DesktopPhone,      // 座机
} PhoneType;


@interface NSString (ITTAddtion)

//-----------------------------------------------------------------------------------
// 字符串 所占位置操作集合，包括
// 1)高度，宽度，大小
//-----------------------------------------------------------------------------------

//返回行数
- (NSInteger)numberOfLinesWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth;


/**
 *  由固定的高度计算字符串的宽度
 *
 *  @param font       字体大小
 *  @param lineHeight 字符串的高度
 *
 *  @return 返回字符串的宽度
 */
-(CGFloat)widthWithFont:(UIFont *)font withLineHeight:(CGFloat)lineHeight;

/**
 *  由固定宽度计算字符串的高度
 *
 *  @param font      字体大小
 *  @param lineWidth 所占的宽度
 *
 *  @return 返回高度
 */
- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth;


/**
 *  根据字符串以及字体计算占得位置size
 *
 *  @param size 默认的size
 *  @param font 文本显示字体
 *
 *  @return 新的size
 */
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;


//-----------------------------------------------------------------------------------
// 字符串操作集合，包括
// 1)去掉空格
// 2)判断开头或结尾
// 3)判断是否为空
//-----------------------------------------------------------------------------------

/**
 *  去掉字符串前后的空格
 *
 *  @return 返回的是 前后无空格的新的字符串---
 */
-(NSString *)removeStringSpaceBlankEndAndStart;

/**
 *  判断字符串是否是由某字符串开头的
 *
 *  @param start 某字符串
 *
 *  @return 是返回YES 否 返回NO
 */
- (BOOL)isStartWithString:(NSString*)start;

/**
 *  判断字符串是否是由某字符串结尾的
 *
 *  @param end 某字符串
 *
 *  @return 是返回YES 否 返回NO
 */
- (BOOL)isEndWithString:(NSString*)end;

/**
 *  判断字符串是否为空
 *
 *  @param string
 *
 *  @return 不为空则返回YES 否则返回NO
 */
+(BOOL)checkStringIsValided:(NSString*)string;



//-----------------------------------------------------------------------------------
// 字符串操作集合，包括
// 1)是否是手机号
// 2)是否是邮箱
// 3)手机号的类型
// 4)直接拨打电话
//-----------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
// 安全相关的字符串操作集合，包括
// 1) 3DES加密解密
// 2) Base64编码解码
//-----------------------------------------------------------------------------------

//md5加密
+ (NSString *)encryptPassword:(NSString *)str;

/*!
 * 使用3DES算法对字符串进行加密，加密后使用base64编码
 * 3DES算法要求密钥是24字节长，这里要求一个24个字符的字符串做为参数
 */
- (NSString *)encryptWithKey:(NSString*)key;

/*!
 * 先解码base64，然后使用3DES算法解密
 * 3DES算法要求密钥是24字节长，这里要求一个24个字符的字符串做为参数
 */
- (NSString *)decryptBase64WithKey:(NSString*)key;

/*!
 * 返回一个字符串的base64编码结果
 */
- (NSString *)base64String;

/*!
 * 返回一个二进制数据的base64编码结果
 */
+ (NSString *)encodeBase64WithData:(NSData *)objData;

/*!
 * 将一个base64编码字符串解码成二进制数据
 */
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

/*!
 * 为空处理
 */
- (NSString *) safeString;

/**
 *  将NSArray转换为NSString
 *
 *  @param array
 *
 *  @return
 */
+(NSString *) jsonStringWithArray:(NSArray *)array;

+ (NSString *)numberOfDays1:(NSString *)time1 numberOfDays2:(NSString *)time2 timeStringFormat:(NSString *)format;

+(NSString *)dateString:(NSString *)str;

+(NSString *)date2String:(NSString *)str;

+(NSString *)gongZhongFromID:(NSString *)gongZhong;
@end
