//
//  workerRobViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "workerRobViewController.h"
#import "QiangDanTableViewCell.h"
#import "DetatilViewController.h"
#import "DWOrderModel.h"
#import "MJRefresh.h"

@interface workerRobViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,assign) int pageIndex;

- (IBAction)QiangBtnClicked:(id)sender;

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation workerRobViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self MJRefreachHeader];
    [self MJRefreachFooter];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //抢单列表
   // [self netWorkQiangDan];
    // Do any additional setup after loading the view.
    
//    [self MJRefreachHeader];
//    [self MJRefreachFooter];
    
    self.title =@"订单列表";
    
}


//header
-(void)MJRefreachHeader
{
//    [self.dataSource removeAllObjects];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netWorkQiangDanHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.mj_header = header;
    
    //[self netWorkQiangDanHeader];
    
    
}

//footer
-(void)MJRefreachFooter
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
        //_pageIndex++;
        [weakSelf netWorkQiangDanFooter];
        //[weakSelf loadMoreData];
    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString  *CellIdentiferId = @"cell";
    QiangDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];

    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"QiangDanTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    };
    
    cell.indexPath = indexPath;
    
    [cell setQiangBlock:^(NSIndexPath *indexpath) {
        
        //跳到抢单详情页
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"workerRob" bundle:nil];
        DetatilViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"qiangdanxiangqing"];
        
        DWOrderModel *OrderModel = self.dataSource[indexPath.row];
        test2obj.orderId = OrderModel.ID;
        
        [self.navigationController pushViewController:test2obj animated:YES];
        

    }];
    
    if (_dataSource.count != 0) {
        cell.cellModel= self.dataSource[indexPath.row];
    }
    
    cell.height = 143;
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//工人端|工人端查看雇主下单列表  抢单列表
-(void)netWorkQiangDanHeader
{
    [self.dataSource removeAllObjects];
    _pageIndex = 1;

   ADAccount *acount = [ADAccountTool account];
   NSString *lon = [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"];
   NSString *lat =  [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:[NSString stringWithFormat:@"%d",_pageIndex] forKey:@"page"];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:lon forKey:@"lng"];
    [parm setObject:lat forKey:@"lat"];
    
    //[parm setObject:@"1" forKey:@"pageindex"];
     //NSLog(@"%@",parm);
    
    //84已发布
    [NetWork postNoParm:YZX_orderlist params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"] isEqualToString:@"1"]) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            array = [DWOrderModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"data"]];
            
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        NSLog(@"%@",error);
    }];

}


-(void)netWorkQiangDanFooter
{
    _pageIndex++;
    
    ADAccount *acount = [ADAccountTool account];
    NSLog(@"%@",acount.userid);
    
    NSString *lon = [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"];
    NSString *lat =  [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:[NSString stringWithFormat:@"%d",_pageIndex] forKey:@"page"];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:lon forKey:@"lng"];
    [parm setObject:lat forKey:@"lat"];

    
    //84已发布
    //[parm setObject:@"84" forKey:@"status"];
    
    NSLog(@"%d",_pageIndex);
    
    [NetWork postNoParm:YZX_orderlist params:parm success:^(id responseObj) {
        
        NSLog(@"工人抢单: %@",responseObj);
        
        if ([[responseObj objectForKey:@"result"] isEqualToString:@"1"]) {
            
            NSMutableArray *array = [NSMutableArray array];
            array = [DWOrderModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"data"]];
            
            if (array.count <=0) {
                _pageIndex--;
            }
            
            NSLog(@"%ld",array.count);
            
            [self.dataSource addObjectsFromArray:array];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            //[self.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        //[self.tableView.mj_header endRefreshing];
        NSLog(@"%@",error);
        _pageIndex--;
    }];
    
}


@end
