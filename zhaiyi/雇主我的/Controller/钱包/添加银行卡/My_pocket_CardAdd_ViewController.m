//
//  My_pocket_CardAdd_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_CardAdd_ViewController.h"
#import "CardViewController.h"
#import "PureLayout.h"
#import "ZSDPaymentView.h"

#define NUMBERS @"0123456789\n"
@interface My_pocket_CardAdd_ViewController ()
<
UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate
>
{
    UIPickerView *_pickerView;
   // __block CardViewController *cardVC;
    
    UIButton *_bankBtn;
    UITextField *_bankNumTF;
    NSArray *_bankArr;
    NSMutableDictionary *params;
    
    //金额
    UITextField*jine;
    //持卡人
    UITextField*chikaren;
    //卡号
    UITextField*kahao;
    //开户行
    UIButton *kaihuhang;
    
    ADAccount *_account;
}

@property (weak, nonatomic)  UIImageView *triangle;

@property (nonatomic, strong) UIButton *backBtnView;

@property (nonatomic ,strong) __block CardViewController *cardVC;

@property (weak, nonatomic) IBOutlet UIButton *bankName;


@property (nonatomic, strong) NSMutableDictionary *dataSource;

//输入的支付密码
@property (nonatomic, strong) NSString *miMa;

@end

@implementation My_pocket_CardAdd_ViewController

-(CardViewController *)cardVC
{
    if (!_cardVC) {
        _cardVC = [[CardViewController alloc]init];
    }
    return _cardVC;
}

-(NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary dictionary];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.tableView];
    _account = [ADAccountTool account];

    [self initalData];
    [self netWorkInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _account = [ADAccountTool account];
    
   // NSLog(@"username %@",_account.username);
}

