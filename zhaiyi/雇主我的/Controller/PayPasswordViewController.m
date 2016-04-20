//
//  PayPasswordViewController.m
//  zhaiyi
//
//  Created by ass on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PayPasswordViewController.h"

@interface PayPasswordViewController ()
- (IBAction)getCode:(id)sender;

- (IBAction)makeSureBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UIView *YzmView;

@property (nonatomic, strong)ADAccount *account;

@end

@implementation PayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self createBtnImage];
    [self createBtn];
    _account = [ADAccountTool account];
    
}

//设置图片
-(void)createBtn
{
    self.maekSurebtn.backgroundColor = THEME_COLOR;
    self.maekSurebtn.layer.cornerRadius = 20;
    self.maekSurebtn.clipsToBounds = YES;
    
    [self notofictionKeyBoard];
    
}

-(void)notofictionKeyBoard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
}
//键盘弹出
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSNumber *duration = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    if(SCREEN_HEIGHT - (self.YzmView.height+self.YzmView.y)<=keyBoardFrame.size.height)
    {
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            CGFloat h = SCREEN_HEIGHT-keyBoardFrame.size.height-self.YzmView.height;
            self.view.y = -(self.YzmView.height+self.YzmView.y-keyBoardFrame.origin.y);
        }];
    }
}

//键盘隐藏
-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    NSNumber *duration = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        self.view.y =0;
    }];
    
}

- (IBAction)getCode:(id)sender {
    
    NSString *mobil = _account.mobile;
    NSLog(@"%@",mobil);
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:mobil forKey:@"mobile"];
    [NetWork postNoParm:YZX_sendCode params:parm success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [ITTPromptView showMessage:@"验证码已发送，请注意查收"];
        }else
        {
            [ITTPromptView showMessage:@"发送失败,请重试"];
        }
        
    } failure:^(NSError *error) {
        
    }];

    
    [ITTPromptView showMessage:@"获取验证码"];
    
}

- (IBAction)makeSureBtnClicked:(id)sender {
    if ([self.password.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入密码"];
        return;
    }
    if (![self.repeatPassword.text isEqualToString:self.password.text]) {
        [ITTPromptView showMessage:@"两次密码输入不一致"];
        return;
    }
    if ([self.code.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入验证码"];
        return;
    }
    //修改支付密码
    
    NSMutableDictionary  *parm = [NSMutableDictionary dictionary];
    [parm setObject:_account.userid forKey:@"userid"];
    [parm setObject:_account.token forKey:@"token"];
    [parm setObject:self.password.text forKey:@"zhifumima"];
    [parm setObject:self.code.text forKey:@"code"];
    NSLog(@"%@",parm);
    [NetWork postNoParm:YZX_UpdatePassword params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [ITTPromptView showMessage:@"密码设置成功"];
            pop
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];

    
}
#pragma mark 显示样式
-(void)setPayController:(PayController)payController
{
    _payController = payController;
    if (_payController == setPassword) {
        self.headerLabel.text = @"请设置您的支付密码";
        self.title = @"支付密码";
    }else if (_payController == updatePassword){
        self.headerLabel.text = @"请修改您的支付密码";
        self.title = @"修改支付密码";
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
