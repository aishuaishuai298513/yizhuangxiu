//
//  TiXianDetailViewController.h
//  zhaiyi
//
//  Created by ass on 16/5/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiXianXiangQingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *BackOrCardNumL;
@property (weak, nonatomic) IBOutlet UILabel *MoneyL;


@property (nonatomic ,strong)NSString *bank;
@property (nonatomic, strong)NSString *cardNum;
@property (nonatomic, strong)NSString *Money;


@end
