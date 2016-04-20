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
#import "TiXianDetailViewController.h"
#import "TradeRecordModel.h"
#import "MJRefresh.h"

@interface My_pocket_jiaoyijilu_ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tb;
    
    ADAccount *_account;
    
    NSArray *_dataArr;
    
    BOOL _noTrade;
    
    //float cash_count;
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
    
    _account = [ADAccountTool account];
    [self postData];

}

#pragma mark MJ下拉刷新
-(void)MJRfreshData{
    [tb.mj_header beginRefreshing];

    __weak typeof(self) weakSelf = self;
    tb.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [weakSelf postData];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return _dataArr.count;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = [NSArray array];
    array = [_dataArr[section] objectForKey:@"list"];
    return array.count;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    My_pocket_jiaoyijilu_ViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"My_pocket_jiaoyijilu_ViewCell" owner:self options:nil]lastObject];
    }
    
    
    NSArray *array = [NSArray array];
    array = [_dataArr[indexPath.section] objectForKey:@"list"];
 
    [cell RecordModel:[array objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"JiaoyiDetil" bundle:nil];
    My_pocket_jiaoyijiluDetil_ViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"JiaoyiDetil"];
    NSDictionary *dictList = [_dataArr[indexPath.section] objectForKey:@"list"][indexPath.row];
    test2obj.List = dictList;
    
    if ([[dictList objectForKey:@"leixing"]isEqualToString:@"33"]||[[dictList objectForKey:@"leixing"]isEqualToString:@"35"]) {
        
       [self.navigationController pushViewController:test2obj animated:YES];
    }else
    {
        TiXianDetailViewController *tixian = [[TiXianDetailViewController alloc]init];
        tixian.List= dictList;
        [self.navigationController pushViewController:tixian animated:YES];
    
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor myColorWithString:@"f4f4f4"];
    UILabel * time=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    time.text = [_dataArr[section] objectForKey:@"month"];
    time.font=[UIFont systemFontOfSize:14];
    [view addSubview:time];
    UILabel * mnoey=[[UILabel alloc]initWithFrame:CGRectMake(kU-100, 5, 90, 30)];
//     NSLog(@"交易记录 %@",_dataArr);
    
    mnoey.text= @"";
    mnoey.textAlignment=NSTextAlignmentRight;
    mnoey.font=[UIFont systemFontOfSize:14];
    [view addSubview:mnoey];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 交易记录
-(void)postData{
//    _dataArr = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_account.userid forKey:@"userid"];
    [params setObject:_account.token forKey:@"token"];
    NSLog(@"交易记录待上传信息 %@",params);
    [NetWork postNoParm:YZX_jiaoyijilu params:params success:^(id responseObj) {
        //NSLog(@"用户交易 %@",responseObj);
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
           _dataArr = [responseObj objectForKey:@"data"];
        }
        [tb.mj_header endRefreshing];
        [tb reloadData];
    } failure:^(NSError *error) {
        [tb.mj_header endRefreshing];
    }];
}


@end
