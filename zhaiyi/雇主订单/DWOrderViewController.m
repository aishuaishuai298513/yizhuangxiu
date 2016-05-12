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

#import "CancleTiXing.h"
#import "CancleTiXing2.h"

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

@property (nonatomic,assign) CGFloat rowHeit;

//取消订单
@property (nonatomic, strong)CancleTiXing *tixingView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSIndexPath *indexPath;

//不能发单提醒
@property (nonatomic, strong)CancleTiXing2 *tixingView2;

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
    
    self.publishLabel.font = [UIFont systemFontSizeWithScreen:17];
    self.view1Num.font = [UIFont systemFontSizeWithScreen:17];
    
    self.constructionLabel.font = [UIFont systemFontSizeWithScreen:17];
    self.view2num.font = [UIFont systemFontSizeWithScreen:17];
    
    self.complede.font = [UIFont systemFontSizeWithScreen:17];
    self.viewNum3.font = [UIFont systemFontSizeWithScreen:17];
    
    if(iOS8)
    {
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }else
    {
        self.tableView.rowHeight = 100;
    }
    
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
    
    
    __weak typeof (self)Wealself = self;
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
        cell.zhuangTai.text = @"(正在施工中)";

    }
    //已竣工
    else if(self.type == 3){
        
        cell.confirmBtn.hidden = YES;
        cell.deleteBtn.hidden = NO;
        
        //预计天数
        cell.yujitianshu.hidden = YES;
        
        cell.zhuangTai.text = @"已竣工";
        
        cell.zhuangTai.textColor = [UIColor lightGrayColor];
        
        [cell.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        
        //cell.evaluateBtn.hidden = NO;
        //    //删除    回调
        [cell setDeleteBlock:^(UIButton *deleteBtn) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除订单？" message:nil preferredStyle:1];
            
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
        
        cell.zhuangTai.text = @"(正在招人)";
        
        [cell.deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
        [cell setDeleteBlock:^(UIButton *deleteBtn) {
            
            _indexPath = indexPath;
            [Wealself numOfCancleorder];
            
        }];
    }
    
        DWOrderModel *MOdel = self.dataSource[indexPath.row];
        cell.MOdel =MOdel;
    return cell;
}

-(void)numOfCancleorder
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    
    __weak typeof (self)WeakSelf = self;
    
    
   [NetWork postNoParm:YZX_shifouquxiao params:parm success:^(id responseObj) {
        
        NSLog(@" %@",responseObj);
       
        //第二次取消
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [WeakSelf popCancleTiShiView:[responseObj objectForKey:@"message"]];
         
            //第一次取消
        }else if([[responseObj objectForKey:@"result"]isEqualToString:@"0"])
        {
            [WeakSelf popCancleTiShiView:nil];
        }else
        {
            [self makeSureClicked];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ITTPromptView showMessage:@"网络错误"];
    }];
}

#pragma makr 弹出取消提示框

-(void)popCancleTiShiView:(NSString *)Message
{
    _tixingView = [CancleTiXing LoadView];
    //grabOrderV.frame = CGRectMake(50, 200, SCREEN_WIDTH -100, SCREEN_WIDTH -100);
    _tixingView.frame = CGRectMake((SCREEN_WIDTH-270)/2, 200, 270, 217);
    
    if(Message)
    {
       _tixingView.concentL.text = Message;
    }
    
    [_tixingView YesBtnAddTarget:self action:@selector(makeSureClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_tixingView NoBtnAddTarget:self action:@selector(NoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _backView = [Function createBackView:self action:@selector(backViewClicked)];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_backView];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_tixingView];
}

#pragma mark 确定取消订单
-(void)makeSureClicked
{
    [_backView removeFromSuperview];
    [_tixingView removeFromSuperview];
   [self quXiaoNetWork:_indexPath];
    
}
-(void)NoBtnClicked
{
    [_backView removeFromSuperview];
    [_tixingView removeFromSuperview];
}

-(void)backViewClicked
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld", self.dataSource.count);
    
    return self.dataSource.count;
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
    
    [NetWork postNoParm:YZX_shanchudingdan_gz params:parm success:^(id responseObj) {
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

#pragma mark 取消我的订单

-(void)quXiaoNetWork:(NSIndexPath *)indexpath
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
#pragma mark 不能发单提醒取消
-(void)quxiao
{
    [_tixingView2 removeFromSuperview];
    [_backView removeFromSuperview];

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
