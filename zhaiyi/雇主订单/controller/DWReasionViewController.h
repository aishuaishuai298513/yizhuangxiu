//
//  DWReasionViewController.h
//  zhaiyi
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"

@interface DWReasionViewController : UITableViewController

//用户

@property (nonatomic, strong) ADAccount *UserAcount;

@property (nonatomic, strong) DWOrderModel *OrderModel;

@end
