//
//  HuoyModel.h
//  ENongProject
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 GL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DWOrderModel : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *baozhengjin;
@property (nonatomic,copy) NSString *createtime;
@property (nonatomic,copy) NSString *gzname;
@property (nonatomic,copy) NSString *n;//招工人数
@property (nonatomic,copy) NSString *ordercode;
@property (nonatomic,copy) NSString *adr;
@property (nonatomic,copy) NSString *yuji;
@property (nonatomic,copy) NSString *zhuangtai;
@property (nonatomic,copy) NSString *jiesuanshu;
@property (nonatomic,copy) NSString *yizhaorenshu;
//雇主端订单详情专用
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *gongzuoneirong;
@property (nonatomic,copy) NSString *status;


//工人端订单字段
@property (nonatomic,copy) NSString *juli;//距离
@property (nonatomic,copy) NSString *shengyu;// 剩余人数
//工人端订单详情
@property (nonatomic,copy) NSString *lianxiren;
@property (nonatomic,copy) NSString *beizhu;
@property (nonatomic,copy) NSString *kaigongriqi;
@property (nonatomic,copy) NSString *userid;//用户id
@property (nonatomic,copy) NSString *headpic;//
@property (nonatomic,copy) NSString *xing;//星级

@end
