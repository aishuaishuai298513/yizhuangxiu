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

@interface MyResignViewController ()

@property (nonatomic,assign)BOOL IsZhuCeXieYi;

@property (weak, nonatomic) IBOutlet UITextField *telPhone;
@property (weak, nonatomic) IBOutlet UITextField *yzmNum;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (nonatomic,assign) BOOL isGhuZhu;


@property (weak, nonatomic) IBOutlet UIImageView *xieYiBtn;

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
    
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"left" selectedImage:@"left" target:self action:@selector(back)];
    
    self.xieYiBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(XieYiBtnClicked)];
    
    [self.xieYiBtn addGestureRecognizer:tap];
    
    //注册协议
    self.IsZhuCeXieYi = YES;
    
}

-(void)XieYiBtnClicked
{
    _IsZhuCeXieYi = !_IsZhuCeXieYi;
    if (self.IsZhuCeXieYi) {
        self.xieYiBtn.image = [UIImage imageNamed:@"找工人5"];
    }else
    {
        self.xieYiBtn.image = [UIImage imageNamed:@"找工人4"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)guZhuBtn:(id)sender {
//    
//    self.isGhuZhu = YES;
//    self.guZhuLine.alpha = 1;
//    self.gongRenLine.alpha = 0.1;
//}
//
//- (IBAction)gongRenBtn:(id)sender {
//    
//    self.isGhuZhu = NO;
//    self.guZhuLine.alpha = 0.1;
//    self.gongRenLine.alpha = 1;
//}
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
@end
