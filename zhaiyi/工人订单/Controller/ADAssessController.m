//
//  ADAssessController.m
//  zhaiyi
//
//  Created by exe on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADAssessController.h"
#import "ADTextView.h"
@interface ADAssessController ()
{
    ADTextView *textView;
    
}
@end

@implementation ADAssessController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setupTextView];
    
}

//创建搜索控件
-(void)setupTextView
{
    //1.初始化textView
    textView = [[ADTextView alloc]init];
    //2.设置frame
    textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2 - 65);
    //3.添加到父控件
    [self.view addSubview:textView];
    //4.添加占位文字
    textView.placeholder = @"请输入您对雇主的评价";
    //5.设置颜色
    textView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1.0];
    //6.设置控制器颜色
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setBackgroundImage:[ UIImage imageNamed:@"提交"]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pingjia) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(5, self.view.frame.size.height/2 + 20, self.view.frame.size.width - 10, 50);
    [self.view addSubview:btn];
}

//评价
-(void)pingjia
{
    
    if (textView.text.length <=0) {
        
        [ITTPromptView showMessage:@"评价内容不能为空"];
        return;
    }
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    [parm setObject:acount.userid forKey:@"user_id"];
    [parm setObject:acount.nickname forKey:@"nickname"];
    //[parm setObject: forKey:@"degree"];
    //[parm setObject:self.OrderModel.ddh forKey:@"order_number"];
    [parm setObject:textView.text forKey:@"content"];
    [parm setObject:acount.type forKey:@"type"];
    [parm setObject:self.OrderModel.ID forKey:@"send_id"];
    
    [NetWork postNoParm:dingdanPingJia params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if([[responseObj objectForKey:@"code"]isEqualToString:@"1000"])
        {
            [ITTPromptView showMessage:@"评价成功"];
            NSArray *ctrArr = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[ctrArr objectAtIndex:1] animated:YES];
            
            //[self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
       
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
