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
//招工人数
@property (nonatomic,copy) NSString *n;
@property (nonatomic,copy) NSString *ordercode;
@property (nonatomic,copy) NSString *adr;
@property (nonatomic,copy) NSString *yuji;
@property (nonatomic,copy) NSString *zhuangtai;
@property (nonatomic,copy) NSString *jiesuanshu;
@property (nonatomic,copy) NSString *yizhaorenshu;

//订单详情专用
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *gongzuoneirong;
@property (nonatomic,copy) NSString *status;
@end
