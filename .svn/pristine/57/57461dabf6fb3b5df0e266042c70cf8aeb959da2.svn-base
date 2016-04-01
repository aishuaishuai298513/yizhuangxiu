//
//  My_jidanshezhi_Controller.m
//  zhaiyi
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_jidanshezhi_Controller.h"

@interface My_jidanshezhi_Controller ()
{
    NSInteger currentIndex;
}
@end

@implementation My_jidanshezhi_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initalData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    currentIndex = 2;
    //状态 0 接单  1 休息  2 忙碌
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    currentIndex = [[userD objectForKey:@"order_status"] integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self judgeCurrentStatus];
}

-(void)initalData{
    
    self.title=@"接单设置";
    UIView *footerV = [[UIView alloc]init];
    [self.tableView setTableFooterView:footerV];

    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (!cell) {
        cell=[[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray * arr=@[@"接单",@"休息",@"忙碌"];
    cell.textLabel.text=arr[indexPath.row];
   
    
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==currentIndex){
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==currentIndex){
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex
                                                   inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    currentIndex=indexPath.row;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSString stringWithFormat:@"%d",currentIndex] forKey:@"order_status"];
    [user synchronize];
}


#pragma mark 根据当前状态做处理
-(void)judgeCurrentStatus{
    
    switch (currentIndex) {
        case 0:{
         //接单
            
            NSLog(@"接单中....");
            
        }
            break;
        case 1:{
            //休息
            
            NSLog(@"休息中....");

            
        }
            break;
        case 2:{
            //忙碌
            
            NSLog(@"忙碌中....");

            
        }
            break;
            
        default:
            break;
    }
    
    
    
}

@end
