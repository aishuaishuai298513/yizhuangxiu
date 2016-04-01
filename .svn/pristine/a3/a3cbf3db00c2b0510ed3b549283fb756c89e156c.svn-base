//
//  ADAccountTool.m
//  ADSweep
//
//  Created by exe on 15/12/15.
//  Copyright © 2015年 Adan. All rights reserved.
//

#define ADAccountFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"account.data"]
#import "ADAccountTool.h"

#import "My_Login_In_ViewController.h"

@implementation ADAccountTool
+(void)save:(ADAccount *)account
{
    //利用NSKeyedArchiver这个类把账号存储到filepath这个文件路径中,前提：这个账号必须遵守NSCoding协议
    [NSKeyedArchiver archiveRootObject:account toFile:ADAccountFilePath];
}

+(ADAccount *)account
{
    //解档
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:ADAccountFilePath];
}

//删除文件 退出登录
+(void)deleteAccount
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"account.data"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        //NSLog(@"no  have");
        return ;
    }else {
       // NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
           // NSLog(@"dele success");
        }else {
          //NSLog(@"dele fail");
        }
        
    }
}

//返回字典
+(NSMutableDictionary *)backWitDictionary{
    
    NSMutableDictionary *_dict = [NSMutableDictionary dictionary];
    ADAccount *_account = [self account];
    
    [_dict setObject:_account.userid forKey:@"userid"];
    [_dict setObject:_account.token forKey:@"token"];
    [_dict setObject:_account.mobile forKey:@"mobile"];
    [_dict setObject:_account.nickname forKey:@"nickname"];
    [_dict setObject:_account.type forKey:@"type"];
    [_dict setObject:_account.money forKey:@"money"];
    [_dict setObject:_account.address forKey:@"address"];
    [_dict setObject:_account.createtime forKey:@"createtime"];
    [_dict setObject:_account.updatetime forKey:@"updatetime"];
    [_dict setObject:_account.job_year forKey:@"job_year"];
    [_dict setObject:_account.education forKey:@"education"];
    [_dict setObject:_account.username forKey:@"username"];
    [_dict setObject:_account.tel forKey:@"tel"];
    [_dict setObject:_account.sex forKey:@"sex"];
    [_dict setObject:_account.picture forKey:@"picture"];
    [_dict setObject:_account.id_card forKey:@"id_card"];
    [_dict setObject:_account.education_image forKey:@"education_image"];
    [_dict setObject:_account.user_desc forKey:@"user_desc"];
    [_dict setObject:_account.record forKey:@"record"];
    [_dict setObject:_account.logintime forKey:@"logintime"];
    [_dict setObject:_account.salt forKey:@"salt"];
    [_dict setObject:_account.jpushcode forKey:@"jpushcode"];
    [_dict setObject:_account.ID forKey:@"id"];
    [_dict setObject:_account.set_rule forKey:@"set_rule"];
    [_dict setObject:_account.password forKey:@"password"];
    [_dict setObject:_account.live_city forKey:@"live_city"];
    [_dict setObject:_account.em_name forKey:@"em_name"];
    [_dict setObject:_account.gztypeid forKey:@"gztypeid"];
    [_dict setObject:_account.em_sex forKey:@"em_sex"];
    [_dict setObject:_account.recharge_money forKey:@"recharge_money"];
    [_dict setObject:_account.em_nickname forKey:@"em_nickname"];
    [_dict setObject:_account.em_image forKey:@"em_image"];
    [_dict setObject:_account.em_money forKey:@"em_money"];
    [_dict setObject:_account.em_money forKey:@"em_address"];

      // account.adminid = dict[@"adminid"];
 
    return _dict;
}

//调用系统电话
+(void)CallPhone:(NSString *)telNum
{
    NSString *allString = [NSString stringWithFormat:@"tel:%@",telNum];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

@end
