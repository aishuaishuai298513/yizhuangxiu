//
//  DWOrderDetailTableViewController.h
//  zhaiyi
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"

@interface DWOrderDetailTableViewController : UITableViewController
@property (nonatomic, assign) int type;
@property (nonatomic, strong) DWOrderModel *OrderModel;


@end
