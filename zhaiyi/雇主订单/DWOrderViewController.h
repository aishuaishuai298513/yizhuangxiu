//
//  DWOrderViewController.h
//  zhaiyi
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//控制跳向施工中
@property (nonatomic, assign)BOOL pushWorking;

@end
