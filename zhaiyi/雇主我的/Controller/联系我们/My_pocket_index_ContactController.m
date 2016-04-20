//
//  My_pocket_index_ContactController.m
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_index_ContactController.h"
#import "ContactheadView.h"
#import "contactMeButton.h"
#import "AboutXiaoMuJiangController.h"

static NSString *tel = @"400－876－6263";
@interface My_pocket_index_ContactController ()
{
    ContactheadView *headView;
}

@property (nonatomic, strong)NSMutableDictionary *dataSource;

@end

@implementation My_pocket_index_ContactController

-(NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary dictionary];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.tableView.alpha = 0;
    //让tableview的头部为加载的那个xib
    //NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
 
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createTableView];
    [self netWork];
}

#pragma mark 创建tableView
-(void)createTableView
{

    
    headView = [ContactheadView loadheadView];
    //headView.contactLb.text = [NSString stringWithFormat:@"小木匠 V%@",versionStr];
    headView.bounds = CGRectMake(0, 0, kU, 280);
    self.tableView.tableHeaderView = headView;
    self.tableView.rowHeight = 80;
    UIView *footView = [UIView new];
    self.tableView.tableFooterView = footView;

}

#pragma mark  请求数据
-(void)netWork
{
    ADAccount *account =[ ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    
    [NetWork postNoParm:YZX_lianxiwomen params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            self.dataSource = [responseObj objectForKey:@"data"];
            [self.tableView reloadData];
             headView.dataSource = self.dataSource;
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网络错误"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kU,tableView.rowHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.5];
    [cell.contentView addSubview:bgView];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    UIImageView *image = [UIImageView new];
    image.image = [UIImage imageNamed:@"钱包3"];
    image.frame = CGRectMake(0, 0, 10, 12);
    cell.accessoryView = image;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"客服电话";
        UIView  *lineView = [UIView new];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
        lineView.frame = CGRectMake(0, 80, kU, 0.5);
        //自定义button 在layoutSubviews 中交换label和图片的位置
        contactMeButton *button = [contactMeButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.dataSource objectForKey:@"tel"] forState:UIControlStateNormal];
        //[button setTitle:@"333" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setImage:[UIImage imageNamed:@"钱包3"] forState:UIControlStateNormal];
        [button addTarget:self  action:@selector(tel:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 135, 12);
       //button.backgroundColor = [UIColor redColor];
        //button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 20);
        cell.accessoryView = button ;
        
    }else {
        
        cell.textLabel.text = @"关于亿装修";
        UIView  *lineView = [UIView new];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
        lineView.frame = CGRectMake(0, 80, kU, 0.5);
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *url=[NSString stringWithFormat:@"tel://%@",tel];
        
        UIWebView *callView = [[UIWebView alloc]init];
        [callView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:callView];
    } else {
        AboutXiaoMuJiangController *aboutUS = [[AboutXiaoMuJiangController alloc]init];
        [self.navigationController pushViewController:aboutUS animated:YES];
    }
    
}

-(void)tel:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    NSString *tellStr =[button.titleLabel.text stringByReplacingOccurrencesOfString:@"－" withString:@""];
    
    SLog(@"%@",tellStr);
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tellStr];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

@end
