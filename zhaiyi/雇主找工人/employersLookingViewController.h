//
//  employersLookingViewController.h
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface employersLookingViewController : UIViewController

//怕断是否是重新发布跳转
@property (nonatomic, assign) BOOL isChongXinFaBu;
//重新发布订单ID
@property (nonatomic, strong) NSString *orderId;

@end
