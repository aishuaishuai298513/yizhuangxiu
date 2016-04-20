//
//  My_pocket_recharge_ControllerViewController.h
//  zhaiyi
//
//  Created by cajan on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayInfoModel.h"
#import "DetialUserInfoM.h"

@interface My_pocket_Controller : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *YuEImageV;
@property (weak, nonatomic) IBOutlet UIImageView *YinLianImageV;
@property (weak, nonatomic) IBOutlet UIImageView *WeiXinImageV;

@property (weak, nonatomic) IBOutlet UIImageView *ZhiFuBaoImageV;

//64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
- (IBAction)nextBtn:(UIButton *)sender;

//CellView
@property (weak, nonatomic) IBOutlet UIView *YuEView;
@property (weak, nonatomic) IBOutlet UIView *YinLianView;
@property (weak, nonatomic) IBOutlet UIView *WeiXinView;
@property (weak, nonatomic) IBOutlet UIView *ZhiFuBaoView;


@property (weak, nonatomic) IBOutlet UIView *moneyView;
//帐户余额
@property (weak, nonatomic) IBOutlet UILabel *zhangHuYuE;

//支付页面信息
@property (nonatomic ,strong)PayInfoModel *payInfoModel;

//工人信息 －主要抢单id
@property (nonatomic, strong)DetialUserInfoM *detilInfoModel;


@end
