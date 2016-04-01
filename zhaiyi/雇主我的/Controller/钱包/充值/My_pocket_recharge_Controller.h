//
//  My_pocket_recharge_ControllerViewController.h
//  zhaiyi
//
//  Created by cajan on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My_pocket_recharge_Controller : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ylBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
//64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
- (IBAction)nextBtn:(UIButton *)sender;
- (IBAction)ylBtn:(UIButton *)sender;
- (IBAction)wxBtn:(UIButton *)sender;
- (IBAction)alipayBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *moneyView;


@end
