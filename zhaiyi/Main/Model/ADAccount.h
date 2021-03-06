//
//  ADAccount.h
//  ADSweep
//
//  Created by exe on 15/12/15.
//  Copyright © 2015年 Adan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADAccount : NSObject<NSCoding>
//用户id 
@property(nonatomic,copy)NSString *userid;
//用户token
@property(nonatomic,copy)NSString *token;
//用户电话
@property(nonatomic,copy)NSString *mobile;


@property(nonatomic,copy)NSString *username;
//用户昵称
@property(nonatomic,copy)NSString *nickname;

@property(nonatomic,copy)NSString *password;

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *tel;

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *picture;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *status;

@property(nonatomic,copy)NSString *money;

@property(nonatomic,copy)NSString *salt;

@property(nonatomic,copy)NSString *logintime;

@property(nonatomic,copy)NSString *createtime;

@property(nonatomic,copy)NSString *updatetime;

@property(nonatomic,copy)NSString *job_year;

@property(nonatomic,copy)NSString *education;

@property(nonatomic,copy)NSString *id_card;

@property(nonatomic,copy)NSString *education_image;

@property(nonatomic,copy)NSString *user_desc;

@property(nonatomic,copy)NSString *record;

@property(nonatomic,copy)NSString *jpushcode;

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *set_rule;

@property(nonatomic,copy)NSString *live_city;
//新加字段
//雇主
@property(nonatomic,copy)NSString *em_name;

@property(nonatomic,copy)NSString *gztypeid;

@property(nonatomic,copy)NSString *em_sex;

@property(nonatomic,copy)NSString *recharge_money;

@property(nonatomic,copy)NSString *em_nickname;

@property(nonatomic,copy)NSString *em_image;

@property(nonatomic,copy)NSString *em_money;
@property(nonatomic,copy)NSString *em_address;


//评价id
@property(nonatomic,copy)NSString *pinjia_id;



//字典转模型
+(instancetype)accountWithDict:(NSDictionary *)dict;
@end
