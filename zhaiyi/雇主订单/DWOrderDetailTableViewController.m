//
//  DWOrderDetailTableViewController.m
//  zhaiyi
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWOrderDetailTableViewController.h"
#import "DWOrderDetailCell.h"
#import "DWOrderViewController.h"
#import "DWEmployerDetailController.h"
#import "DWevaluateListViewController.h"
#import "DWConfirmCheckViewController.h"
#import "EvaluateViewController.h"
#import "MJExtension.h"
#import "PureLayout.h"
//人数没招满提示框
#import "FriendPrompt.h"
//支付凭证提示框
#import "CertificatePayView.h"
//支付页面
#import "My_pocket_Controller.h"
//模型
#import "DetialUserInfoM.h"
//找工人
#import "employersLookingViewController.h"

#import "PayInfoModel.h"

#import "GzJIeSuanView.h"
//标志按钮状态
typedef NS_ENUM(NSUInteger, CellBtnState) {
    PAY,//支付
    DISCHARGE,//辞退
    EVALUATE,//评价
    NoButton
};

@interface DWOrderDetailTableViewController ()

{
    NSTimer *timer;
    //红点
    UIImageView *RedimagV;
}

@property (strong, nonatomic) IBOutlet UIView *DWOrderHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *HeaderZhuangTai;

@property (weak, nonatomic) IBOutlet UIButton *HeaderGongZhong;

@property (weak, nonatomic) IBOutlet UILabel *HeaderDate;

@property (weak, nonatomic) IBOutlet UILabel *HeaderAdress;

@property (weak, nonatomic) IBOutlet UILabel *HeaderGongzuoneirong;

@property (weak, nonatomic) IBOutlet UILabel *gongzhong;
@property (weak, nonatomic) IBOutlet UILabel *HeaderRenshu;
@property (weak, nonatomic) IBOutlet UILabel *danRiGongzi;

@property (weak, nonatomic) IBOutlet UILabel *headerBaoxian;
@property (weak, nonatomic) IBOutlet UILabel *headerDingdan;

@property (weak, nonatomic) IBOutlet UIButton *HeaderImageBtn;

//标志按钮状态
@property (nonatomic ,assign) CellBtnState btnState;


@property (strong, nonatomic) UIButton *rightButton;

@property (nonatomic ,strong) NSMutableArray *UsersdataSource;
//支付信息模型
@property (nonatomic, strong) PayInfoModel *payInfoModel;
//工人列表信息
@property (nonatomic, strong) DetialUserInfoM *infoM;

//底部弹出透明View
@property (nonatomic, strong) UIView *bg;
//友情提示框
@property (nonatomic, strong) UIView *firendPopView;
//凭证提示框
@property(nonatomic, strong) CertificatePayView *certificatePayView;

//已结算凭证
@property(nonatomic, strong) GzJIeSuanView *gzJIeSuanView;

//遮盖
@property (nonatomic, strong) UIView *BackView;

//控制红日闪烁
@property (nonatomic, assign) BOOL Statue;

@property (nonatomic, assign)CGFloat *headerHeight;

@end

@implementation DWOrderDetailTableViewController


