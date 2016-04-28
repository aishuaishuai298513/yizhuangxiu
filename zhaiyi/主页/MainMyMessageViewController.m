//
//  MainMyMessageViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMyMessageViewController.h"
#import "MainMyMessageTableViewCell.h"
#import "MainMessageDetailViewController.h"

#import "MyMessageCell.h"

@interface MainMyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong)NSString *ceshi;

@property (nonatomic, assign)CGFloat rowheight;

@property (nonatomic ,assign) int pageIndex;

@end

@implementation MainMyMessageViewController


-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    // Do any additional setup after loading the view.
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:v];
    self.tableView.backgroundColor = huiseColor;
    
    //self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    _pageIndex = 1;
    [self MJRefreachHeader];
    [self MJRefreachFooter];
}

//header
-(void)MJRefreachHeader
{
    //    [self.dataSource removeAllObjects];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netWorkHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.mj_header = header;
}

//footer
-(void)MJRefreachFooter
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pageIndex++;
        [weakSelf netWorkFotter];
        //[weakSelf loadMoreData];
    }];
    
}



-(void)netWorkHeader
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:[NSString stringWithFormat:@"%d",_pageIndex] forKey:@"page"];
    
    [NetWork postNoParm:YZX_wodexiaoxi_gz params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
             self.dataSource = [responseObj objectForKey:@"data"];
            
        }
        //self.dataSource = [responseObj objectForKey:@"data"];
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        if (self.dataSource.count<=0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

-(void)netWorkFotter
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:[NSString stringWithFormat:@"%d",_pageIndex]forKey:@"page"];
    
    [NetWork postNoParm:YZX_wodexiaoxi_gz params:parm success:^(id responseObj) {
        
        //NSLog(@"%@",responseObj);
        NSArray *array;
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            array = [NSArray array];
            array =[responseObj objectForKey:@"data"];
            
            if (array.count>0) {
                
                 [self.dataSource addObjectsFromArray:array];
            }

        }
        //self.dataSource = [responseObj objectForKey:@"data"];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        if (!array.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
  //[self netWork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyMessageCell" owner:nil options:nil]lastObject];
    }
    cell.contentView.backgroundColor = huiseColor;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.time.text = [self.dataSource[indexPath.row]objectForKey:@"createtime"];
    cell.contentLabel.text = [self.dataSource[indexPath.row]objectForKey:@"content"];
    cell.XiaoxiID = [self.dataSource[indexPath.row]objectForKey:@"id"];
    
    self.rowheight = (float)cell.time.y+(float)cell.time.height+20;
    
    __weak __typeof(self)weakSelf = self;
    
    [cell setDelMessageBlock:^{
        [weakSelf netWorkHeader];
    }];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return _rowheight;
    return 220;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    MainMessageDetailViewController * detailVC = [segue destinationViewController];
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    //NSLog(@"%ld",indexPath.section);
    
    NSLog(@"%@",[self.dataSource[indexPath.section] objectForKey:@"news_type"]);
    
    if ([[self.dataSource[indexPath.section] objectForKey:@"news_type"]isEqualToString:@"111"]) {
        
        detailVC.btnName = @"订单详情";
        [detailVC.detailButton setTitle:@"订单详情" forState:UIControlStateNormal];
        
    }else
    {
        detailVC.btnName = @"确定";
        [detailVC.detailButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    detailVC.messageTpy = NO;
    detailVC.noMessageTpy = YES;
    detailVC.dataSource = self.dataSource[indexPath.row];
    NSLog(@"%@",self.dataSource[indexPath.row]);
    
//    if (indexPath.section == 0) {
//       
//        detailVC.btnName = @"订单详情";
//        detailVC.messageTpy = NO;
//        detailVC.noMessageTpy = YES;
//        detailVC.dataSource = self.dataSource[indexPath.row];
//        
//        
//    }else if (indexPath.section == 1){
//        
//         detailVC.btnName = @"确定";
//         detailVC.messageTpy = NO;
//         detailVC.noMessageTpy = YES;
//    }else{
//        
//        
//        detailVC.messageTpy = YES;
//        detailVC.noMessageTpy = NO;
//    }
    
}







@end
