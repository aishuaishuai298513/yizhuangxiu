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
#import "FileOrderResult.h"

#import "jieSuanView.h"


@interface DetatilViewController ()
//
{
    grabOrderResult *grabOrderV;
    FileOrderResult *fileOrderV;
    UIView *backView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;


@property (nonatomic, strong) UIView *shawdowView;
//UI
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *adresslb;//工作地址
@property (weak, nonatomic) IBOutlet UILabel *gongzuoneirong;//工作内容
@property (weak, nonatomic) IBOutlet UILabel *renshu;//需求人数

@property (weak, nonatomic) IBOutlet UILabel *startdate;//开工日期

@property (weak, nonatomic) IBOutlet UILabel *jiage;//价格
@property (weak, nonatomic) IBOutlet UILabel *beizhu;//备注

@property (weak, nonatomic) IBOutlet UILabel *shengYuRenShu;//剩余人数

@property (weak, nonatomic) IBOutlet UILabel *yuJiTianShu;//预计天数
@property (weak, nonatomic) IBOutlet UILabel *gongZhong;//工种
@property (weak, nonatomic) IBOutlet UILabel *lianXiRen;//联系人

@property (weak, nonatomic) IBOutlet UIButton *baozhengjinBtn;


@property (nonatomic ,strong) NSString *xingji;//星级

@property (weak, nonatomic) IBOutlet UIButton *baiBianBtn;


@property (nonatomic, strong)jieSuanView *jiesuanView;

@end

@implementation DetatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orderAction.layer.cornerRadius = 10;
    self.orderAction.layer.masksToBounds = YES;
    self.orderAction.layer.shouldRasterize = YES;
    self.orderAction.backgroundColor = [UIColor colorWithRed:203.0 / 255.0 green:233.0 / 255.0 blue:243.0 / 255.0 alpha:1];
 
    [self netWorkInfo];
    [self setBtnInfo];
    
    self.title = @"详情";
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
}