-(NSMutableArray *)UsersdataSource
{
    if (_UsersdataSource == nil) {
        _UsersdataSource = [NSMutableArray array];
    }
    return _UsersdataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.DWOrderHeaderView;
    self.tableView.tableHeaderView.height =self.danRiGongzi.y+self.danRiGongzi.height+30;
    [self.navigationItem setTitle:@"订单详情"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DWOrderDetailCell" bundle:nil] forCellReuseIdentifier:@"DWOrderDetailCell"];
    [self configueRightBtn];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    if(iOS8)
    {
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }else
    {
        self.tableView.rowHeight = 119;
    }
   //[self creatOrderUi];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //查询订单详情
    [self QiangDanYonghu];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
}


//订单数据赋值
-(void)creatOrderUi
{
    self.HeaderDate.text = self.OrderModel.createtime;
    self.HeaderDate.font = [UIFont systemFontSizeWithScreen:14];
    
    self.headerDingdan.text = self.OrderModel.ordercode;
    self.headerDingdan.font = [UIFont systemFontSizeWithScreen:12];
    
    self.HeaderAdress.text = self.OrderModel.adr;
    self.HeaderAdress.font = [UIFont systemFontSizeWithScreen:15];
    
    self.HeaderGongzuoneirong.text = [NSString stringWithFormat:@"工作内容:%@",self.OrderModel.gongzuoneirong];
    self.HeaderGongzuoneirong.font = [UIFont systemFontSizeWithScreen:14];
    
    self.gongzhong.text = [NSString stringWithFormat:@"工种:%@",self.OrderModel.gzname];
    self.gongzhong.font = [UIFont systemFontSizeWithScreen:13];
    
    self.HeaderZhuangTai.font = [UIFont systemFontSizeWithScreen:13];
    
    [self.HeaderGongZhong setTitle:self.OrderModel.gzname forState:UIControlStateNormal];
    
    
    self.danRiGongzi.text = [NSString stringWithFormat:@"单日工资:%.2f",[self.OrderModel.price floatValue]];
    self.danRiGongzi.font = [UIFont systemFontSizeWithScreen:13];
    
    self.HeaderRenshu.text = [NSString stringWithFormat:@"人数:%@",self.OrderModel.n];
    self.HeaderRenshu.font = [UIFont systemFontSizeWithScreen:13];
    
    if ([self.OrderModel.baozhengjin floatValue]>0) {
        [self.HeaderImageBtn setBackgroundImage:[UIImage imageNamed:@"保"] forState:UIControlStateNormal];
    }else
    {
        self.HeaderImageBtn.hidden = YES;
    }
}
#pragma mark 设置右上角按钮状态
- (void)configueRightBtn{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 80, 26)];
    self.rightButton = rightBtn;
    [rightBtn addTarget:self action:@selector(confirmCheck) forControlEvents:UIControlEventTouchUpInside];
    //红点
    RedimagV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 4)];
    RedimagV.image = [UIImage imageNamed:@"dian"];

    
    //发布中
    if (self.type == 1)
    {
        rightBtn.hidden = NO;
        RedimagV.hidden = NO;
        
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
       [rightBtn setBackgroundImage:[UIImage imageNamed:@"确认开工.png"] forState:UIControlStateNormal];
       [rightBtn setTitle:@"确认招用" forState:UIControlStateNormal];
       [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        //日一般的红点闪啊闪   呵呵
        timer = [NSTimer  scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(redPointAppear) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode: NSDefaultRunLoopMode];
    }
    
    //施工中
    if (self.type == 2) {
        rightBtn.hidden = YES;
        RedimagV.hidden = YES;

    }
    
    //已竣工
    else if(self.type == 3)
    {
        rightBtn.hidden = YES;
        RedimagV.hidden = YES;
        self.HeaderZhuangTai.text = @"(已竣工)";

    }
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIBarButtonItem *redPointBtnItem = [[UIBarButtonItem alloc]initWithCustomView:RedimagV];
    
    
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
   // [self.navigationItem setLeftBarButtonItems:[NSArrayarrayWithObjects: anotherButton,anotherButton2,nil]];
    NSArray *array = @[rightBarBtnItem,redPointBtnItem];
    [self.navigationItem setRightBarButtonItems:array];
    
    
}

-(void)redPointAppear
{
    if (_Statue) {
        RedimagV.hidden = NO;
    }else
    {
        RedimagV.hidden = YES;
    }
    
    _Statue = !_Statue;
}

