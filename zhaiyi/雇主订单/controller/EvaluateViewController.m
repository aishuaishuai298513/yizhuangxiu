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

@interface EvaluateViewController ()<CellXingClicked>
{
    //姓名 工种  头像
    UILabel *namelabel;
    UILabel *typeWorkLabel;
    UIImageView *headImageV;
}
@property (nonatomic, weak) UIButton *rightBtn;

@property (nonatomic, assign)int xingji;

//
@property (nonatomic ,strong)NSString *gongZuoTaiDu;
@property (nonatomic ,strong)NSString *gongZuoNengLi;
@property (nonatomic ,strong)NSString *gongZuoXiaoLv;
@property (nonatomic ,strong)NSString *tuanDuiHeZuo;
@end

@implementation EvaluateViewController

-(NSArray *)UserDataSource
{
    if (_UserDataSource == nil) {
        _UserDataSource = [NSMutableArray alloc];
        //工人评价
        if (_TypeFrom == 1) {
            
           _UserDataSource = @[@"按时结算:",@"福利待遇:",@"信用客户:",@"处事公正:"];
        }else
        {
           _UserDataSource = @[@"工作态度:",@"工做能力:",@"工作效率:",@"团队合作"];
        }
        
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
    namelabel.text = self.UserInfoM.name;
    namelabel.textColor = [UIColor redColor];
    namelabel.font = [UIFont systemFontOfSize:15];
    //添加工种label
    typeWorkLabel = [[UILabel alloc]initForAutoLayout];
    typeWorkLabel.text =self.UserInfoM.gzname;
    typeWorkLabel.textColor = [UIColor redColor];
    typeWorkLabel.font = [UIFont systemFontOfSize:14];
    
    //添加头像
    headImageV = [[UIImageView alloc]initForAutoLayout];
    [headImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,self.UserInfoM.headpic]]];
    
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
    
    [makeSureBtn addTarget:self action:@selector(pingjia) forControlEvents:UIControlEventTouchUpInside];
    
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



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.UserDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateCell" forIndexPath:indexPath];
    cell.row = (int)indexPath.row;
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

#pragma mark 评价
-(void)pingjia
{
    //评价雇主
    if (_TypeFrom == 1) {
        
        [self pinjiaGz];
        return;
    }
    
    
    ADAccount *account = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:self.UserInfoM.userid forKey:@"userid2"];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    [parm setObject:self.gongZuoTaiDu forKey:@"gongzuotaidu"];
    [parm setObject:self.gongZuoNengLi forKey:@"gongzuonengli"];
    [parm setObject:self.gongZuoXiaoLv forKey:@"gongzuoxiaolv"];
    [parm setObject:self.tuanDuiHeZuo forKey:@"tuanduihezuo"];
    [parm setObject:self.UserInfoM.ID forKey:@"orderid"];

    NSLog(@"%@",parm);
    
    [NetWork postNoParm:YZX_pingjiagongren params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            pop
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 评价雇主
-(void)pinjiaGz
{
    ADAccount *account = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:self.OrderModel.userid forKey:@"userid2"];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    [parm setObject:self.gongZuoTaiDu forKey:@"anshijiesuan"];
    [parm setObject:self.gongZuoNengLi forKey:@"fulidaiyu"];
    [parm setObject:self.gongZuoXiaoLv forKey:@"xinyongkehu"];
    [parm setObject:self.tuanDuiHeZuo forKey:@"chushigongzheng"];
    [parm setObject:self.OrderModel.ID forKey:@"orderid"];
    
    NSLog(@"%@",parm);
    
    [NetWork postNoParm:YZX_pingjiaguzhu params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            pop
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark Delegate
-(void)cellXingClicked:(int)xingJi row:(int)Row
{
    if (Row == 0) {
        self.gongZuoTaiDu = [NSString stringWithFormat:@"%d",xingJi];
        NSLog(@"%@",self.gongZuoTaiDu);
    }else if (Row == 1)
    {
        self.gongZuoNengLi = [NSString stringWithFormat:@"%d",xingJi];
        NSLog(@"%@",self.gongZuoNengLi);
    }else if (Row == 2)
    {
        self.gongZuoXiaoLv = [NSString stringWithFormat:@"%d",xingJi];
        NSLog(@"%@",self.gongZuoXiaoLv);
    }else if (Row == 3)
    {
        self.tuanDuiHeZuo = [NSString stringWithFormat:@"%d",xingJi];
        NSLog(@"%@",self.tuanDuiHeZuo);
    }
}


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

@end
