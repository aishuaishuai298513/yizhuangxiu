//
//  TradeRecordModel.h
//  zhaiyi
//
//  Created by cajan on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRecordModel : NSObject


@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *leixing;
@property (nonatomic, copy) NSString *ID;

//"id": "1",
//"leixing": "32",－－下边有关于类型的说明
//"title": "提现",
//"createtime": "04-08",
//"money": "1.00"

@end
