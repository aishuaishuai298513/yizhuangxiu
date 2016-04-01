//
//  ADAccountTool.h
//  ADSweep
//
//  Created by exe on 15/12/15.
//  Copyright © 2015年 Adan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ADAccount;
@interface ADAccountTool : NSObject

//存储账号
+(void)save:(ADAccount *)account;
//读取账号
+(ADAccount *)account;
/**
 *以字典类型返回
 */
+(NSMutableDictionary *)backWitDictionary;

//退出登录

+(void)deleteAccount;

/**
 *打电话
 */

+(void)CallPhone:(NSString *)telNum;


@end
