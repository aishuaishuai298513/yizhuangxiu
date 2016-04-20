//
//  DWOrderViewController.m
//  zhaiyi
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWOrderViewController.h"
#import "DWOrderCell.h"
#import "DWOrderDetailTableViewController.h"
#import "EvaluateViewController.h"
#import "DWOrderModel.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

@interface DWOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;


//发布中
@property (weak, nonatomic) IBOutlet UILabel *view1Num;
//施工中
@property (weak, nonatomic) IBOutlet UILabel *view2num;
//已竣工
@property (weak, nonatomic) IBOutlet UILabel *viewNum3;

//发布
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
//施工中
@property (weak, nonatomic) IBOutlet UILabel *constructionLabel;
//已竣工
@property (weak, nonatomic) IBOutlet UILabel *complede;

//页码
@property (nonatomic, assign) int pageIndex;

@property (nonatomic, assign) int type;

//订单列表
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DWOrderViewController

//订单列表
 -(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = 1;
    //页码
    _pageIndex = 1;

    [self.navigationItem setTitle:@"订单"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"DWOrderCell" bundle:nil] forCellReuseIdentifier:@"DWOrderCell"];
    UITapGestureRecognizer *t1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap1:)];
    [self.view1 addGestureRecognizer:t1];
    
    UITapGestureRecognizer *t2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap2:)];
    [self.view2 addGestureRecognizer:t2];
    
    UITapGestureRecognizer *t3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap3:)];
    [self.view3 addGestureRecognizer:t3];
    [self singleTap1:self.view1];
    
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self MJRefreshPullRefresh];
//    [self MJRefreshLoadMore];
//    [self.tableView.mj_header beginRefreshing];
    [self netWork];
}


#pragma mark 加载刷新

-(void)MJRefreshPullRefresh{
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
            [weakSelf.dataSource removeAllObjects];
            [weakSelf netWork];
    }];
    
    
}
-(void)MJRefreshLoadMore{
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageIndex ++;
        [weakSelf netWork];
    }];
    
}

//结束刷新
-(void)MJEndRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark  我发布的订单
-(void)netWork
{
    [self.dataSource removeAllObjects];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    ADAccount *acount = [ADAccountTool account];
    NSLog(@"%@",acount.userid);
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    
    //4：发布中。5.施工中，6.已竣工
    if (self.type == 2 ) {
        [parm setObject:@"5" forKey:@"status"];
    }else if (self.type == 3)
    {
        [parm setObject:@"6" forKey:@"status"];
    }else
    {
        [parm setObject:@"4" forKey:@"status"];
    }
    
//    NSString *pageIndexStr = [NSString stringWithFormat:@"%d",_pageIndex];
//    NSLog(@"页码 %d",_pageIndex);
//    [parm setObject:pageIndexStr forKey:@"pageindex"];
    
    __weak typeof (self)weakSelf = self;
    
    [NetWork postNoParmForMap:YZX_dingdanlist params:parm success:^(id responseObj) {
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",responseObj);
        
        if ([[responseObj objectForKey:@"result"] isEqualToString:@"1"]) {
        //NSMutableArray *array = [NSMutableArray array];
        self.dataSource = [DWOrderModel mj_objectArrayWithKeyValuesArray:[[responseObj objectForKey:@"data"] objectForKey:@"list"]];
            
            NSLog(@"%@",self.dataSource);
            
            //订单数量
            weakSelf.view1Num.text = [NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"fabuzhong"]];;
            weakSelf.view2num.text = [NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"]objectForKey:@"shigongzhong"]];
            weakSelf.viewNum3.text = [NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"yijungong"]];
            
            [self.tableView reloadData];

        }
        //[self MJEndRefresh];

    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
       // [self MJEndRefresh];
        
    }];
    
}

//发布中按钮
- (void)singleTap1:(UIView *)myView{
    
    [self SetHeadViewsColor:self.view1 viewNum:self.view1Num workStute:self.publishLabel type:1 pageIndex:1];
    
}

//施工中按钮
- (void)singleTap2:(UIView *)myView{
    
  [self SetHeadViewsColor:self.view2 viewNum:self.view2num workStute:self.constructionLabel type:2 pageIndex:1];
}

