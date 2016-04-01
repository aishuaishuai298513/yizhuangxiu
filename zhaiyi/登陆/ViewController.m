//
//  ViewController.m
//  zhaiyi
//
//  Created by ass on 16/1/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webV = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"协议.html" withExtension:nil];
    NSURLRequest *request =[NSURLRequest requestWithURL:fileUrl];
    
    [webV loadRequest:request];
    
    [self.view addSubview:webV];
    
    self.title = @"注册协议";
    
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

@end
