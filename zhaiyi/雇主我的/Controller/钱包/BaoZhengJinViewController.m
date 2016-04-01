//
//  BaoZhengJinViewController.m
//  zhaiyi
//
//  Created by ass on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaoZhengJinViewController.h"
#import "dataModel.h"
#import "List.h"
#import "BaoZhengJinTableViewCell.h"
@interface BaoZhengJinViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;


@end

@implementation BaoZhengJinViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    [self netWork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)netWork
{
    ADAccount *account = [ADAccountTool account];
    
     NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    
    [NetWork postNoParm:YZX_baozhengjinjilu params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            
            self.dataSource = [dataModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"data"]];
            
//            NSMutableArray *array = [NSMutableArray array];
//            array = @[
//                               @{
//                                   @"month": @"2016年03月",
//                                   @"list": @[
//                                            @{
//                                                @"id": @"2",
//                                                @"kaigongriqi": @"2014-05-10",
//                                                @"ordercode": @"333333",
//                                                @"gzname": @"电工",
//                                                @"adr": @"323432",
//                                                @"renshu": @"1",
//                                                @"baozhengjin": @"2.00",
//                                                @"createtime": @"2016-03-30"
//                                            },
//                                            @{
//                                                @"id": @"1",
//                                                @"kaigongriqi": @"2014-05-10",
//                                                @"ordercode": @"3123123123",
//                                                @"gzname": @"木工",
//                                                @"adr": @"3123123123",
//                                                @"renshu": @"1",
//                                                @"baozhengjin": @"1.00",
//                                                @"createtime": @"2016-03-30"
//                                            }
//                                            ]
//                               },
//                               @{
//                                   @"month": @"2016年02月",
//                                   @"list": @[
//                                            @{
//                                                @"id": @"3",
//                                                @"kaigongriqi": @"2014-05-10",
//                                                @"ordercode": @"3123123",
//                                                @"gzname": @"电工",
//                                                @"adr": @"123123123",
//                                                @"renshu": @"1",
//                                                @"baozhengjin": @"3.00",
//                                                @"createtime": @"2016-02-04"
//                                            }
//                                            ]
//                               }
//                            
//                               ];
    
             self.dataSource = [dataModel mj_objectArrayWithKeyValuesArray:self.dataSource];
            [self.tableView reloadData];
        }else
        {
            [ITTPromptView showMessage:@"网络错误"];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)createUI
{
    self.title = @"保证金纪录";
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.y = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 129;
    _tableView.sectionHeaderHeight = 33;
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    dataModel *dataModel = self.dataSource[section];
    return   dataModel.list.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dataModel *dataModel = self.dataSource[indexPath.section];
    List *list = dataModel.list[indexPath.row];
    NSLog(@"%@",list.kaigongriqi);
    
    BaoZhengJinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BaoZhengJinTableViewCell" owner:nil options:nil]lastObject];
        cell.list = list;

    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    dataModel *dataModel = self.dataSource[section];
    
    return dataModel.month;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    dataModel *dataModel = self.dataSource[section];
    
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 30.0)] ;
    customView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    
    headerLabel.backgroundColor = [UIColor clearColor];
    
    headerLabel.opaque = NO;
    
    headerLabel.textColor = [UIColor lightGrayColor];
    
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 30.0);
    
    headerLabel.text =  dataModel.month;
    [customView addSubview:headerLabel];
    
    
    return customView;    
    
}


@end