//已竣工列表
- (void)singleTap3:(UIView *)myView{
   
    [self SetHeadViewsColor:self.view3 viewNum:self.viewNum3 workStute:self.complede type:3 pageIndex:1];
}
//设置颜色 请求网络等
-(void)SetHeadViewsColor :(UIView *)view viewNum :(UILabel *)viewNum workStute:(UILabel *)workStute type:(int)type pageIndex:(int)pageIndex
{
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.view2.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    self.view1Num.textColor = [UIColor grayColor];
    self.view2num.textColor = [UIColor grayColor];
    self.viewNum3.textColor = [UIColor grayColor];
    
    self.publishLabel.textColor = [UIColor grayColor];
    self.constructionLabel.textColor = [UIColor grayColor];
    self.complede.textColor = [UIColor grayColor];

    view.backgroundColor = THEME_COLOR;
    viewNum.textColor = [UIColor whiteColor];
    workStute.textColor = [UIColor whiteColor];
    
    self.type = type;
    _pageIndex = pageIndex;
    
    [self.dataSource removeAllObjects];
    //我发布的订单
    [self netWork];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    DWOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWOrderCell"];
    DWOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWOrderCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DWOrderCell" owner:nil options:nil]firstObject];
    }
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //施工中
    if (self.type == 2) {
        //[cell.confirmBtn setTitle:@"确认验收" forState:UIControlStateNormal];
        //[cell.confirmBtn addTarget:self action:@selector(queRenZhaoYong:) forControlEvents:UIControlEventTouchUpInside];
        cell.confirmBtn.hidden= YES;
        cell.confirmBtn.tag = indexPath.row;
        
        cell.confirmBtn.hidden = NO;
        cell.deleteBtn.hidden = YES;
        //预计天数
        cell.yujitianshu.hidden = YES;

    }
    //已竣工
    else if(self.type == 3){
        cell.confirmBtn.hidden = YES;
        cell.deleteBtn.hidden = NO;
        
        //预计天数
        cell.yujitianshu.hidden = YES;
        //cell.evaluateBtn.hidden = NO;
        
    }
    //发布中
    else{
        cell.confirmBtn.hidden= YES;
        //[cell.confirmBtn setTitle:@"确认招用" forState:UIControlStateNormal];
        //[cell.confirmBtn addTarget:self action:@selector(queRenZhaoYong:) forControlEvents:UIControlEventTouchUpInside];
        cell.confirmBtn.tag = indexPath.row;
        cell.confirmBtn.hidden = NO;
        cell.deleteBtn.hidden = NO;
        
        //预计天数
        cell.yujitianshu.hidden = NO;
        //结算数
        cell.jiesuanshuBtn.hidden = YES;
    }
    
    
//    //删除    回调
    [cell setDeleteBlock:^(UIButton *deleteBtn) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定取消订单？" message:nil preferredStyle:1];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //删除订单
            [self shanchuNetWork:indexPath];
            NSLog(@"123");
        }];

        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

    }];
//
//    //评价
//    [cell setEvaluateBlock:^(UIButton *evaluateBtn) {
//        
//         DWOrderModel *OrderMOdel = self.dataSource[indexPath.row];
//        //
//        EvaluateViewController *vc = [[EvaluateViewController alloc] initWithNibName:@"EvaluateViewController" bundle:nil];
//        vc.OrderModel = OrderMOdel;
//        
//        NSLog(@"%@",vc.OrderModel);
//        
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }];
    
    
        DWOrderModel *MOdel = self.dataSource[indexPath.row];
        cell.MOdel =MOdel;
   // cell.userInteractionEnabled = YES;

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld", self.dataSource.count);
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DWOrderModel *MOdel = self.dataSource[indexPath.row];
    
    DWOrderDetailTableViewController *vc = [[DWOrderDetailTableViewController alloc] initWithNibName:@"DWOrderDetailTableViewController" bundle:nil];
    vc.type = self.type;
    NSLog(@"%d",self.type);
    vc.OrderID = MOdel.ID;
    //vc.OrderModel = MOdel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"123");
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}


//删除我的订单
-(void)shanchuNetWork:(NSIndexPath *)indexpath
{
    
    ADAccount *acount = [ADAccountTool account];
    
    DWOrderModel *MOdel = self.dataSource[indexpath.row];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:MOdel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_quxiaodingdan_gz params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            
            [self netWork];
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  控制点击施工中
-(void)setPushWorking:(BOOL)pushWorking
{
    _pushWorking = pushWorking;
    if (pushWorking) {
        [self singleTap2:nil];
    }
}


@end
