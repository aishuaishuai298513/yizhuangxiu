//
//  CancelViewController.m
//  zhaiyi
//
//  Created by exe on 15/12/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CancelViewController.h"
#import "ADTextView.h"
@interface CancelViewController ()

@property (nonatomic, strong)ADTextView *textView;
@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextView];
}
//创建搜索控件
-(void)setupTextView
{
    //1.初始化textView
    _textView = [[ADTextView alloc]init];
    //2.设置frame
    _textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2 - 65);
    //3.添加到父控件
    [self.view addSubview:_textView];
    //4.添加占位文字
    _textView.placeholder = @"请输入您取消订单的原因，方便我们核实，谢谢配合";
    //5.设置颜色
    _textView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    //6.设置控制器颜色
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setBackgroundImage:[ UIImage imageNamed:@"提交"]forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, self.view.frame.size.height/2 + 20, ScreenW-20, 50);
    
    //取消订单
    [btn addTarget:self action:@selector(TiJiao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.title = @"取消原因";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)TiJiao
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"user_id"];
    [parm setObject:self.OrderModel.ID forKey:@"order_id"];
    [parm setObject:_textView.text forKey:@"content"];
    
    [NetWork postNoParm:gongRenQuxiaoDingDan params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
