//
//  MyResignViewController.m
//  zhaiyi
//
//  Created by ass on 16/1/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyResignViewController.h"
//注册
#import "ViewController.h"
#import "APService.h"

@interface MyResignViewController ()<UITextFieldDelegate>

@property (nonatomic,assign)BOOL IsZhuCeXieYi;

@property (weak, nonatomic) IBOutlet UITextField *telPhone;
@property (weak, nonatomic) IBOutlet UITextField *yzmNum;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (nonatomic,assign) BOOL isGhuZhu;


@property (weak, nonatomic) IBOutlet UIImageView *xieYiBtn;

@property (nonatomic, strong)UITextField *TextFiled;

//线
@property (weak, nonatomic) IBOutlet UIView *guZhuLine;

@property (weak, nonatomic) IBOutlet UIView *gongRenLine;



- (IBAction)guZhuBtn:(id)sender;

- (IBAction)gongRenBtn:(id)sender;


- (IBAction)getYzmbtn:(id)sender;


- (IBAction)ReginBtn:(id)sender;


- (IBAction)ZhuCeXieYi:(id)sender;

@end

@implementation MyResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"注册";
    self.isGhuZhu = YES;
    
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"left红" selectedImage:@"left" target:self action:@selector(back)];
    
    self.xieYiBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(XieYiBtnClicked)];
    
    [self.xieYiBtn addGestureRecognizer:tap];
    
    //注册协议
    self.IsZhuCeXieYi = YES;
    
    //注销第一响应
    [self resignTheFirstResponser];
    
    self.telPhone.delegate = self;
    self.yzmNum.delegate = self;
    self.passWord.delegate = self;
    
}

-(void)XieYiBtnClicked
{
    _IsZhuCeXieYi = !_IsZhuCeXieYi;
    if (self.IsZhuCeXieYi) {
        self.xieYiBtn.image = [UIImage imageNamed:@"check-1"];
    }else
    {
        self.xieYiBtn.image = [UIImage imageNamed:@"矩形-1"];
    }
    
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取验证码
- (IBAction)getYzmbtn:(id)sender {
    
    NSString *mobil = self.telPhone.text;
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
    
}

#pragma mark 注册
- (IBAction)ReginBtn:(id)sender {
    
    if (!_IsZhuCeXieYi) {
        
        [ITTPromptView showMessage:@"请同意注册协议"];
        
        return;
    }
    
        NSString *userName = self.telPhone.text;
        NSString *PassWord = self.passWord.text;
        NSString *yzmtext = self.yzmNum.text;
        NSMutableDictionary *parms = [NSMutableDictionary dictionary];
        [parms setObject:userName forKey:@"mobile"];
        [parms setObject:PassWord forKey:@"password"];
        [parms setObject:yzmtext forKey:@"code"];
        //经纬度 极光推送码
        [parms setObject:@"" forKey:@"lng"];
        [parms setObject:@"" forKey:@"lat"];
        [parms setObject:[APService registrationID] forKey:@"jiguangcode"];
    
    NSLog(@"%@",parms);
    [NetWork postNoParm:YZX_resign params:parms success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
          [ITTPromptView showMessage:@"注册失败"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}

//注册协议
- (IBAction)ZhuCeXieYi:(id)sender {
    //注册协议
    ViewController *zhuCe = [[ViewController alloc]init];
    [self.navigationController pushViewController:zhuCe animated:YES];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"123");
    for (UITextField *textF in self.view.subviews) {
        [textF resignFirstResponder];
    }
    
   // [self resignFirstResponder];
}

//注销第一事件
-(void)resignTheFirstResponser{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancel:)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapCancel:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    _TextFiled = textField;
    
    //监听键盘
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"123");
}

-(void)keyboardShow:(NSNotification *)note
{
    
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.origin.y;

    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        if ((deltaY-_TextFiled.y-_TextFiled.height)<0) {
            self.view.y = deltaY-(_TextFiled.y+_TextFiled.height);
        }
    }];

    
}

-(void)keyboardHide:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.origin.y;
    
    // CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        //
    }];
}
@end
