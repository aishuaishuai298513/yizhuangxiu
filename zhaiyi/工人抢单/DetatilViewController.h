//
//  DetatilViewController.h
//  zhaiyi
//
//  Created by apple on 15/12/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWOrderModel.h"


@interface DetatilViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *orderAction;

@property (nonatomic, strong) DWOrderModel *Model;
@property (nonatomic, strong) NSString *orderId;

//父页面传值过来
@property (nonatomic, strong) DWOrderModel *orderModel;

//1 已抢单  2.施工中  3.已竣工
@property (nonatomic, assign) int statue;;

@end
