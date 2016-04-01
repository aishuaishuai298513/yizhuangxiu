//
//  My_pocket_jiaoyijilu_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_jiaoyijilu_ViewController.h"
#import "My_pocket_jiaoyijilu_ViewCell.h"
#import "My_pocket_jiaoyijiluDetil_ViewController.h"
#import "TradeRecordModel.h"
#import "MJRefresh.h"

@interface My_pocket_jiaoyijilu_ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tb;
    
    ADAccount *_account;
    
    NSArray *_dataArr;
    
    BOOL _noTrade;
    
    float cash_count;
}


@end

@implementation My_pocket_jiaoyijilu_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"交易记录";
    // Do any additional setup after loading the view from its nib.
    [self MakeUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initalData];
}

-(void)MakeUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kU , Ga)];
    tb.delegate=self;
    tb.dataSource=self;
//    tb.bounces=NO;
    UIView *footerV = [UIView new];
    [tb setTableFooterView:footerV];
    [self.view addSubview:tb];
    [self MJRfreshData];

}

-(void)initalData{
    
    cash_count = 0.0;
    _account = [ADAccountTool account];
    [self postData];

}

#pragma mark MJ下拉刷新
-(void)MJRfreshData{
    [tb.mj_header beginRefreshing];

    __weak typeof(self) weakSelf = self;
    tb.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        cash_count = 0.0;
        [weakSelf postData];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    My_pocket_jiaoyijilu_ViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"My_pocket_jiaoyijilu_ViewCell" owner:self options:nil]lastObject];
    }
 
    [cell RecordModel:[_dataArr objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"JiaoyiDetil" bundle:nil];
    UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"JiaoyiDetil"];
    NSDictionary *dict = [_dataArr objectAtIndex:indexPath.row];
    NSLog(@"对应订单详情 %@",dict);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"pocket_tade_detail"];
    [userDefaults synchronize];
    [self.navigationController pushViewController:test2obj animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_noTrade) {
        UIView * view=[[UIView alloc]init];
        view.backgroundColor=[UIColor myColorWithString:@"f4f4f4"];
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kU-20, 30)];
        label.text=@"暂时没有交易记录";
        label.textAlignment = NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:16];
        [view addSubview:label];
        return view;
    } else {
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor myColorWithString:@"f4f4f4"];
    UILabel * time=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    time.text = @"2016年";
    time.font=[UIFont systemFontOfSize:14];
    [view addSubview:time];
    UILabel * mnoey=[[UILabel alloc]initWithFrame:CGRectMake(kU-100, 5, 90, 30)];
//     NSLog(@"交易记录 %@",_dataArr);
     for (NSDictionary *dict in _dataArr) {
       float cash = [[dict objectForKey:@"carry_cash"] floatValue];
        cash_count  = cash_count + cash;
    }
    mnoey.text= [NSString stringWithFormat:@"%.2f",cash_count];
    mnoey.textAlignment=NSTextAlignmentRight;
    mnoey.font=[UIFont systemFontOfSize:14];
    [view addSubview:mnoey];
    return view;
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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

-(void)postData{
//    _dataArr = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_account.userid forKey:@"user_id"];
//    [params setObject:_account.type forKey:@"type"];
    NSLog(@"交易记录待上传信息 %@",params);
    [NetWork postNoParm:POST_USER_TRADE params:params success:^(id responseObj) {
        NSLog(@"用户交易 %@",responseObj);
        _dataArr = [responseObj objectForKey:@"data"];
        if ([[responseObj objectForKey:@"message"] isEqualToString:@"暂时没有交易记录"]) {
            _noTrade = YES;
        }else{
            _noTrade = NO;
            
        }
        [tb.mj_header endRefreshing];
        [tb reloadData];
    } failure:^(NSError *error) {
        [tb.mj_header endRefreshing];
    }];
}


@end
