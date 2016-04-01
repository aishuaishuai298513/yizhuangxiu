//
//  EvaluateViewController.m
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "EvaluateViewController.h"
#import "EvaluateCell.h"
#import "MJExtension.h"
#import "PureLayout.h"

@interface EvaluateViewController ()<CellDelete>
{
    //姓名 工种  头像
    UILabel *namelabel;
    UILabel *typeWorkLabel;
    UIImageView *headImageV;
}
@property (nonatomic, weak) UIButton *rightBtn;
@end

@implementation EvaluateViewController

-(NSArray *)UserDataSource
{
    if (_UserDataSource == nil) {
        _UserDataSource = [NSMutableArray alloc];
        _UserDataSource = @[@"工作态度:",@"工做能力:",@"工作效率:",@"团队合作"];
        
    }
    return _UserDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"评价"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluateCell" bundle:nil] forCellReuseIdentifier:@"EvaluateCell"];
    //[self configueRightBarItem];
    //评价工人列表
    //[self netWork];
    //[self AddTap];
    // UIView *V = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView  setTableHeaderView:[self createHeaderView]];
    [self.tableView setTableFooterView:[self createFooterView]];
    self.tableView.scrollEnabled = NO;
}

#pragma mark 创建HeaderView内容
-(UIView *)createHeaderView
{
    UIView *HeaderbackV  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    //添加姓名label
    namelabel = [[UILabel alloc]initForAutoLayout];
    namelabel.text = @"邓君";
    namelabel.textColor = [UIColor redColor];
    namelabel.font = [UIFont systemFontOfSize:15];
    //添加工种label
    typeWorkLabel = [[UILabel alloc]initForAutoLayout];
    typeWorkLabel.text =@"木工";
    typeWorkLabel.textColor = [UIColor redColor];
    typeWorkLabel.font = [UIFont systemFontOfSize:14];
    //添加头像
    headImageV = [[UIImageView alloc]initForAutoLayout];
    headImageV.image = [UIImage imageNamed:@"订单详情2"];
    
    
    [HeaderbackV addSubview:namelabel];
    [HeaderbackV addSubview:typeWorkLabel];
    [HeaderbackV addSubview:headImageV];
    
    //添加约束
    //namelabel
    [namelabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:HeaderbackV withOffset:8];
    [namelabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:HeaderbackV];
    //typelabel
    [typeWorkLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:HeaderbackV];
    [typeWorkLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:namelabel withOffset:8];
    //headImageV
    [headImageV autoAlignAxis:ALAxisHorizontal toSameAxisOfView:HeaderbackV];
    [headImageV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:HeaderbackV withOffset:-8];
    [headImageV autoSetDimension:ALDimensionWidth toSize:25];
    [headImageV autoSetDimension:ALDimensionHeight toSize:25];
    
    return HeaderbackV;
}

#pragma mark 创建FotterView
-(UIView *)createFooterView
{
    UIView *FooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    UIButton *makeSureBtn = [[UIButton alloc]initForAutoLayout];
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makeSureBtn setBackgroundColor:THEME_COLOR];
    makeSureBtn.layer.cornerRadius = 20;
    makeSureBtn.clipsToBounds = YES;
    [FooterView addSubview:makeSureBtn];
    
    //约束
    [makeSureBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:FooterView];
    [makeSureBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:FooterView withOffset:30];
    [makeSureBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:FooterView withOffset:-30];
    [makeSureBtn autoSetDimension:ALDimensionHeight toSize:40];
    
    return FooterView;
}
//- (void)configueRightBarItem{
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 26)];
//    self.rightBtn = rightBtn;
//    [rightBtn setTitle:@"一键好评" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(goodEvaluate) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"订单详情1.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = barBtnItem;
//}


////一键好评
//- (void)goodEvaluate{
//
//    ADAccount *acount = [ADAccountTool account];
//    
//    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//    [parm setObject:acount.userid forKey:@"user_id"];
//    [parm setObject:self.OrderModel.ID forKey:@"send_id"];
//    [parm setObject:@"5" forKey:@"degree"];
//    [parm setObject:self.OrderModel.ddh forKey:@"order_number"];
//    [parm setObject:@"好好好" forKey:@"content"];
//    
//   // NSLog(@"%@",yiJianPingjia);
//    [NetWork postNoParm:yiJianPingjia params:parm success:^(id responseObj) {
//        
//        NSLog(@"%@",responseObj);
//        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
//            [ITTPromptView showMessage:@"评价成功"];
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
//    
//    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"一键好评.png"] forState:UIControlStateNormal];
//    self.rightBtn.userInteractionEnabled = NO;
//    
//    
//    
//}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.UserDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateCell" forIndexPath:indexPath];
    
    cell.delegate =self;
    cell.zongtifuwu.text = self.UserDataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.UserAcount = self.UserDataSource[indexPath.row];
//    cell.OrderModel = self.OrderModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

//评价工人列表
//-(void)netWork
//{
//
//    [self.UserDataSource removeAllObjects];
//    ADAccount *acount = [ADAccountTool account];
//    
//    NSMutableDictionary *parm = [NSMutableDictionary  dictionary];
//    
//    [parm setObject:acount.userid forKey:@"user_id"];
//    [parm setObject:self.OrderModel.ID forKey:@"send_id"];
//    // NSLog(@"%@",parm);
//    
//    // NSLog(@"%@",self.OrderModel.ID );
//    [NetWork postNoParm:yijungongGongRenLb params:parm success:^(id responseObj) {
//        
//       // NSLog(@"%@",responseObj);
//        self.UserDataSource = [ADAccount mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"data"]];
//       // NSLog(@"%ld",self.UserDataSource.count);
//        
//        [self.tableView reloadData];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"123");
    [self.view endEditing:YES];
}

//添加手势
-(void)AddTap
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    
    [self.tableView addGestureRecognizer:tapGesture];
}

//收回键盘
-(void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

#pragma mark cellDelegte  删除
 -(void)cellDeleteClicked:(id)Target
{
//   NSIndexPath *indexPath = [self.tableView indexPathForCell:Target];
//   // NSLog(@"%d",indexPath.row);
//    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//    
//    ADAccount *acount = self.UserDataSource[indexPath.row];
//   [parm setObject:acount.pinjia_id forKey:@"assess_id"];
//    
//    NSLog(@"%@",parm);
//    
//    [NetWork postNoParm:shanchuPingjia params:parm success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        
//        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
//            
//            [ITTPromptView showMessage:@"删除成功"];
//            [self netWork];
//            
//        }else
//        {
//            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@" ");
//    }];
}
@end
