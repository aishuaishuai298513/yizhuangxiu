//
//  CertificatePayView.m
//  zhaiyi
//
//  Created by ass on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GzJIeSuanView.h"

@interface GzJIeSuanView()

@property (weak, nonatomic) IBOutlet UILabel *workAdressL;
@property (weak, nonatomic) IBOutlet UILabel *workStartDateL;
@property (weak, nonatomic) IBOutlet UILabel *workDayCountL;

@property (weak, nonatomic) IBOutlet UILabel *actualWorkDayL;

@property (weak, nonatomic) IBOutlet UILabel *dayPayL;

@property (weak, nonatomic) IBOutlet UILabel *workTypeL;

@property (weak, nonatomic) IBOutlet UILabel *payMoneyCountL;

@property (weak, nonatomic) IBOutlet UIButton *canclebtnClicked;

@property (weak, nonatomic) IBOutlet UIButton *makeSurebtnClicked;

@property (weak, nonatomic) IBOutlet UILabel *paytypeL;

@property (weak, nonatomic) IBOutlet UILabel *jieSuanRiQiL;

@end
@implementation GzJIeSuanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"GzJIeSuanView" owner:nil options:nil]lastObject];
}

-(id)init
{
    if ([super init]) {
        [GzJIeSuanView loadView];
    }
    return self;
}



-(void)setPayinfoModel:(PayInfoModel *)payinfoModel
{
    _payinfoModel = payinfoModel;
    
    NSMutableAttributedString *yujiAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@天",payinfoModel.tianshu]];
    NSMutableAttributedString *workTypeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",payinfoModel.gongzhong]];
    
     NSMutableAttributedString *dayPayStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",payinfoModel.price]];
    
     NSMutableAttributedString *payMoneyCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",payinfoModel.gongji]];
    
    
    [yujiAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, yujiAttStr.length-1)];
    [workTypeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, workTypeStr.length)];
    [dayPayStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, dayPayStr.length-1)];
    [payMoneyCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, payMoneyCountStr.length-1)];
    
    
    
    self.workAdressL.text = payinfoModel.gongzuodidian;
    self.workStartDateL.text = payinfoModel.kaigongriqi;
    self.workDayCountL.attributedText = yujiAttStr;
    self.actualWorkDayL.text = [NSString stringWithFormat:@"%@ 天",payinfoModel.tianshu];
    self.dayPayL.text = [NSString stringWithFormat:@"%@元",payinfoModel.price];
    self.workTypeL.attributedText = workTypeStr;
    self.payMoneyCountL.attributedText = payMoneyCountStr;
    self.paytypeL.text = payinfoModel.zhifufangshi;
    self.jieSuanRiQiL.text = payinfoModel.updatetime;
    
    //设置文字
    NSLog(@"%@",self.paytypeL.text);
    if ([self.paytypeL.text isEqualToString:@"线上"]) {
        
//        [self.makeSurebtnClicked setTitle:@"支付" forState:UIControlStateNormal];
        
       // self.makeSurebtnClicked.titleLabel.text = @"支付";
    }
}



@end
