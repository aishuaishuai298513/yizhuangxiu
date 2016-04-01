//
//  My_pocket_qiehuan_View.h
//  zhaiyi
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My_pocket_qiehuan_View : UIView
@property (weak, nonatomic) IBOutlet UIImageView *OK1;
@property (weak, nonatomic) IBOutlet UIImageView *OK2;
@property(nonatomic,copy)NSString * LX;
@property (weak, nonatomic) IBOutlet UIButton *goren;
@property (weak, nonatomic) IBOutlet UIButton *guzhu;
@property (weak, nonatomic) IBOutlet UIView *gongRenView;
@property (weak, nonatomic) IBOutlet UIView *guZhuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gongrenTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guzhuBottomConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *gongrenCheckImageV;
@property (weak, nonatomic) IBOutlet UIImageView *guzhuCheckImageV;

+(My_pocket_qiehuan_View *)initViewWithXib;
@end
