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
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWEvaluateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWEvaluateListCell" forIndexPath:indexPath];
    cell.dataSource = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void)netWork
{
    
//    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//    [parm setObject:self.userAcount.ID forKey:@"user_id"];
//    
//    [NetWork postNoParm:pingjiaLieBiao params:parm success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
//            
//            self.dataSource = [responseObj objectForKey:@"data"];
//            [self.tableView reloadData];
//        }
//        
//        //self.dataSource = [responseObj objectForKey:@"data"];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"");
//    }];
}
@end
