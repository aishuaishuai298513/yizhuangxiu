//
//  ADOrderViewCell.h
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"

@interface ADOrderViewCell : UITableViewCell
+(instancetype)cell;

@property (nonatomic ,strong)DWOrderModel *OrderModel;

@end
