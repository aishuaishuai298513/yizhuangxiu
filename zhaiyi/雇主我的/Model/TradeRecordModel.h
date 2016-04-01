//
//  TradeRecordModel.h
//  zhaiyi
//
//  Created by cajan on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRecordModel : NSObject

@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *bank_number;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *adminid;
@property (nonatomic, copy) NSString *carry_cash;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *goods_type;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *ID;

//order_number = xmj20160120104316306,
//createtime = 2016-01-20 10:43:16,
//bank_name = 农业银行,
//userid = 3,
//bank_number = 6122346731231245642,
//updatetime = 2016-01-20 10:43:16,
//adminid = 1,
//carry_cash = 100.00,
//username = 工人01,
//goods_type = 提现,
//status = 107,
//user_type = 79







@end