-(void)netWorkInfo
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    
    [NetWork postNoParmForMap:YZX_tixianyemian params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            self.dataSource  = [responseObj objectForKey:@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

//设置tableView 的Header  Fotter
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    
    [tableView setTableFooterView:[self createFooterView]];
    
    [tableView setTableHeaderView:[self creatHeaderView]];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellID;
    if (indexPath.row==0) {
        cellID=@"cell0";
    
    }else if (indexPath.row==1)
    {
        cellID=@"cell1";
    }
    else if(indexPath.row == 2)
    {
        cellID=@"cell2";
        
    }else if(indexPath.row == 3)
    {
        cellID=@"cell3";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if ([cellID isEqualToString: @"cell0"]) {
        
        jine = [cell viewWithTag:419];
        //jine.text = [self.dataSource objectForKey:@"yue"];

        jine.placeholder =[NSString stringWithFormat:@"当前帐户可提现金额%@元",[self.dataSource objectForKey:@"yue"]];
    }
    if ([cellID isEqualToString: @"cell1"]) {
        
        chikaren = [cell viewWithTag:420];
        chikaren.text = [self.dataSource objectForKey:@"chikaren"];
    }
    if ([cellID isEqualToString: @"cell2"]) {
        kahao = [cell viewWithTag:421];
        kahao.text = [self.dataSource objectForKey:@"kahao"];
    }
    if ([cellID isEqualToString: @"cell3"]) {
        
        kaihuhang = [cell viewWithTag:422];
        if([[self.dataSource objectForKey:@"kaihuhang"]isEqualToString:@""])
        {
          [kaihuhang setTitle:@"选择银行" forState:UIControlStateNormal];
        }else
        {
         [kaihuhang setTitle:[self.dataSource objectForKey:@"kaihuhang"]  forState:UIControlStateNormal];
        }
    }
    
    
    return cell;
}

-(void)initalData{
    
    self.tableView.scrollEnabled = NO;
    self.title = @"提现";
    
}

#pragma mark 切换银行卡
- (IBAction)YHPicker:(id)sender {
    
         [self.view endEditing:YES];
        //三角旋转
        [self animationForTriangle:(M_PI)];
        //遮盖
        _backBtnView = [[UIButton alloc]initWithFrame:self.view.bounds];
        _backBtnView.backgroundColor = [UIColor clearColor];
        [_backBtnView addTarget:self action:@selector(backViewCkicekd) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_backBtnView];
    
        UIButton *btn = (UIButton *)sender;
        CGRect rect = btn.superview.superview.frame;
        [self addChildViewController:self.cardVC];
        self.cardVC.view.frame  = CGRectMake(16, rect.origin.y+rect.size.height, SCREEN_WIDTH-32, 300);
        [self.tableView addSubview:self.cardVC.view];
    
    
    //获取选择银行信息  银行卡没点击
   __weak typeof (self)Weakself = self;
    self.cardVC.getSlectString = ^(NSString *bankName,NSInteger cardID){
        
        //移除弹框
        [Weakself.backBtnView removeFromSuperview];
        //旋转动画
        [Weakself animationForTriangle:(0)];
        
        //[Weakself.bankName setTitle:bankName forState:UIControlStateNormal];
        
        [btn setTitle:bankName forState:UIControlStateNormal];
        
    };
    
}
#pragma mark 点击透明遮盖移除
-(void)backViewCkicekd
{
    //移除弹框
    [self.backBtnView removeFromSuperview];
    [self.cardVC.view removeFromSuperview];
    //旋转动画
    [self animationForTriangle:(0)];
}

#pragma mark  卡号输入出发事件
- (IBAction)bankNumTF:(UITextField *)sender {
    NSLog(@"sender %@",sender.text);
    _bankNumTF = sender;
    _bankNumTF.delegate = self;
    if (sender.text.length == 19||sender.text.length == 16) {
        NSLog(@"银行卡 %@",sender.text);
       // [params setObject:sender.text forKey:@"bank_number"];
    } else {
        
    }
    
}
#pragma mark 限制输入卡号
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//限制输入的内容
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}

#pragma mark 三角形旋转动画
-(void)animationForTriangle :(CGFloat)Angle
{
    self.triangle = [self.tableView viewWithTag:423];
    CGAffineTransform  transform = CGAffineTransformMakeRotation(Angle);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.triangle.transform = transform;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 设置HeaderView
-(UIView *)creatHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kU, 38)];
    view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 9, kU-20, 20)];
    label.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"请绑定持卡人本人的银行卡";
    [view addSubview:label];
    return view;
}
#pragma mark  设置FooterView
-(UIView *)createFooterView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kU, 100)];
    UIButton *nextBtn = [[UIButton alloc]init];
    [view addSubview:nextBtn];
    [nextBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nextBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [nextBtn autoSetDimension:ALDimensionWidth toSize:200];
    [nextBtn autoSetDimension:ALDimensionHeight toSize:40];
    
    nextBtn.backgroundColor = THEME_COLOR;
    nextBtn.layer.cornerRadius = 20;
    nextBtn.clipsToBounds = YES;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

#pragma mark 添加完成 下一步
-(void)clickFinish{
    
    if ([kaihuhang.titleLabel.text isEqualToString:@"选择银行"]) {
        [ITTPromptView showMessage:@"请选择银行"];
    }
    if ([jine.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入金额"];
    }
    if ([kahao.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入卡号"];
    }
    if ([chikaren.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入持卡人姓名"];
    }
    
    
    NSLog(@"btn标题 %@",_bankBtn.titleLabel.text);
    if (kahao.text.length !=19||kahao.text.length != 16 ) {
        [ITTPromptView showMessage:@"输入卡号有误"];
    }
    
    
    //支付框
    ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
    
    __weak typeof (self)weakSelf = self;
    
    payment.getText =  ^int(NSString *textInput){
        
        NSLog(@"密码%@",textInput);
        weakSelf.miMa = textInput;
        //提现
        [weakSelf postData];
        
        //代表成功
        return 1;
    };
    payment.title = @"请输入支付密码";
    payment.goodsName = @"余额提现";
    payment.amount = [jine.text floatValue];
    [payment show];
}
#pragma mark 请求提现
-(void)postData{
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:_account.userid forKey:@"userid"];
    [parm setObject:_account.token forKey:@"token"];
    [parm setObject:jine forKey:@"jine"];
    [parm setObject:chikaren forKey:@"chikaren"];
    [parm setObject:kahao forKey:@"kahao"];
    [parm setObject:kaihuhang forKey:@"kaihuhang"];
    [parm setObject:self.miMa forKey:@"zhifumima"];
    
    
    [NetWork postNoParm:YZX_tixian params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
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


-(void)resignTheFirstResponser{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTap:)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)cancelTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    _pickerView.hidden = YES;
}



@end
