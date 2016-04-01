//
//  AboutXiaoMuJiangController.m
//  zhaiyi
//
//  Created by cajan on 16/1/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AboutXiaoMuJiangController.h"
#import "SVProgressHUD.h"

@interface AboutXiaoMuJiangController ()
<
UIWebViewDelegate
>
{
    UIWebView *_webView;
    NSDictionary *_dataDict;
}
@end



@implementation AboutXiaoMuJiangController

-(NSDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSDictionary dictionary];
    }
    return _dataDict;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于小木匠";
    self.view.backgroundColor = [UIColor whiteColor];

    [self initalData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self postData];
}
-(void)initalData{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kU, Ga)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //设置 webview 字体大小
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '260%'";
    //
    [_webView stringByEvaluatingJavaScriptFromString:str];
    
    [SVProgressHUD dismiss];
}

#pragma mark 请求数据
-(void)postData{
    
    [NetWork postNoParm:POST_ABOUT_XMJ params:nil success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            _dataDict = [responseObj objectForKey:@"data"];
            [self loadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)loadData{
    
    NSLog(@"111 %@",_dataDict);
    
 
    
    NSString *content = [_dataDict objectForKey:@"content"];
    
    [_webView loadHTMLString:content baseURL:nil];
}


@end