- (void)confirmCheck{

    // 确认开工／招用
    [self queRenZhaoYong];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.UsersdataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    未开工
//    8
//    工作中
//    9
//    已辞退
//    10
//    待结算
//    11
//    已结算
//    12
//    已确认收款
//    13
    DetialUserInfoM *userInfoM = self.UsersdataSource[indexPath.row];
    
    DWOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWOrderDetailCell"];
    
    cell.yiCiTuiBtn.hidden = YES;
    cell.userInteractionEnabled = YES;
    
//    //已竣工
//    if (self.type == 3) {
//        
//        [cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
//        [cell.cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [cell.cellBtn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
//    //发布中
//    }else if (self.type == 1){
//        if ([userInfoM.status isEqualToString:@"8"]) {
//            
//            [cell.cellBtn setTitle:@"辞退" forState:UIControlStateNormal];
//            [cell.cellBtn addTarget:self action:@selector(ciTui:) forControlEvents:UIControlEventTouchUpInside];
//        }
//
//    }else if(self.type == 2){
//        
//    }
    //37正常工作38已被辞退
    if([userInfoM.shifoucitui isEqualToString:@"38"])
    {
        cell.yiCiTuiBtn.hidden = NO;
    }
    cell.cellBtn.enabled = YES;
    
    switch ([userInfoM.status intValue]) {
            //工作中
        case 9:
            [cell.cellBtn setTitle:@"辞退" forState:UIControlStateNormal];
            [cell.cellBtn setTitleColor:THEME_COLOR  forState:UIControlStateNormal];
            //[cell.cellBtn addTarget:self action:@selector(ciTui:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellBtn.userInteractionEnabled = NO;
            [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
            break;
        case 8:
            [cell.cellBtn setTitle:@"辞退" forState:UIControlStateNormal];
            [cell.cellBtn setTitleColor:THEME_COLOR  forState:UIControlStateNormal];

            //[cell.cellBtn addTarget:self action:@selector(ciTui:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellBtn.userInteractionEnabled = NO;
            [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
            break;
            //已辞退
            //已辞退
        case 10:
            cell.yiCiTuiBtn.hidden = NO;
            [cell.cellBtn setTitle:@"已辞退" forState:UIControlStateNormal];
            [cell.cellBtn setTitleColor:THEME_COLOR  forState:UIControlStateNormal];

            [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
            cell.cellBtn.userInteractionEnabled = NO;
            break;
            //待结算
        case 11:
            
            self.btnState = PAY;

            [cell.cellBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [cell.cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"红色圆形button"] forState:UIControlStateNormal];
            [cell.cellBtn addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
            break;
            //已结算
        case 12:
            if ([userInfoM.pingjia isEqualToString:@"1"]) {
                
               [cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
            }else
            {
                [cell.cellBtn setTitle:@"已评价" forState:UIControlStateNormal];
                 cell.cellBtn.enabled = NO;
            }
            [cell.cellBtn removeTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
            
            //[cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
            
           // [cell.cellBtn setTitleColor:THEME_COLOR  forState:UIControlStateNormal];

            [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
            [cell.cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cell.cellBtn.tag = 100+indexPath.row;
            [cell.cellBtn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 13:
            
            if ([userInfoM.pingjia isEqualToString:@"1"]) {
                
                [cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
            }else
            {
                [cell.cellBtn setTitle:@"已评价" forState:UIControlStateNormal];
                 cell.cellBtn.enabled = NO;
            }
            
            [cell.cellBtn removeTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
            //[cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
            //[cell.cellBtn setTitleColor:THEME_COLOR  forState:UIControlStateNormal];

            [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
            [cell.cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cell.cellBtn.tag = 100+indexPath.row;
            [cell.cellBtn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 39:
            
            cell.cellBtn.userInteractionEnabled = NO;
            
            if ([userInfoM.pingjia isEqualToString:@"1"]) {
                
                [cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
            }else
            {
                [cell.cellBtn setTitle:@"已评价" forState:UIControlStateNormal];
                cell.cellBtn.enabled = NO;
            }
            
            //[cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
            //[cell.cellBtn setTitleColor:THEME_COLOR  forState:UIControlStateNormal];

            [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
            [cell.cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cell.cellBtn.tag = 100+indexPath.row;
            [cell.cellBtn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];

            break;
            
        default:
            break;
    }

    
    cell.cellBtn.tag = 100+indexPath.row;
    cell.typelb.text = userInfoM.gzname;
    
    //保证btn的位置
    cell.jieshao.text = userInfoM.ziwojieshao;
    if (!cell.jieshao.text.length) {
        cell.jieshao.text = @" ";
    }
    cell.namelb.text = userInfoM.name;
    cell.distanceL.text =[NSString stringWithFormat:@"距离%.1fkm",[userInfoM.juli floatValue]];
    
//    cell.namelb.font = [UIFont systemFontSizeWithScreen:17];
//    cell.typelb.font = [UIFont systemFontSizeWithScreen:16];
//    cell.jieshao.font = [UIFont systemFontSizeWithScreen:15];
    
    cell.namelb.font = [UIFont systemFontOfSize:17];
    cell.typelb.font = [UIFont systemFontOfSize:16];
    cell.jieshao.font = [UIFont systemFontOfSize:15];
    
    NSLog(@"%@",userInfoM.xing);
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,userInfoM.headpic]]];
    cell.iconImage.layer.cornerRadius = cell.iconImage.width/2;
    cell.iconImage.layer.masksToBounds = YES;
    
    [Function xingji:cell.contentView xingji:[userInfoM.xing intValue] startTag:1];

    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 72;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _infoM = self.UsersdataSource[indexPath.row];
    
    

    //已竣工  跳出结算详情
    if (self.type == 3) {
       // NSLog(@"123");
        //[self popJieSuanPingZheng:<#(PayInfoModel *)#> :<#(NSString *)#>]
        
        [self jiesuanPingZheng];
        
        
        return;
    }
    
    //DetialUserInfoM *userInfoM = self.UsersdataSource[indexPath.row];
    [self checkGongRenInfo:indexPath.row];
}

#pragma mark 弹出结算凭证
-(void)popJieSuanPingZheng:(PayInfoModel *)payInfoModel :(NSString *)name
{
    
    NSLog(@"%@",payInfoModel.gzname);
    NSLog(@"123");
    self.BackView = [Function createBackView:self action:@selector(BackViewClicked)];
    
    self.gzJIeSuanView = [GzJIeSuanView loadView];

    self.gzJIeSuanView.payinfoModel = payInfoModel;
    self.gzJIeSuanView.nameLa.text = name;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.BackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.gzJIeSuanView];
    
    //设置大小
    [self.gzJIeSuanView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.gzJIeSuanView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.gzJIeSuanView autoSetDimension:ALDimensionWidth toSize:300];
    [self.gzJIeSuanView autoSetDimension:ALDimensionHeight toSize:300];
}


#pragma mark 辞退
-(void)ciTui:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    DetialUserInfoM *model = self.UsersdataSource[btn.tag-100];
    [self checkGongRenInfo:(int)btn.tag-100];
}
#pragma mark 去支付
-(void)goPay:(id)sender
{
    //支付
    
    UIButton *btn = (UIButton *)sender;
    int row = (int)btn.tag-100;
    _infoM = self.UsersdataSource[row];
    
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:_infoM.ID forKey:@"id"];
    
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_zhifugongzipage params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            weakSelf.payInfoModel = [PayInfoModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
            
//            NSLog(@"%@",[responseObj objectForKey:@"data"]);
//            NSLog(@"%@",self.payInfoModel.gzname);
            
            [weakSelf popZhiFukuang:weakSelf.payInfoModel :_infoM.name];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 弹出支付框
-(void)popZhiFukuang:(PayInfoModel *)payInfoModel :(NSString *)name
{
    
    NSLog(@"%@",payInfoModel.gzname);
    NSLog(@"123");
    self.BackView = [Function createBackView:self action:@selector(BackViewClicked)];
    
    self.certificatePayView = [CertificatePayView loadView];
    //添加点击事件  拒绝支付
    [self.certificatePayView addTargetWithCancleBtnClicked:self action:@selector(CertificateCnclebtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //确定 去支付
    [self.certificatePayView addTargetWithMakeSureBtnClicked:self action:@selector(CertificateMakeSureClicked) forControlEvents:UIControlEventTouchUpInside];
    self.certificatePayView.payinfoModel = payInfoModel;
    self.certificatePayView.nameLa.text = name;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.BackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.certificatePayView];
    
    //设置大小
    [self.certificatePayView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.certificatePayView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.certificatePayView autoSetDimension:ALDimensionWidth toSize:300];
    [self.certificatePayView autoSetDimension:ALDimensionHeight toSize:300];
}

#pragma mark 遮盖背景置灰
-(void)BackViewClicked
{
    [self.BackView removeFromSuperview];
    [self.certificatePayView removeFromSuperview];
    [self.gzJIeSuanView removeFromSuperview]; 
}
#pragma mark 已结算凭证
-(void)jiesuanPingZheng
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
   [parm setObject:_infoM.ID forKey:@"id"];
    //[parm setObject:self.OrderID forKey:@"id"];
    
    NSLog(@"%@",parm);
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_jiesuanxiangqing params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            weakSelf.payInfoModel = [PayInfoModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
            
            //            NSLog(@"%@",[responseObj objectForKey:@"data"]);
            //            NSLog(@"%@",self.payInfoModel.gzname);
            
            [weakSelf popJieSuanPingZheng:weakSelf.payInfoModel :@"结算"];
        }
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark 支付凭证取消按钮点击事件
-(void)CertificateCnclebtnClicked
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:_infoM.ID forKey:@"id"];
    
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_jujuezhifu params:parm success:^(id responseObj) {
        //NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [self BackViewClicked];

}
#pragma mark 线下支付
-(void)xianxiaPay
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:_infoM.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_xianxia params:parm success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            [self BackViewClicked];
            pop
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 支付凭证确认点击事件 去支付
-(void)CertificateMakeSureClicked
{
    [self BackViewClicked];
    
    if([self.payInfoModel.zhifufangshi isEqualToString:@"线下"])
    {
        [self xianxiaPay];
        
    }else
    {
        My_pocket_Controller *zhifu = [[My_pocket_Controller alloc]init];
        zhifu.payInfoModel = self.payInfoModel;
        zhifu.detilInfoModel = _infoM;
        
        [self.navigationController pushViewController:zhifu animated:YES];
    }
    
}

#pragma mark 点击cell跳到工人详情页/辞退
-(void)checkGongRenInfo:(int)indexpathRow
{
        //工人信息
        DWEmployerDetailController *vc = [[DWEmployerDetailController alloc] initWithNibName:@"DWEmployerDetailController" bundle:nil];
    
    
        vc.type = self.type;
    
        vc.orderModel = self.UsersdataSource[indexpathRow];
         vc.OrderID = self.OrderID;
        [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark 评价
-(void)evaluate:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    DetialUserInfoM *userInfoM = self.UsersdataSource[btn.tag-100];

    EvaluateViewController *evaluate = [[EvaluateViewController alloc]init];
    evaluate.UserInfoM = userInfoM;
    [self.navigationController pushViewController:evaluate animated:YES];

}

//评价列表
-(void)netWork
{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:@"个人中心_评价列表" forKey:@"functionName"];
    [parm setObject:@"[1]" forKey:@"jsonParams"];
    
    [NetWork post:ZhaoGongRen params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 查询订单详情
-(void)QiangDanYonghu
{
    
    NSLog(@"%@",self.OrderModel.ID);
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.OrderID forKey:@"id"];
    
    __weak typeof (self)WeakSelf =self;
    [NetWork postNoParm:YZX_dingdanxiangqing params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        WeakSelf.OrderModel =[DWOrderModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
        
        WeakSelf.UsersdataSource = [DetialUserInfoM mj_objectArrayWithKeyValuesArray:[[responseObj objectForKey:@"data"] objectForKey:@"list"]];
    
        // 判断是否可开工
//        if (WeakSelf.UsersdataSource.count<=0 && self.type == 1) {
//            
//            self.rightButton.userInteractionEnabled = NO;
//        }
        
        [WeakSelf creatOrderUi];
        [WeakSelf.tableView reloadData];
        
        //判断是否弹出提示框
        if([[responseObj objectForKey:@"data"]objectForKey:@"tixing"]){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [[responseObj objectForKey:@"data"]objectForKey:@"tixing"];
            
            [WeakSelf tiShikuang:dic];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark 确认招用／开工
-(void)queRenZhaoYong
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.OrderID forKey:@"orderid"];
    
    [NetWork postNoParm:YZX_querenkaigong params:parm success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
          //跳到施工中
           DWOrderViewController *DWOrder =  self.navigationController.childViewControllers[1];
           DWOrder.pushWorking = YES;
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark 提示框
-(void)tiShikuang:(NSMutableDictionary *)dic
{
    //友情提示框
    FriendPrompt *firendView = [FriendPrompt FirendLoadView];
    self.firendPopView =firendView;
    firendView.frame = CGRectMake(30, SCREEN_WIDTH/2, SCREEN_WIDTH - 60, 200);
    
    firendView.label1.text = [dic objectForKey:@"info1"];
    firendView.label2.text = [dic objectForKey:@"info2"];
    
    //底部大的透明View
    self.bg = [Function createBackView:self action:@selector(bgViewClicked)];
    //no按钮添加事件
    [firendView NoBtnAddTarget:self action:@selector(queRenZhaoYong) forControlEvents:UIControlEventTouchUpInside];
    
    [firendView YesBtnAddTarget:self action:@selector(continueFaBu) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bg];
    [[UIApplication sharedApplication].keyWindow addSubview:firendView];

}


#pragma mark 继续发布订单
-(void)continueFaBu
{
    [self bgViewClicked];
    
    
    UIStoryboard *storyboard  = [UIStoryboard storyboardWithName:@"employersLooking" bundle:nil];
    employersLookingViewController *employer = [storyboard instantiateViewControllerWithIdentifier:@"employersLooking"];
    
    employer.isChongXinFaBu = YES;
    //订单ID
    employer.orderId = self.OrderID;
    
    [self.navigationController pushViewController:employer animated:YES];
    
}

//删除遮盖
-(void)bgViewClicked
{
    //底层遮盖点击事件
    [self.firendPopView removeFromSuperview];
    [self.bg removeFromSuperview];
    
    
}

@end
