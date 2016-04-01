//
//  AccessController.m
//  zhaiyi
//
//  Created by exe on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AccessController.h"
#import "RightAccessViewCell.h"
#import "RithtViewController.h"
#import "workerOrderViewController.h"
@interface AccessController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//右侧按钮点击
- (IBAction)rightBtnClick:(id)sender;
//左边按钮点击
- (IBAction)leftBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightDownLabel;


@end

@implementation AccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightTopLabel.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(203/255.0) blue:(181/255.0) alpha:1.0];
self.rightDownLabel.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(203/255.0) blue:(181/255.0) alpha:1.0];
}

#pragma mark---数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"access";
    RightAccessViewCell *access = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!access) {
        access = [RightAccessViewCell rightCell];
    }
    return access;
}
#pragma mark---代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RithtViewController *right = [[RithtViewController alloc]init];
    [self.navigationController pushViewController:right animated:NO];
}

//在按钮的点击事件中，把左边的按钮颜色变成默认灰色。
- (IBAction)rightBtnClick:(id)sender {
   
    
}
//点击左边按钮的时候，pop回原来的控制器
- (IBAction)leftBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    workerOrderViewController *work = [[workerOrderViewController alloc]init];
    
}
@end
