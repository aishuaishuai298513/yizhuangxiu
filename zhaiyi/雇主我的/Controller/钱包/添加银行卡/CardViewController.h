//
//  CardViewController.h
//  zhaiyi
//
//  Created by ass on 16/3/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) void(^getSlectString)(NSString *str,NSInteger cardID);

@end
