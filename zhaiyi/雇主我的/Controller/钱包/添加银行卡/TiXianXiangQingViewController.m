//
//  TiXianDetailViewController.m
//  zhaiyi
//
//  Created by ass on 16/5/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TiXianXiangQingViewController.h"

@interface TiXianXiangQingViewController ()

@end

@implementation TiXianXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现详情";
    // Do any additional setup after loading the view from its nib.
    
    //截取
    NSString *WeiHao = [_cardNum substringFromIndex:_cardNum.length-4];
    self.BackOrCardNumL.text = [NSString stringWithFormat:@"%@    尾号%@",_bank,WeiHao];
    self.MoneyL.text = [NSString stringWithFormat:@"¥ %@",_Money];
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
