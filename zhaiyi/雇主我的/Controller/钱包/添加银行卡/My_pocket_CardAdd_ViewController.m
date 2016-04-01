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
    
    ADAccount *_account;
}

@property (weak, nonatomic)  UIImageView *triangle;

@property (nonatomic, strong) UIButton *backBtnView;

@property (nonatomic ,strong) __block CardViewController *cardVC;

@end

@implementation My_pocket_CardAdd_ViewController

-(CardViewController *)cardVC
{
    if (!_cardVC) {
        _cardVC = [[CardViewController alloc]init];
    }
    return _cardVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.tableView];
    _account = [ADAccountTool account];

    [self initalData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _account = [ADAccountTool account];
    
   // NSLog(@"username %@",_account.username);
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
    
    UILabel *label = [cell viewWithTag:420];
    if ([_account.type isEqualToString:@"78"]) {
        label.text = _account.userid;
        [params setObject:_account.userid forKey:@"username"];
    } else {
        label.text = _account.userid;
        [params setObject:_account.userid forKey:@"username"];
    }
    return cell;
}

-(void)initalData{
    
    self.tableView.scrollEnabled = NO;
    self.title = @"提现";
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"右上角按钮"] forState:UIControlStateNormal];
//    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightButton addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.frame = CGRectMake(0, 0, 84, 30);
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark 切换银行卡
- (IBAction)YHPicker:(id)sender {
    
         [self.view endEditing:YES];
        //三角旋转
        [self animationForTriangle:(M_PI)];
        
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
        
        NSLog(@"%@",bankName);
        NSLog(@"%ld",cardID);
        
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
        [params setObject:sender.text forKey:@"bank_number"];
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
    self.triangle = [self.tableView viewWithTag:421];
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
    
    //支付框
    ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
    payment.getText =  ^int(NSString *textInput){
        
        NSLog(@"密码%@",textInput);
        
        return 1;
    };
    payment.title = @"请输入支付密码";
    payment.goodsName = @"商品名称";
    payment.amount = 20.00f;
    [payment show];
    
    
    NSLog(@"btn标题 %@",_bankBtn.titleLabel.text);
    if (_bankNumTF.text.length ==19||_bankNumTF.text.length == 16 ) {
        [self postData];

    } else {
        NSLog(@"kakakaa %ld",_bankNumTF.text.length);

        [ITTPromptView showMessage:@"您输入的银行卡号有误"];
    }
}
//请求数据
-(void)postData{
    

    [params setObject:_account.userid forKey:@"user_id"];
    
    if (_bankBtn.titleLabel.text == nil) {
        [params setObject:_bankArr[0] forKey:@"bank_name"];
    }else {
    [params setObject:_bankBtn.titleLabel.text forKey:@"bank_name"];
    }
 
    NSLog(@"添加银行卡 请求数据%@",params);
    [NetWork postNoParm:POST_ADD_BANKCARD params:params success:^(id responseObj) {
       
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [ITTPromptView showMessage:responseObj[@"message"]];
         NSLog(@"添加银行卡: %@",responseObj);
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
