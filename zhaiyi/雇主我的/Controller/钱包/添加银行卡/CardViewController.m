//
//  CardViewController.m
//  zhaiyi
//
//  Created by ass on 16/3/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CardViewController.h"
#import "CardTableViewCell.h"

@interface CardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)int didselectRow;
@property (nonatomic, assign)BOOL ifDidSelectRow;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CardViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SettableVStyle];
     //self.didselectRow = 0;
    [self netWork];
}

//抢单
-(void)netWork
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [NetWork postNoParmForMap:YZX_yinhang params:parm success:^(id responseObj) {
        //NSLog(@"%@",responseObj);
        self.dataSource = [responseObj objectForKey:@"data"];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)SettableVStyle
{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator =NO;
    
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [[UIColor grayColor]CGColor];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*ID = @"cell";
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CardTableViewCell" owner:nil options:nil]lastObject];
    }
    
    if (self.didselectRow != indexPath.row||!self.ifDidSelectRow) {
        cell.cellImageV.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bankName.text = [self.dataSource[indexPath.row] objectForKey:@"yname"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.didselectRow = (int)indexPath.row;
    self.ifDidSelectRow = YES;
    [self.tableView reloadData];
    [self.view removeFromSuperview];
    
    if (_getSlectString) {
        
        _getSlectString(cell.bankName.text,indexPath.row);
    }
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
