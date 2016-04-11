//
//  My_pocket_index_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_index_ViewController.h"
#import "My_pocket_Hongbao_ViewController.h"
#import "My_pocket_tixian_ViewController.h"
#import "My_pocket_jiaoyijilu_ViewController.h"
#import "My_pocket_recharge_Controller.h"
#import "PayPasswordViewController.h"
#import "PureLayout.h"
#import "MyMoney.h"
#import "BaoZhengJinViewController.h"


@interface My_pocket_index_ViewController ()
<UITableViewDataSource,UITableViewDelegate>

{
    UITableView * tb;
//    NSString *_lx;
    NSString *_moneyText;
    
    //储存钱数
    
    ADAccount *_account;
}
@property (strong, nonatomic) NSMutableDictionary *params;
//钱
@property (strong, nonatomic) NSMutableDictionary *moneyDict;

@property (strong, nonatomic) MyMoney *myMoney;


@end

@implementation My_pocket_index_ViewController

-(MyMoney *)myMoney
{
    if (!_myMoney) {
        _myMoney = [[MyMoney alloc]init];
    }
    return _myMoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"钱包";
    
     [self MakeUI];
 }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _account = [ADAccountTool account];
  //  _modifyDict = [ADAccountTool backWitDictionary];
    
    [self getMoneyData];
}


-(void)card
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"employersInMy" bundle:nil];
    UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"card"];
    [self.navigationController pushViewController:test2obj animated:YES];
}
-(void)MakeUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    _params = [NSMutableDictionary dictionary];
    
    
    tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kU , Ga)];
    tb.delegate=self;
    tb.dataSource=self;
    [self.view addSubview:tb];
    
    [self MJPullRefresh];
}
-(void)MJPullRefresh{
    
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getMoneyData];
    }];
}


