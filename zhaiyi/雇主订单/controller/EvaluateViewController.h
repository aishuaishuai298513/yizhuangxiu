//
//  EvaluateViewController.h
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWOrderModel.h"

@interface EvaluateViewController : UITableViewController


@property (nonatomic, strong)NSArray *UserDataSource;


@property (nonatomic, strong)DWOrderModel *OrderModel;

@property (nonatomic, assign) int TypeFrom;


@end
