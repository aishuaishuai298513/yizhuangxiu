//
//  ADAccount.m
//  ADSweep
//
//  Created by exe on 15/12/15.
//  Copyright © 2015年 Adan. All rights reserved.
//

#import "ADAccount.h"

@implementation ADAccount

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
//字典转模型
+(instancetype)accountWithDict:(NSDictionary *)dict
{
    ADAccount *account = [[self alloc]init];
    account.userid = dict[@"userid"];
    account.token = dict[@"token"];
    account.mobile = dict[@"mobile"];
    
    return account;
}
//从文件中解析一个对象的时候调用
-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.userid = [decoder decodeObjectForKey:@"userid"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];

        
    }
    return self;
}
//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userid forKey:@"userid"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];


    
}

@end
