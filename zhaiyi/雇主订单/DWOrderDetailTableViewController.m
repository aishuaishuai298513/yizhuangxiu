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

//标志按钮状态
typedef NS_ENUM(NSUInteger, CellBtnState) {
    PAY,//支付
    DISCHARGE,//辞退
    EVALUATE//评价
};

@interface DWOrderDetailTableViewController ()

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

//底部弹出透明View
@property (nonatomic, strong) UIView *bg;
//友情提示框
@property (nonatomic, strong) UIView *firendPopView;
//凭证提示框
@property(nonatomic, strong) CertificatePayView *certificatePayView;

//遮盖
@property (nonatomic, strong) UIView *BackView;
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
    [self.navigationItem setTitle:@"订单详情"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DWOrderDetailCell" bundle:nil] forCellReuseIdentifier:@"DWOrderDetailCell"];
    [self configueRightBtn];
    
    //查询订单详情
    [self QiangDanYonghu];
   //[self creatOrderUi];
    
}


//订单数据赋值
-(void)creatOrderUi
{
    self.HeaderDate.text = self.OrderModel.createtime;
    
    self.headerDingdan.text = self.OrderModel.ordercode;
    
    self.HeaderAdress.text = self.OrderModel.adr;
    
    self.HeaderGongzuoneirong.text = self.OrderModel.gongzuoneirong;
    
    self.gongzhong.text = self.OrderModel.gzname;
    
    
    self.danRiGongzi.text = [NSString stringWithFormat:@"单日工资:%d",[self.OrderModel.price intValue]];
    self.HeaderRenshu.text = [NSString stringWithFormat:@"人数:%@",self.OrderModel.n];
    
    if ([self.OrderModel.baozhengjin intValue]>0) {
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
    
    //发布中
    if (self.type == 1)
    {
        rightBtn.hidden = NO;
         rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
       [rightBtn setBackgroundImage:[UIImage imageNamed:@"确认开工.png"] forState:UIControlStateNormal];
       [rightBtn setTitle:@"确认开工" forState:UIControlStateNormal];
       [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    //施工中
    if (self.type == 2) {
        rightBtn.hidden = YES;

    }
    //已竣工
    else if(self.type == 3)
    {
        rightBtn.hidden = YES;

    }
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
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
    
    //已竣工
    if (self.type == 3) {
        
        [cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
        [cell.cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.cellBtn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
    //发布中
    }else if (self.type == 1){
        if ([userInfoM.status isEqualToString:@"8"]) {
            
            [cell.cellBtn setTitle:@"辞退" forState:UIControlStateNormal];
            [cell.cellBtn addTarget:self action:@selector(ciTui:) forControlEvents:UIControlEventTouchUpInside];
        }

    }else if(self.type == 2){
        //施工中
       // cell.cellBtn.hidden = YES;
        
        switch ([userInfoM.status intValue]) {
            //工作中
            case 9:
                [cell.cellBtn setTitle:@"辞退" forState:UIControlStateNormal];
                [cell.cellBtn addTarget:self action:@selector(ciTui:) forControlEvents:UIControlEventTouchUpInside];
                break;
                //已辞退
            case 10:
                [cell.cellBtn setTitle:@"已辞退" forState:UIControlStateNormal];
                cell.cellBtn.userInteractionEnabled = NO;
                break;
                //带结算
            case 11:
                
                self.btnState = PAY;
                [cell.cellBtn setTitle:@"去支付" forState:UIControlStateNormal];
                [cell.cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [cell.cellBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
                [cell.cellBtn addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
                break;
                //已结算
            case 12:
                
                [cell.cellBtn setTitle:@"评价" forState:UIControlStateNormal];
                [cell.cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [cell.cellBtn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                break;
        }
        
    }
    
    cell.cellBtn.tag = 100+indexPath.row;
    cell.typelb.text = userInfoM.gzname;
    cell.jieshao.text = userInfoM.ziwojieshao;
    cell.namelb.text = userInfoM.name;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self checkGongRenInfo:indexPath.row];
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
        
        NSLog(@"123");
        self.BackView = [Function createBackView:self action:@selector(BackViewClicked)];
        
        self.certificatePayView = [CertificatePayView loadView];
        //添加点击事件
        [self.certificatePayView addTargetWithCancleBtnClicked:self action:@selector(CertificateCnclebtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.certificatePayView addTargetWithMakeSureBtnClicked:self action:@selector(CertificateMakeSureClicked) forControlEvents:UIControlEventTouchUpInside];
        
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
}
#pragma mark 支付凭证取消按钮点击事件
-(void)CertificateCnclebtnClicked
{
    [self BackViewClicked];

}
#pragma mark 支付凭证确认点击事件
-(void)CertificateMakeSureClicked
{
    [self BackViewClicked];
    My_pocket_Controller *zhifu = [[My_pocket_Controller alloc]init];
    [self.navigationController pushViewController:zhifu animated:YES];
    
}

#pragma mark 点击cell跳到工人详情页/辞退
-(void)checkGongRenInfo:(int)indexpathRow
{
        //工人信息
        DWEmployerDetailController *vc = [[DWEmployerDetailController alloc] initWithNibName:@"DWEmployerDetailController" bundle:nil];
        
        vc.type = self.type;
        vc.orderModel = self.UsersdataSource[indexpathRow];
        [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark 评价
-(void)evaluate:(id)sender
{
    EvaluateViewController *evaluate = [[EvaluateViewController alloc]init];
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
    [firendView NoBtnAddTarget:self action:@selector(bgViewClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [firendView YesBtnAddTarget:self action:@selector(continueFaBu) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bg];
    [[UIApplication sharedApplication].keyWindow addSubview:firendView];

}

#pragma mark  是否可以确认y
-(void)ifQueRenYanShou
{
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:self.OrderModel.ID  forKey:@"send_id"];
    [NetWork postNoParm:IfQueRenZhaoYong params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            [self queRenYanShou];
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark 确认验收
-(void)queRenYanShou
{
    
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"user_id"];
    [parm setObject:self.OrderModel.ID forKey:@"order_id"];
    
    //评价
    DWConfirmCheckViewController *vc = [[DWConfirmCheckViewController alloc] initWithNibName:@"DWConfirmCheckViewController" bundle:nil];
    vc.UserDataSource = self.UsersdataSource;
    vc.Ordermodel = self.OrderModel;
    vc.TypeFrom = 1;
    //[self.navigationController pushViewController:vc animated:YES];
    
    __weak  typeof(self) WeakSelf = self;
    
    [NetWork postNoParm:guzhuyanShou params:parm success:^(id responseObj) {
        
                NSLog(@"%@",responseObj);
        
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            // 确认验收
            
            [WeakSelf.navigationController pushViewController:vc animated:YES];
            
        }else
        {
//            [WeakSelf.navigationController pushViewController:vc animated:YES];
//            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
    
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
