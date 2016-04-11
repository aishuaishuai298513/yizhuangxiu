//
//  My_pocket_recharge_ControllerViewController.h
//  zhaiyi
//
//  Created by cajan on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My_pocket_Pay_Controller : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ylBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *yeBtn;


@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
- (IBAction)nextBtn:(UIButton *)sender;
- (IBAction)ylBtn:(UIButton *)sender;
- (IBAction)wxBtn:(UIButton *)sender;
- (IBAction)alipayBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *moneyView;

//余额
@property (strong, nonatomic)NSString *Yue;
//支付金额／保证金
@property (strong, nonatomic)NSString *ZhiFuJinE;

//订单号
@property (nonatomic, strong) NSString *orderCode;

@end
