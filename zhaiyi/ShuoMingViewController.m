//
//  BaoZhengJinViewController.m
//  zhaiyi
//
//  Created by ass on 16/4/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShuoMingViewController.h"

@interface ShuoMingViewController()

@end

@implementation ShuoMingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"保证金说明";
    [self network];
    
}

-(void)network
{
    ADAccount *account = [ADAccountTool account];
    
    if (!account) {
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    
    [NetWork postNoParm:YZX_baozhengjinshuoming params:parm success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [self.webView loadHTMLString:[[responseObj objectForKey:@"data"]objectForKey:@"baozhengjin"] baseURL:nil];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
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
