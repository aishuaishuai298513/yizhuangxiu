//
//  My_pocket_jiaoyijiluDetil_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_jiaoyijiluDetil_ViewController.h"
#import "TradeRecordModel.h"

@interface My_pocket_jiaoyijiluDetil_ViewController ()
{
    NSDictionary *detailDict;
}
@end

@implementation My_pocket_jiaoyijiluDetil_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setExtraCellLineHidden:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"交易详情号 %@",_orderNum);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    detailDict = [userDefaults objectForKey:@"pocket_tade_detail"];
    
    NSLog(@"交易详情号 %@",detailDict);
    
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellID;
    if (indexPath.row==0) {
        cellID=@"cell1";
    }else
    {
        cellID=@"cell2";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    UILabel *moneyLb = [cell viewWithTag:410];
    UILabel *goodsLb = [cell viewWithTag:411];
    UILabel *statusLb = [cell viewWithTag:412];
    UILabel *createtimeLb = [cell viewWithTag:413];
    UILabel *updatetimeLb = [cell viewWithTag:414];
    UILabel *bankNameLb = [cell viewWithTag:415];
    UILabel *orderNumLb = [cell viewWithTag:416];

    NSString *status = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"status"]];
    if ([status isEqualToString:@"107"]) {
        statusLb.text = @"提现申请已提交";;
    }
    if ([status isEqualToString:@"108"]) {
        statusLb.text = @"提现申请已完成";
    }
    
    TradeRecordModel *model = [[TradeRecordModel alloc]init];
    [model setValuesForKeysWithDictionary:detailDict];
    NSRange range = NSMakeRange(16, 3);
//    bankNameLb.text = [NSString stringWithFormat:@"%@(%@)",model.bank_name,[model.bank_number substringWithRange:range]];
//    moneyLb.text = model.carry_cash;
//    goodsLb.text = model.goods_type;
//    createtimeLb.text = model.createtime;
//    updatetimeLb.text = model.updatetime;
//    orderNumLb.text = model.order_number;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 50;
    }else
    {
        return 250;
    }
}



-(void)getPostData{
    
    
    
}


@end
