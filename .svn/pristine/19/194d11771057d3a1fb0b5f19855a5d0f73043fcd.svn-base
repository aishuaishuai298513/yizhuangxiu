//
//  DWConfirmCheckViewController.m
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWConfirmCheckViewController.h"
#import "EvaluateViewController.h"

@interface DWConfirmCheckViewController ()
- (IBAction)evaluateAcion:(UIButton *)sender;

@end

@implementation DWConfirmCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)evaluateAcion:(UIButton *)sender {
    
    EvaluateViewController *vc = [[EvaluateViewController alloc] initWithNibName:@"EvaluateViewController" bundle:nil];
    vc.TypeFrom = 1;
    vc.UserDataSource = self.UserDataSource;
    vc.OrderModel = self.Ordermodel;

    [self.navigationController pushViewController:vc animated:YES];
}
@end
