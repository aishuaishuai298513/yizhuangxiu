//
//  DWevaluateListViewController.m
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWevaluateListViewController.h"
#import "DWEvaluateListCell.h"

@interface DWevaluateListViewController ()

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation DWevaluateListViewController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DWEvaluateListCell" bundle:nil] forCellReuseIdentifier:@"DWEvaluateListCell"];
    [self.navigationItem setTitle:@"评价列表"];
    [self netWork];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWEvaluateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWEvaluateListCell" forIndexPath:indexPath];
    cell.dataSource = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void)netWork
{
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    ADAccount *acount  = [ADAccountTool account];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.userid forKey:@"userid2"];
    
    [NetWork postNoParm:YZX_pingjialiebiao_gr params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            self.dataSource = [responseObj objectForKey:@"data"];
            [self.tableView reloadData];
        }
        
        //self.dataSource = [responseObj objectForKey:@"data"];
        
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
@end
