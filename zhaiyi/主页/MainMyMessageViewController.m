//
//  MainMyMessageViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMyMessageViewController.h"
#import "MainMyMessageTableViewCell.h"
#import "MainMessageDetailViewController.h"
@interface MainMyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MainMyMessageViewController


-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    // Do any additional setup after loading the view.
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:v];
    
    //self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}


-(void)netWork
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"user_id"];
    
    [NetWork postNoParm:wodexiaoxi params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        self.dataSource = [responseObj objectForKey:@"data"];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
  [self netWork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainMyMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MainMyMessageTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    cell.time.text = [self.dataSource[indexPath.section]objectForKey:@"updatetime"];
    cell.neirong.text = [self.dataSource[indexPath.section]objectForKey:@"news_content"];
    
//    cell.contentView.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.3 alpha:1]CGColor];
//    cell.contentView.layer.borderWidth = 1;
//    
//    cell.contentView.layer.cornerRadius = 5;
//    cell.contentView.clipsToBounds = YES;
    
   // NSLog(@"%@",self.dataSource);
    //NSLog(@"%@",self.dataSource[indexPath.section]);
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    MainMessageDetailViewController * detailVC = [segue destinationViewController];
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    //NSLog(@"%ld",indexPath.section);
    
    NSLog(@"%@",[self.dataSource[indexPath.section] objectForKey:@"news_type"]);
    
    if ([[self.dataSource[indexPath.section] objectForKey:@"news_type"]isEqualToString:@"111"]) {
        
        detailVC.btnName = @"订单详情";
        [detailVC.detailButton setTitle:@"订单详情" forState:UIControlStateNormal];
        
    }else
    {
        detailVC.btnName = @"确定";
        [detailVC.detailButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    detailVC.messageTpy = NO;
    detailVC.noMessageTpy = YES;
    detailVC.dataSource = self.dataSource[indexPath.row];
    NSLog(@"%@",self.dataSource[indexPath.row]);
    
//    if (indexPath.section == 0) {
//       
//        detailVC.btnName = @"订单详情";
//        detailVC.messageTpy = NO;
//        detailVC.noMessageTpy = YES;
//        detailVC.dataSource = self.dataSource[indexPath.row];
//        
//        
//    }else if (indexPath.section == 1){
//        
//         detailVC.btnName = @"确定";
//         detailVC.messageTpy = NO;
//         detailVC.noMessageTpy = YES;
//    }else{
//        
//        
//        detailVC.messageTpy = YES;
//        detailVC.noMessageTpy = NO;
//    }
    
}







@end