#pragma mark  tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (GetUserDefaultsGR) {
        return 4;
    }else {
        return 6;
    }

}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (indexPath.row==0) {
        UITableViewCell * cell;
        if (!cell) {
            cell=[[UITableViewCell alloc]init];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        cell.contentView.backgroundColor=THEME_COLOR;
        
        UIButton * zhye=[[UIButton alloc]initWithFrame:CGRectMake(kU/3, 38, kU/3, 25)];
        [zhye setImage:[UIImage imageNamed:@"qianbao.png"] forState:UIControlStateNormal];
        [zhye setTitle:@" 账户余额" forState:UIControlStateNormal];
        zhye.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [cell.contentView addSubview:zhye];
        
        UILabel * money=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, kU, 50)];
        
        if (GetUserDefaultsGR) {

              money.text=[NSString stringWithFormat:@"￥123"];
            
        } else {
            if (self.myMoney.zhanghuyue) {
                money.text=[NSString stringWithFormat:@"￥%@",self.myMoney.zhanghuyue];
            }

        }
        money.textColor=[UIColor whiteColor];
        money.textAlignment=NSTextAlignmentCenter;
        money.font=[UIFont systemFontOfSize:45];
        [cell.contentView addSubview:money];
        //保证金
        
        UILabel *baozhengjin = [[UILabel alloc]init];
        baozhengjin.textColor = [UIColor whiteColor];
        baozhengjin.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:baozhengjin];
        
        [baozhengjin autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.contentView withOffset:30];
        [baozhengjin autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell.contentView withOffset:-20];
        if (GetUserDefaultsGR) {
            
            baozhengjin.text = @"保证金:33233";
            
        } else {
            if (self.myMoney.baozhengjin) {
                baozhengjin.text = [NSString stringWithFormat:@"保证金:%@",self.myMoney.baozhengjin];
            }
        }
        
        
        //可用余额
        UILabel *keyongyuelabel = [[UILabel alloc]init];
        keyongyuelabel.font = [UIFont systemFontOfSize:13];
        keyongyuelabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:keyongyuelabel];
        [keyongyuelabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.contentView withOffset:-30];
        [keyongyuelabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell.contentView withOffset:-20];
        
        if (GetUserDefaultsGR) {
            
            keyongyuelabel.text = @"可用余额:33233";
            
        } else {
            if (self.myMoney.keyongyue) {
                keyongyuelabel.text = [NSString stringWithFormat:@"可用余额:%@",self.myMoney.keyongyue];
            }
        }
        
        
        return cell;
        
    }else
    {
        UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            cell1=[[UITableViewCell alloc]init];
        }
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 150, 20)];
        title.font=[UIFont systemFontOfSize:17];
        [cell1.contentView addSubview:title];
        NSArray * name;
        if (GetUserDefaultsGR) {
            name=@[@"红包",@"提现",@"交易记录"];
        }else {
            name=@[@"红包",@"充值",@"提现",@"交易记录",@"修改支付密码"];

        }
        title.text=name[indexPath.row-1];
        title.textColor = THEME_COLOR;
        UIImageView * jt=[[UIImageView alloc]initWithFrame:CGRectMake(kU-30, 20, 10, 20)];
        jt.image=[UIImage imageNamed:@"right.png"];
        [cell1.contentView addSubview:jt];
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(10, 59, kU-10, 1)];
        view.backgroundColor=[UIColor myColorWithString:@"f4f4f4"];
        [cell1.contentView addSubview:view];
        return cell1;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 180;
    }else
    {
        return 60;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //红包
    if (indexPath.row==1) {
        My_pocket_Hongbao_ViewController *hb=[[My_pocket_Hongbao_ViewController alloc]init];
        [self.navigationController pushViewController:hb animated:YES];
    }else if(indexPath.row==2)
    {
        //工人提现
        if (GetUserDefaultsGR) {
//            My_pocket_tixian_ViewController *hb=[[My_pocket_tixian_ViewController alloc]init];
//            [self.navigationController pushViewController:hb animated:YES];
            
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"employersInMy" bundle:nil];
            UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"addcard"];
            [self.navigationController pushViewController:test2obj animated:YES];
            
        }
        //雇主充值
        else{
            My_pocket_recharge_Controller *recharge = [[My_pocket_recharge_Controller alloc]init];
            [self.navigationController pushViewController:recharge animated:YES];
        }
        
        //        NSLog(@"充值");
    }else if(indexPath.row==3)
    {
        //工人交易记录
        if (GetUserDefaultsGR) {
            My_pocket_jiaoyijilu_ViewController * hb=[My_pocket_jiaoyijilu_ViewController new];
            [self.navigationController pushViewController:hb animated:YES];
        }else{
            
            //雇主提现
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"employersInMy" bundle:nil];
            UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"addcard"];
            [self.navigationController pushViewController:test2obj animated:YES];
            
            
//            My_pocket_tixian_ViewController *hb=[[My_pocket_tixian_ViewController alloc]init];
//            [self.navigationController pushViewController:hb animated:YES];
        }
        
    }
    else if (indexPath.row==4)
    {
        //雇主交易记录
        if (GetUserDefaultsGZ) {
            My_pocket_jiaoyijilu_ViewController * hb=[My_pocket_jiaoyijilu_ViewController new];
            [self.navigationController pushViewController:hb animated:YES];
        }
    }
    
    else if (indexPath.row==5)
    {
        //修改支付密码
        if (GetUserDefaultsGZ) {
            PayPasswordViewController *payC = [[PayPasswordViewController alloc]init];
            payC.payController = updatePassword;
            [self.navigationController pushViewController:payC animated:YES];
        }
//        //保证金纪录
//        if (GetUserDefaultsGZ) {
//           
//            BaoZhengJinViewController *baozhengjin = [[BaoZhengJinViewController alloc]init];
//            [self.navigationController pushViewController:baozhengjin animated:YES];
//        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//钱包
-(void)getMoneyData{

    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:_account.userid forKey:@"userid"];
    [parm setObject:_account.token forKey:@"token"];
    
    [NetWork postNoParm:YZX_qianbao params:parm success:^(id responseObj) {
        NSLog(@"请求的金额 %@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            NSDictionary *moneyDict = [responseObj objectForKey:@"data"];
            NSLog(@"金额:  %@",[responseObj objectForKey:@"data"]);
            
            self.myMoney = [MyMoney mj_objectWithKeyValues:moneyDict];
            
            [tb reloadData];
            [tb.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"请求的金额 %@",error.localizedDescription);
        [tb.mj_header endRefreshing];
    }];
    
    
}


@end
