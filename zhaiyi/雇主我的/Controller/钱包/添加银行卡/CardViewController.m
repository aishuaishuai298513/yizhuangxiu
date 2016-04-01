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
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SettableVStyle];
     self.didselectRow = 0;
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
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*ID = @"cell";
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CardTableViewCell" owner:nil options:nil]lastObject];
    }
    
    if (self.didselectRow != indexPath.row) {
        cell.cellImageV.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.didselectRow = (int)indexPath.row;
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
