//
//  workerOrderViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "workerOrderViewController.h"
#import "ADOrderViewCell.h"
#import "ADDetailController.h"
#import "AccessController.h"
#import "RightAccessViewCell.h"
#import "RithtViewController.h"

#import "DWOrderModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"

typedef enum
{
    getOrder = 1,//以抢单
    working = 2,//施工中
    worked = 3 //已竣工
    
    
    
}WorkStute;


@interface workerOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *orderTableView;


//左边按钮
@property (weak, nonatomic) IBOutlet UIButton *leftleftBtn;
//中间按钮
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
//右边按钮
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLeftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLeftDownLabel;


//施工中
@property (nonatomic, strong) NSMutableArray *WorkingdataSource;
//已竣工
@property (nonatomic, strong) NSMutableArray *WorkedDataSource;
@property (nonatomic, strong) NSMutableArray *getOrderDataSource;

@property (nonatomic, assign) int PageIndex;

@property (nonatomic, assign) NSInteger WorkStatue;

//点击事件
- (IBAction)leftBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;
- (IBAction)leftleftBtnClicked:(id)sender;


@end

@implementation workerOrderViewController
//懒加载
-(NSMutableArray *)WorkedDataSource{
    if (!_WorkedDataSource) {
        _WorkedDataSource = [NSMutableArray array];
    }
    return  _WorkedDataSource;
}
-(NSMutableArray *)WorkingdataSource{
    if (!_WorkingdataSource) {
        _WorkingdataSource = [NSMutableArray array];
    }
    return  _WorkingdataSource;
}

-(NSMutableArray *)getOrderDataSource
{
    if (!_getOrderDataSource) {
        _getOrderDataSource = [NSMutableArray array];
    }
    return _getOrderDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //左边按钮颜色
    UIView *view = [UIView new];
    [self.orderTableView setTableFooterView:view];
    _PageIndex = 1;
   // _WorkStatue = getOrder;
//    [self MJRefreshPullRefresh];
//    [self MJRefreshLoadMore];
    //[self netWorkWorking:getOrder];
    
    //设置cell的高度自适应
    self.orderTableView.rowHeight = UITableViewAutomaticDimension;
    self.orderTableView.estimatedRowHeight =120;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   // [self gongRenDingDan];
    [self leftleftBtnClicked:nil];
    //[self netWorkWorked];
}

//下拉刷新
-(void)MJRefreshPullRefresh{
     NSLog(@"下拉刷新");
    
    __weak typeof(self) weakSelf = self;
    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _PageIndex = 1;
        if (_WorkStatue == working) {
            
            [weakSelf.WorkingdataSource removeAllObjects];
            //[weakSelf netWorkWorking];
        }
        if (_WorkStatue == worked)
        {
            [weakSelf.WorkedDataSource removeAllObjects];
            //[weakSelf netWorkWorked];
        }
        if (_WorkStatue == getOrder) {
            //需要修改
            [weakSelf.WorkingdataSource removeAllObjects];
            //[weakSelf netWorkWorking];
        }
        
    }];
}

