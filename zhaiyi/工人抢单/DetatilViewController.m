//
//  DetatilViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DetatilViewController.h"
#import "ADDetailController.h"
#import "My_jidanshezhi_Controller.h"
#import "UIImageView+WebCache.h"

#import "grabOrderResult.h"

@interface DetatilViewController ()
//
{
    grabOrderResult *grabOrderV;
    UIView *backView;
}

@property (weak, nonatomic) IBOutlet UIView *wanringView;
@property (nonatomic, strong) UIView *shawdowView;
//UI
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *adresslb;
@property (weak, nonatomic) IBOutlet UILabel *gongzuoneirong;
@property (weak, nonatomic) IBOutlet UILabel *renshu;

@property (weak, nonatomic) IBOutlet UILabel *startdate;
@property (weak, nonatomic) IBOutlet UILabel *tianshu;
@property (weak, nonatomic) IBOutlet UILabel *jiage;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;

@end

@implementation DetatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orderAction.layer.cornerRadius = 10;
    self.orderAction.layer.masksToBounds = YES;
    self.orderAction.layer.shouldRasterize = YES;
    self.orderAction.backgroundColor = [UIColor colorWithRed:203.0 / 255.0 green:233.0 / 255.0 blue:243.0 / 255.0 alpha:1];
 
    [self UpdateUI];
    self.title = @"详情";
}
//更新UI
-(void)UpdateUI
{
//     self.adresslb.text = self.Model.address;
//    self.gongzuoneirong.text = self.Model.txt;
//    self.renshu.text = [NSString stringWithFormat:@"%@",self.Model.num];
//    self.startdate.text =[NSString date2String:_Model.startDate];
//    self.jiage.text = [NSString stringWithFormat:@"%d元/天",[_Model.money intValue]];
//    self.beizhu.text = self.Model.content;
    
//    self.tianshu.text = [NSString numberOfDays1:self.startdate.text numberOfDays2:self.endDate.text timeStringFormat:@"yyyy-MM-dd"];
    
   // [self.iconImage sd_setImageWithURL:[NSURL URLWithString:@"%@%@",XMJ_BASE_URL,]];
}

//订单列表_抢
-(void)netWork
{
    grabOrderV = [grabOrderResult LoadView];
    grabOrderV.frame = CGRectMake(50, 200, SCREEN_WIDTH -100, SCREEN_WIDTH -100);
    [grabOrderV YesBtnAddTarget:self action:@selector(makeSureClicked) forControlEvents:UIControlEventTouchUpInside];
    
     backView = [Function createBackView:self action:@selector(backViewClicked)];
    [[[UIApplication sharedApplication]keyWindow]addSubview:backView];
    [[[UIApplication sharedApplication]keyWindow]addSubview:grabOrderV];
    
    ADAccount *acount = [ADAccountTool account];
    DWOrderModel *model = self.Model;
    NSLog(@"%@",model.ID);
    NSLog(@"%@",acount.userid);
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"user_id"];
    [parm setObject:model.ID forKey:@"order_id"];
    
    [NetWork postNoParm:qiangDan params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ITTPromptView showMessage:@"网络错误"];
    }];
    
}
//
-(void)backViewClicked
{
    
}
//弹出框点击确定
-(void)makeSureClicked
{
    [backView removeFromSuperview];
    [grabOrderV removeFromSuperview];
    
}


//弹窗跳到  订单详情
- (IBAction)detailVCAction:(id)sender {
    
    ADDetailController *detail = [[ADDetailController alloc]init];
    detail.OrderModel = self.Model;
    [self.navigationController pushViewController:detail animated:YES];
    [self.shawdowView removeFromSuperview];
    self.wanringView.hidden=YES;
    
}

//弹窗跳到  接单设置
- (IBAction)orderSet:(UIButton *)sender {
    
    NSLog(@"接单设置   设置");
    
    //@"order_status" 状态 0 接单  1 休息  2 忙碌
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:@"2" forKey:@"order_status"];
    [userD synchronize];
    //若接单成功  状态设置为2
////
    My_jidanshezhi_Controller * order = [[My_jidanshezhi_Controller alloc]init];
    [self.navigationController pushViewController:order animated:YES];
    [self.shawdowView removeFromSuperview];
    self.wanringView.hidden=YES;
    
}


- (IBAction)orderAction:(id)sender {
    
    if (self.shawdowView != nil) {
        [self.shawdowView removeFromSuperview];
    }
    
    //抢单
     [self netWork];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
