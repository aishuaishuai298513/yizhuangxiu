//
//  ADFinishController.m
//  zhaiyi
//
//  Created by exe on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADFinishController.h"
#import "ADAssessController.h"
@interface ADFinishController ()
//跳到评价控制器
- (IBAction)AccessClick:(id)sender;

//上部文字
@property (weak, nonatomic) IBOutlet UILabel *topText;

//下部文字
@property (weak, nonatomic) IBOutlet UILabel *bottomText;

@end

@implementation ADFinishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"评价";
}

//跳到评价控制器
- (IBAction)AccessClick:(id)sender {
    ADAssessController *access = [[ADAssessController alloc]init];
    access.OrderModel = self.OrderModel;
    [self.navigationController pushViewController:access animated:YES];
}
@end
