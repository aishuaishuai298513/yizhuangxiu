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
#import "jieSuanView.h"

#import "DWOrderModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "PureLayout.h"

#import "DetatilViewController.h"
typedef enum
{
    getOrder = 1,//以抢单
    working = 2,//施工中
    worked = 3 //已竣工
    
}WorkStute;


@interface workerOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

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
//@property (nonatomic, strong) NSMutableArray *WorkedDataSource;
//@property (nonatomic, strong) NSMutableArray *getOrderDataSource;
@property (nonatomic, assign) int PageIndex;

@property (nonatomic, assign) NSInteger WorkStatue;

//点击事件
- (IBAction)leftBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;
- (IBAction)leftleftBtnClicked:(id)sender;

//遮盖View
@property (nonatomic, strong) UIView *backView;
//结算View
@property (nonatomic, strong) jieSuanView *jiesuanView;

@property (nonatomic, strong) NSString *jiesuanOrderID;
@end

@implementation workerOrderViewController
//懒加载
-(NSMutableArray *)WorkingdataSource{
    if (!_WorkingdataSource) {
        _WorkingdataSource = [NSMutableArray array];
    }
    return  _WorkingdataSource;
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
    
    if (_WorkStatue ==getOrder) {
       [self leftleftBtnClicked:nil];
    }else if (_WorkStatue == working)
    {
        [self leftBtnClick:nil];
    }else if (_WorkStatue == worked)
    {
        [self rightBtnClick:nil];
    }else
    {
       [self leftleftBtnClicked:nil];
    }
}

//下拉刷新
//-(void)MJRefreshPullRefresh{
//     NSLog(@"下拉刷新");
//    
//    __weak typeof(self) weakSelf = self;
//    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _PageIndex = 1;
//        if (_WorkStatue == working) {
//            
//            [weakSelf.WorkingdataSource removeAllObjects];
//            //[weakSelf netWorkWorking];
//        }
//        if (_WorkStatue == worked)
//        {
//            [weakSelf.WorkingdataSource removeAllObjects];
//            //[weakSelf netWorkWorked];
//        }
//        if (_WorkStatue == getOrder) {
//            //需要修改
//            [weakSelf.WorkingdataSource removeAllObjects];
//            //[weakSelf netWorkWorking];
//        }
//        
//    }];
//}

//上拉加载
//-(void)MJRefreshLoadMore{
//    NSLog(@"上拉加载");
//    __weak typeof(self) weakSelf = self;
//    self.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        _PageIndex++;
//
//        if (_WorkStatue == working) {
//            //[weakSelf netWorkWorking];
//        }
//        else if(_WorkStatue == worked){
//            //[weakSelf netWorkWorked];
//        }else
//        {
//        }
//    }];
//}


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
    
    __weak typeof (self)WeakSelf =self;
    //施工中
    if (_WorkStatue == working) {
     
        static NSString *ID = @"order";
        ADOrderViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!orderCell) {
            orderCell = [ADOrderViewCell cell];
        }
        if (_WorkingdataSource.count != 0) {
            orderCell.workStue = working;
            orderCell.OrderModel = self.WorkingdataSource[indexPath.row];
            //block  结算
            orderCell.jisuanOrder = ^(DWOrderModel *orderModel){
                
                [WeakSelf netWorJieSuan:orderModel];
            };
            
            orderCell.queRenShouKuan = ^(NSDictionary *response)
            {
                if ([[response objectForKey:@"result"]isEqualToString:@"1"]) {
                    [ITTPromptView showMessage:[response objectForKey:@"message"]];
                    [WeakSelf netWorkWorking:working];
                }else
                {
                   [ITTPromptView showMessage:[response objectForKey:@"message"]];
                }
            };
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
        
        if (_WorkingdataSource.count != 0) {
            access.workStue = worked;
            access.OrderModel = self.WorkingdataSource[indexPath.row];
            access.shanchuOrder =^(NSDictionary *resopnse)
            {
                //刷新
                [WeakSelf netWorkWorking:worked];

            };
        }
        [access setNeedsUpdateConstraints];
        
        return access;
    }
    //已抢单
    else
    {
        static NSString *ID = @"order";
        ADOrderViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!orderCell) {
            orderCell = [ADOrderViewCell cell];
        }
        if (_WorkingdataSource.count != 0) {
            orderCell.workStue = getOrder;
            orderCell.OrderModel = self.WorkingdataSource[indexPath.row];
            
            //block 取消订单
            orderCell.cancleOrder = ^(NSDictionary *response){
                if ([[response objectForKey:@"result"]isEqualToString:@"1"]) {
                    [ITTPromptView showMessage:[response objectForKey:@"message"]];
                    //刷新
                    [WeakSelf netWorkWorking:getOrder];
                }
            };
            
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
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"workerRob" bundle:nil];
    DetatilViewController *detaiController = [stroyboard instantiateViewControllerWithIdentifier:@"qiangdanxiangqing"];
    
    DWOrderModel *model = self.WorkingdataSource[indexPath.row];
    detaiController.orderId = model.orderid;
    detaiController.orderModel = model;
    //NSLog(@"%@",model.ID);

    if (_WorkStatue == working) {
        
        detaiController.statue = 2;
        [self.navigationController pushViewController:detaiController animated:YES];
    }
    else if(_WorkStatue == worked)
    {
        detaiController.statue = 3;
        [self.navigationController pushViewController:detaiController animated:YES];

    }else
    {
        detaiController.statue = 1;
        [self.navigationController pushViewController:detaiController animated:YES];
    }
}

// 清理订单标记
-(void)quxiaoBiaoji{
    [Function qingLingDiangDan_gongRen];
    
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhiTuBiao" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)leftBtnClick:(id)sender {
    
    //取消标记
    [self quxiaoBiaoji];
    
    _WorkStatue = working;
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

    
    //施工中接口
   // [self.WorkingdataSource removeAllObjects];
    [self netWorkWorking:working];
//
    [self.orderTableView reloadData];
  }

- (IBAction)rightBtnClick:(id)sender {
    
    _WorkStatue = worked;
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
    
    //已竣工列表
    //[self.WorkingdataSource removeAllObjects];
    [self netWorkWorking:worked];
    
//    [self.orderTableView reloadData];
    
//    AccessController *access = [[AccessController alloc]init];
//    [self.navigationController pushViewController:access animated:NO];
}

- (IBAction)leftleftBtnClicked:(id)sender {
    
    _WorkStatue = getOrder;
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
    //[self.WorkingdataSource removeAllObjects];
    [self netWorkWorking:getOrder];
    //
    [self.orderTableView reloadData];
}

#pragma 工人抢单列表－施工中
-(void)netWorkWorking:(WorkStute)workstatue
{
    [self.WorkingdataSource removeAllObjects];
    
    NSLog(@"工作中");

    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:[NSString stringWithFormat:@"%d",workstatue] forKey:@"status"];
    
    NSLog(@"%@",parm);
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
#pragma mark 结算页面
-(void)netWorJieSuan:(DWOrderModel *)orderModel
{
    _jiesuanView = [jieSuanView LoadView];
    
    __weak typeof (self)weakSelf = self;
    [_jiesuanView jieSuan:orderModel jiesuansucess:^(NSDictionary *response) {
        //NSLog(@"%@",response);
        [weakSelf  netWorkWorking:working];
        
    } JieSuanFaluse:^(NSDictionary *response) {
        
    }];
    
    
}

////结束刷新
//-(void)MJEndRefresh{
//    [self.orderTableView.mj_header endRefreshing];
//    [self.orderTableView.mj_footer endRefreshing];
//}

@end