//上拉加载
-(void)MJRefreshLoadMore{
    NSLog(@"上拉加载");
    __weak typeof(self) weakSelf = self;
    self.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _PageIndex++;

        if (_WorkStatue == working) {
            //[weakSelf netWorkWorking];
        }
        else if(_WorkStatue == worked){
            //[weakSelf netWorkWorked];
        }else
        {
            //待修改
           // [weakSelf netWorkWorking];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.WorkingdataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //施工中
    if (_WorkStatue == working) {
     
        static NSString *ID = @"order";
        ADOrderViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!orderCell) {
            orderCell = [ADOrderViewCell cell];
        }
        if (_WorkingdataSource.count != 0) {
            orderCell.OrderModel = self.WorkingdataSource[indexPath.row];

        }
        return orderCell;
    }

    //已竣工
    else if(_WorkStatue == worked)
    {
        static NSString *ID = @"access";
        ADOrderViewCell *access = [tableView dequeueReusableCellWithIdentifier:ID];

        if (!access) {
            access = [ADOrderViewCell cell];
        }
        
        if (_WorkedDataSource.count != 0) {
            access.OrderModel = self.WorkedDataSource[indexPath.row];
        }
        [access setNeedsUpdateConstraints];
        
        return access;
    }
    else
    {
        static NSString *ID = @"order";
        ADOrderViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!orderCell) {
            orderCell = [ADOrderViewCell cell];
        }
        if (_WorkingdataSource.count != 0) {
            orderCell.OrderModel = self.WorkingdataSource[indexPath.row];
            
        }
        return orderCell;

    }
    
}
#pragma mark---代理方法
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 110;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_WorkStatue == working) {
        
        ADDetailController *detail = [[ADDetailController alloc]init];
        detail.OrderModel = self.WorkingdataSource[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if(_WorkStatue == worked)
    {
        RithtViewController *right = [[RithtViewController alloc]init];
        right.Ordermodel = self.WorkedDataSource[indexPath.row];
        [self.navigationController pushViewController:right animated:NO];

    }else
    {//待调整
        ADDetailController *detail = [[ADDetailController alloc]init];
        detail.OrderModel = self.WorkingdataSource[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (IBAction)leftBtnClick:(id)sender {
    
    _PageIndex = 1;
    
    self.leftTopLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:44/255.0 blue:65/255.0 alpha:1];
    self.leftDownLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:44/255.0 blue:65/255.0 alpha:1];
    self.leftTopLabel.textColor = [UIColor whiteColor];
    self.leftDownLabel.textColor = [UIColor whiteColor];
    
    self.leftLeftTopLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftLeftDownLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftLeftTopLabel.textColor = [UIColor blackColor];
    self.leftLeftDownLabel.textColor = [UIColor blackColor];

    
    self.rightTopLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.rightdownLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.rightTopLabel.textColor = [UIColor blackColor];
    self.rightdownLabel.textColor = [UIColor blackColor];
    
    _WorkStatue = working;
    NSLog(@"%ld",_WorkStatue);
    
    
    
    
    //施工中接口
    [self.WorkingdataSource removeAllObjects];
    [self netWorkWorking:working];
//
    [self.orderTableView reloadData];
  }

- (IBAction)rightBtnClick:(id)sender {
    
    _PageIndex = 1;
    
    self.leftTopLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftDownLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftTopLabel.textColor = [UIColor blackColor];
    self.leftDownLabel.textColor = [UIColor blackColor];
    
    self.leftLeftTopLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftLeftDownLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftLeftTopLabel.textColor = [UIColor blackColor];
    self.leftLeftDownLabel.textColor = [UIColor blackColor];
    
    
    self.rightTopLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:44/255.0 blue:65/255.0 alpha:1];
    self.rightdownLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:44/255.0 blue:65/255.0 alpha:1];
    self.rightTopLabel.textColor = [UIColor whiteColor];
    self.rightdownLabel.textColor = [UIColor whiteColor];
    
    _WorkStatue = worked;
    
    NSLog(@"%ld",_WorkStatue);
    
    //已竣工列表
    [self.WorkedDataSource removeAllObjects];
    [self netWorkWorking:worked];
    
//    [self.orderTableView reloadData];
    
//    AccessController *access = [[AccessController alloc]init];
//    [self.navigationController pushViewController:access animated:NO];
}

- (IBAction)leftleftBtnClicked:(id)sender {
    
    _PageIndex = 1;
    
    self.leftLeftTopLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:44/255.0 blue:65/255.0 alpha:1];
    self.leftLeftDownLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:44/255.0 blue:65/255.0 alpha:1];
    self.leftLeftTopLabel.textColor = [UIColor whiteColor];
    self.leftLeftDownLabel.textColor = [UIColor whiteColor];
    
    
    self.rightTopLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.rightdownLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.rightTopLabel.textColor = [UIColor blackColor];
    self.rightdownLabel.textColor = [UIColor blackColor];
    
    self.leftTopLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftDownLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    self.leftTopLabel.textColor = [UIColor blackColor];
    self.leftDownLabel.textColor = [UIColor blackColor];
    
    _WorkStatue = getOrder;
    //施工中接口
    [self.WorkingdataSource removeAllObjects];
    [self netWorkWorking:getOrder];
    //
    [self.orderTableView reloadData];
}

#pragma 工人抢单列表－施工中
-(void)netWorkWorking:(WorkStute)workstatue
{
    
    NSLog(@"工作中");

    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:[NSString stringWithFormat:@"%d",workstatue] forKey:@"status"];
    
    
    [NetWork postNoParm:YZX_dingdan_gr params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            //已抢单数量
            self.leftLeftDownLabel.text =[NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"yiqiangdan"]];
            //施工中数量
            self.leftDownLabel.text = [NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"shigongzhong"]];
            //已竣工数量
            self.rightdownLabel.text = [NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"yijungong"]];
            
            NSMutableArray *array = [NSMutableArray array];
            array = [DWOrderModel mj_objectArrayWithKeyValuesArray:[[responseObj objectForKey:@"data"] objectForKey:@"list"]];
            [self.WorkingdataSource addObjectsFromArray:array];
            
            [self.orderTableView reloadData];
            
        }
        //[self MJEndRefresh];

    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        //[self MJEndRefresh];
        
    }];

}
//结束刷新
-(void)MJEndRefresh{
    [self.orderTableView.mj_header endRefreshing];
    [self.orderTableView.mj_footer endRefreshing];
}
@end
