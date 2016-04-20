//
//  ADOrderViewCell.h
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"

//取消订单
typedef void(^cancleOrderClicked)(NSDictionary *response);
typedef void(^jiesuanOrderClicked)(DWOrderModel *orderModel);
typedef void(^shanchuOrderClicked)(NSDictionary *response);
//确认首款
typedef void(^queRenShouKuanClicked)(NSDictionary *response);


@interface ADOrderViewCell : UITableViewCell
+(instancetype)cell;

@property (nonatomic ,strong) DWOrderModel *OrderModel;

@property (nonatomic ,assign) NSInteger workStue;

//
@property (nonatomic, copy) cancleOrderClicked cancleOrder;

@property (nonatomic, copy) jiesuanOrderClicked jisuanOrder;

@property (nonatomic, copy) shanchuOrderClicked shanchuOrder;
// 确认收款
@property (nonatomic, copy) queRenShouKuanClicked queRenShouKuan;

@end
