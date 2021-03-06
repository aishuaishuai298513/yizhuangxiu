//
//  My_pocket_Card_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_Card_ViewController.h"

@interface My_pocket_Card_ViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableDictionary *params;
    NSArray *_bankArr;
    ADAccount *_account;
    UITableView *tv;
    
}
@end

@implementation My_pocket_Card_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"添加银行卡");
    [self initalData];
    
}
-(void)initalData{
    self.title = @"银行卡";
    params = [NSMutableDictionary dictionary];
    tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, kU, Ga)];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    UIView *footV = [UIView new];
    [tv setTableFooterView:footV];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _bankArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"bank_list_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
    NSDictionary *dict = [_bankArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(140, 12, kU - 110, 20)];
    NSString *bankNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"num"]];
    [cell.contentView addSubview:lb];
    NSRange range = NSMakeRange(7, 8);
    lb.text = [bankNum stringByReplacingCharactersInRange:range withString:@"********"];
    lb.font = [UIFont systemFontOfSize:14];
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//网络数据请求
-(void)postData{
    _account = [ADAccountTool account];
    [params setObject:_account.userid forKey:@"user_id"];
//    [params setObject:_account.type forKey:@"type"];
    
    NSLog(@"上传信息; %@  %@",params,_account.type);
    [NetWork postNoParm:POST_BANK_LIST params:params success:^(id responseObj) {
        NSLog(@"银行卡列表%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            
           _bankArr = [responseObj objectForKey:@"data"];
            [tv reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}



@end
