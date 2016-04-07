//
//  DWEmployerDetailController.m
//  zhaiyi
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWEmployerDetailController.h"
#import "DWEmployerDetailCell.h"
#import "DWReasionViewController.h"
#import "DWevaluateListViewController.h"

@interface DWEmployerDetailController ()
@property (strong, nonatomic) IBOutlet UIView *dwHeaderView;

@property (strong, nonatomic) IBOutlet UIView *dwFooterView;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (nonatomic, strong) NSMutableDictionary *dataSource;
- (IBAction)quitBtnAction:(UIButton *)sender;
@end

@implementation DWEmployerDetailController

-(NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary dictionary];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.acount.username];
    self.tableView.tableHeaderView = self.dwHeaderView;
    self.tableView.tableFooterView = self.dwFooterView;
    [self.tableView registerNib:[UINib nibWithNibName:@"DWEmployerDetailCell" bundle:nil] forCellReuseIdentifier:@"DWEmployerDetailCell"];
    
    self.quitBtn.layer.cornerRadius = 20;
    self.quitBtn.layer.masksToBounds = YES;
    [self configueRightBarItem];
    
    if (self.type == 1) {
        self.tableView.tableFooterView.hidden = NO;
    }
    if (self.type == 3) {
        self.tableView.tableFooterView.hidden = YES;
    }
    if (self.type == 2) {
        self.tableView.tableFooterView.hidden = NO;
    }
    
    
    [self netWorkUserinfo];
    
    
    
  //NSLog(@"%@",self.acount.userid);
}

-(void)netWorkUserinfo
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.orderModel.userid forKey:@"userid2"];
    
    [NetWork postNoParm:YZX_cituipage params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            self.dataSource = [responseObj objectForKey:@"data"];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

//评价列表
- (void)evaluateList{
    
    DWevaluateListViewController *vc = [[DWevaluateListViewController alloc] initWithNibName:@"DWevaluateListViewController" bundle:nil];
    vc.userAcount = self.acount;
   // NSLog(@"%@",vc.userAcount.userid);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configueRightBarItem{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(evaluateList) forControlEvents:UIControlEventTouchUpInside];

    [rightBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWEmployerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWEmployerDetailCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.DWEmpilyerDetailLabelLeft.text = @"姓名";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"name"];
    }else if (indexPath.row == 1){
        cell.DWEmpilyerDetailLabelLeft.text = @"性别";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"sex"];
        
    }else if(indexPath.row == 2){
        cell.DWEmpilyerDetailLabelLeft.text = @"工种";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"gzname"];
    }else if(indexPath.row == 3){
        cell.DWEmpilyerDetailLabelLeft.text = @"工龄";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"gongling"];
    }else if(indexPath.row == 4){
        cell.DWEmpilyerDetailLabelLeft.text = @"学历";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"xueli"];
    }else if(indexPath.row == 5){
        cell.DWEmpilyerDetailLabelLeft.text = @"户籍";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"huji"];
    }else if(indexPath.row == 6){
        cell.DWEmpilyerDetailLabelLeft.text = @"自我评价";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"ziwojieshao"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (IBAction)quitBtnAction:(UIButton *)sender {
    
    //辞退原因
    DWReasionViewController *vc = [[DWReasionViewController alloc] initWithNibName:@"DWReasionViewController" bundle:nil];
    
    NSLog(@"%@",self.acount.userid);
    
    vc.UserAcount = self.acount;
    
    vc.OrderModel = self.orderModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
