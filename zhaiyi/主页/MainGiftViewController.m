//
//  MainGiftViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainGiftViewController.h"
#import "MaingiftViewTableViewCell.h"
@interface MainGiftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *giftMessageTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MainGiftViewController

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
    [self.giftMessageTableView setTableFooterView:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self netWork];
    
}

-(void)netWork
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"user_id"];
    [parm setObject:acount.type forKey:@"type"];
    
    [NetWork postNoParm:libao params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        
        self.dataSource = [responseObj objectForKey:@"data"];
        
        [self.giftMessageTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

     MaingiftViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MaingiftViewTableViewCell1" forIndexPath:indexPath];
    
     NSString *title = [NSString stringWithFormat:@"%@活动价格%d",[self.dataSource[indexPath.row] objectForKey:@"title"],[[self.dataSource[indexPath.row] objectForKey:@"title"] intValue]];
    
     cell.neirong.text = title;
     cell.timelb.text  = [self.dataSource[indexPath.row] objectForKey:@"createtime"];
    
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

@end
