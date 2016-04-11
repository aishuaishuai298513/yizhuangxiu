//
//  DWEmployerDetailController.h
//  zhaiyi
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADAccount.h"
#import "DWOrderModel.h"

@interface DWEmployerDetailController : UITableViewController
@property (nonatomic, assign) int type;

@property (nonatomic, strong) DWOrderModel *orderModel;

@end