-(void)setBtnInfo
{
    if (self.statue == 1) {
        
        [self.baiBianBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.baiBianBtn addTarget:self action:@selector(quxiaoOrderC) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (self.statue == 2)
    {
        if ([self.orderModel.status isEqualToString:@"9"]||[self.orderModel.status isEqualToString:@"10"]) {
            
            [self.baiBianBtn setTitle:@"实时结算" forState:UIControlStateNormal];
            [self.baiBianBtn addTarget:self action:@selector(jisuanOrderC) forControlEvents:UIControlEventTouchUpInside];

        }else if([self.orderModel.status isEqualToString:@"11"])
        {
            [self.baiBianBtn setTitle:@"待结算" forState:UIControlStateNormal];
            self.baiBianBtn.userInteractionEnabled = NO;
            
        }else if ([self.orderModel.status isEqualToString:@"12"])
        {
            [self.baiBianBtn setTitle:@"确认收款" forState:UIControlStateNormal];
            [self.baiBianBtn addTarget:self action:@selector(queRenShouKuanC) forControlEvents:UIControlEventTouchUpInside];
        }

    }else if(self.statue == 3)
    {
       [self.baiBianBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.baiBianBtn addTarget:self action:@selector(shanchuOrderC) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
       [self.baiBianBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.baiBianBtn addTarget:self action:@selector(netWork) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
//更新UI
-(void)netWorkInfo
{
    
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.orderId forKey:@"id"];
    
    __weak typeof(self) weak= self;
    
    NSLog(@"%@",parm);
    [NetWork postNoParm:YZX_qiangdanxiangqing params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if([[responseObj objectForKey:@"result"]isEqualToString:@"1"])
        {
            self.Model = [DWOrderModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
            [weak makeUI];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark  更新界面
-(void)makeUI
{
    self.adresslb.text = self.Model.adr;
    self.gongzuoneirong.text = self.Model.gongzuoneirong;
    self.renshu.text = [NSString stringWithFormat:@"%@",self.Model.n];
    self.startdate.text =self.Model.kaigongriqi;
    self.jiage.text = [NSString stringWithFormat:@"%@",_Model.price ];
    self.beizhu.text = self.Model.beizhu;
    self.yuJiTianShu.text = self.Model.yuji;
    self.yuJiTianShu.textColor = [UIColor redColor];
    

    NSString *shengyu = [NSString stringWithFormat:@"%d人",[_Model.n intValue]-[_Model.yizhaorenshu intValue]];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:shengyu];
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, shengyu.length-1)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, shengyu.length-1)];
    
    self.shengYuRenShu.attributedText = attributeStr;
    
    //头像
     NSString *HeadPicUrl = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,self.Model.headpic];

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:HeadPicUrl] placeholderImage:[UIImage imageNamed:@"定位_08"]];
    
    self.gongZhong.text = _Model.gzname;
    self.lianXiRen.text = _Model.lianxiren;
    //星级
    self.xingji = _Model.xing;
    
    self.iconImage.layer.cornerRadius = self.iconImage.width/2;
    self.iconImage.layer.masksToBounds = YES;
    
    //显示隐藏保证金

    if ([_Model.baozhengjin doubleValue]>0) {
        
        self.baozhengjinBtn.hidden = NO;
    }else
    {
       self.baozhengjinBtn.hidden = YES;
    }
}
//设置星级
-(void)setXingji:(NSString *)xingji
{
    //设置星级
    [Function xingji:self.view xingji:[xingji intValue] startTag:101];
}

#pragma mark 订单列表_抢
-(void)netWork
{
    ADAccount *acount = [ADAccountTool account];
    DWOrderModel *model = self.Model;
    NSLog(@"%@",model.ID);
    NSLog(@"%@",acount.userid);
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:model.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_qiangdan params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            //提示抢单成功
            grabOrderV = [grabOrderResult LoadView];
            //grabOrderV.frame = CGRectMake(50, 200, SCREEN_WIDTH -100, SCREEN_WIDTH -100);
            grabOrderV.frame = CGRectMake((SCREEN_WIDTH-227)/2, 200, 227, 217);
            
           [grabOrderV YesBtnAddTarget:self action:@selector(makeSureClicked) forControlEvents:UIControlEventTouchUpInside];
            grabOrderV.info.text = [[responseObj objectForKey:@"data"]objectForKey:@"info"];
            grabOrderV.info2.text = [[responseObj objectForKey:@"data"]objectForKey:@"info2"];
            
            
            backView = [Function createBackView:self action:@selector(backViewClicked)];
            [[[UIApplication sharedApplication]keyWindow]addSubview:backView];
            [[[UIApplication sharedApplication]keyWindow]addSubview:grabOrderV];
            
            
        }else
        {
            //垃圾返回数据 需要判断data数组来判定信息类型
            if([[responseObj objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
                return ;
            }
            
            fileOrderV = [FileOrderResult LoadView];
            //fileOrderV.frame = CGRectMake(50, 200, SCREEN_WIDTH -100, SCREEN_WIDTH -100);
            
            fileOrderV.frame = CGRectMake((SCREEN_WIDTH-227)/2, 200, 227, 217);
            
            [fileOrderV YesBtnAddTarget:self action:@selector(makeSureClicked) forControlEvents:UIControlEventTouchUpInside];
            fileOrderV.info.text = [[responseObj objectForKey:@"data"]objectForKey:@"info"];
            fileOrderV.info2.text = [[responseObj objectForKey:@"data"]objectForKey:@"info2"];
            
            
            backView = [Function createBackView:self action:@selector(backViewClicked)];
            [[[UIApplication sharedApplication]keyWindow]addSubview:backView];
            [[[UIApplication sharedApplication]keyWindow]addSubview:fileOrderV];
            
            //[ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
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
    [fileOrderV removeFromSuperview];
    pop
    
    self.baiBianBtn.userInteractionEnabled = NO;
    
}


- (IBAction)orderAction:(id)sender {
    
}

#pragma mark 取消订单
-(void)quxiaoOrderC
{
    
    if (self.shawdowView != nil) {
        [self.shawdowView removeFromSuperview];
    }
    
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    //抢单id
    [parm setObject:self.orderModel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_quxiaodingdan_gr params:parm success:^(id responseObj) {
         //NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        pop
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网路错误"];
    }];
}

#pragma mark 实时结算
-(void)jisuanOrderC
{
    if (self.shawdowView != nil) {
        [self.shawdowView removeFromSuperview];
    }
    
    _jiesuanView = [jieSuanView LoadView];
    
    __weak typeof (self)weakSelf = self;
    [_jiesuanView jieSuan:self.orderModel jiesuansucess:^(NSDictionary *response) {
        NSLog(@"%@",response);
        
        if ([[response objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[response objectForKey:@"message"]];
        }
        pop

        
    } JieSuanFaluse:^(NSDictionary *response) {
        
    }];

    
}

#pragma mark 确认收款
-(void)queRenShouKuanC
{
    if (self.shawdowView != nil) {
        [self.shawdowView removeFromSuperview];
    }
    // NSLog(@"123");
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    //抢单id
    [parm setObject:self.orderModel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_querenshoukuan params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        pop
        
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网路错误"];
    }];
}


#pragma mark 删除订单
-(void)shanchuOrderC
{
    if (self.shawdowView != nil) {
        [self.shawdowView removeFromSuperview];
    }
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    //抢单id
    [parm setObject:self.orderModel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_shanchudingdan_gr params:parm success:^(id responseObj) {
        // NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        pop
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网路错误"];
    }];
}

@end
