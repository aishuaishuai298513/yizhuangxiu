//
//  DWConfirmCheckViewController.h
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"
@interface DWConfirmCheckViewController : UIViewController

@property (nonatomic, strong)DWOrderModel *Ordermodel;

//抢单用户信息列表
@property (nonatomic, strong)NSMutableArray *UserDataSource;

@property (nonatomic, assign )int TypeFrom;

@end
