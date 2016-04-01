//
//  MyForgetPwdController.m
//  zhaiyi
//
//  Created by cajan on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyForgetPwdController.h"
#import "My_Login_In_ViewController.h"

@interface MyForgetPwdController ()
<
UITextFieldDelegate
>
{
    
    ADAccount *_account;
    
    BOOL _isSend;
    
    CGRect orignalFrame;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation MyForgetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initalData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initalData{
    
    orignalFrame = _pwdTF.frame;
    self.title = @"忘记密码";
    _account = [ADAccountTool account];
    _phoneTF.text = @"111";
    _pwdTF.delegate = self;
   

}



#pragma mark 获取验证码
- (IBAction)codeBtn:(UIButton *)sender {
    
    [self askForCode];
}
//动态时间按钮
-(void)timeStatusBtn{
    __block NSInteger seconds = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        if (seconds <= 0) {
            //倒计时结束
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                _codeBtn.enabled = YES;
            });
            
            
        } else {
            
            NSString *timeStr = [NSString stringWithFormat:@"%ld秒后重新获取",seconds];
            //--
//            if (_isSend) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_codeBtn setTitle:timeStr forState:UIControlStateNormal];
                    _codeBtn.enabled = NO;
                });
                seconds--;
//            }
            //--
        }
    });
    
    dispatch_resume(timer);
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)enterAndLoginBtn:(UIButton *)sender {
    
    //判断几个输入框都不为空
    if ([_pwdTF.text isEqualToString:@""] || [_phoneTF.text isEqualToString:@""] || [_codeTF.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"内容不能为空"];
    }else {
        [self postData];
    }

    
}
#pragma mark 请求验证码
-(void)askForCode{
    //--
    if ([_phoneTF.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"手机号不能为空"];
    } else {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneTF.text forKey:@"mobile"];
    
    [NetWork postNoParm:YZX_sendCode params:params success:^(id responseObj) {
        
        [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
           // NSLog(@"发送成功");
          [self timeStatusBtn];
        }
        
    } failure:^(NSError *error) {
        
    }];
    }
    // --
    
}

#pragma mark 修改完成并登陆
-(void)postData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneTF.text forKey:@"mobile"];
    [params setObject:_codeTF.text forKey:@"code"];
    [params setObject:_pwdTF.text forKey:@"newpassword"];

    [NetWork postNoParm:YZX_repassword params:params success:^(id responseObj) {
        NSLog(@"修改密码信息 %@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [ITTPromptView showMessage:@"密码修改成功,请重新登录"];
            //跳转到登录页面
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ITTPromptView showMessage:@"密码修改失败"];
        }
        
    } failure:^(NSError *error) {
        
    }];
    

}

-(void)keyBoardWillShow:(NSNotification *)notify{
    
     NSTimeInterval time=[[notify.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    //获得键盘升起的高度
    float height=[[notify.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
    [UIView animateWithDuration:time animations:^{

        _pwdTF.frame = CGRectMake(orignalFrame.origin.x, Ga - height -orignalFrame.size.height, orignalFrame.size.width, orignalFrame.size.height);
        
        [self.view layoutIfNeeded];
    }];
    
    

    
}

-(void)keyBoardWillHidden:(NSNotification *)notify{
    
    NSTimeInterval time=[[notify.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
 
    [UIView animateWithDuration:time animations:^{
        
        _pwdTF.frame = orignalFrame;
        
        [self.view layoutIfNeeded];
    }];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
