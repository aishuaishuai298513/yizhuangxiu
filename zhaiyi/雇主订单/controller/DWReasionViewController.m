//
//  DWReasionViewController.m
//  zhaiyi
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWReasionViewController.h"
#import "DWQuitReasionCell.h"
#import "PlaceholdertextView.h"

@interface DWReasionViewController ()<UITextViewDelegate>
{
    
    DWQuitReasionCell *cell;
    NSInteger SelectIndex;
    PlaceholdertextView *textV;
    UITapGestureRecognizer *tap;
    
}
@end

@implementation DWReasionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"辞退原因"];
    [self configueHeaderView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DWQuitReasionCell" bundle:nil] forCellReuseIdentifier:@"DWQuitReasionCell"];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillbehiden) name:UIKeyboardWillHideNotification object:nil];
    
}
//添加手势
-(void)addTap
{
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TableviewClicked:)];
    [self.tableView addGestureRecognizer:tap];
}
//删除手势
-(void)removeTap
{
    [self.tableView removeGestureRecognizer:tap];
}

- (void)configueHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, [UIScreen mainScreen].bounds.size.width, 26)];
    label.text = @"请选择辞退的原因";
    label.textColor = [UIColor redColor];
    label.alpha = 0.5;
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    headerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"DWQuitReasionCell" forIndexPath:indexPath];
    cell.leftLabel.textColor = [UIColor redColor];
    cell.leftLabel.font = [UIFont systemFontOfSize:15];
    cell.rightBtn.userInteractionEnabled = NO;

    if (indexPath.row == 0) {
        cell.leftLabel.text = @"工作态度差";
        [cell.rightBtn setImage:[UIImage imageNamed:@"找工人4"] forState:UIControlStateNormal];
    }else if(indexPath.row == 1){
        cell.leftLabel.text = @"技术不达标";
        [cell.rightBtn setImage:[UIImage imageNamed:@"找工人4"] forState:UIControlStateNormal];
    }else if(indexPath.row == 2){
        cell.leftLabel.text = @"消极怠工";
        [cell.rightBtn setImage:[UIImage imageNamed:@"找工人4"] forState:UIControlStateNormal];
    }else if(indexPath.row == 3){
        cell.leftLabel.text = @"其他";
        [cell.rightBtn setImage:[UIImage imageNamed:@"找工人4"] forState:UIControlStateNormal];
    }
    
    if (indexPath.row == SelectIndex) {
        
        [cell.rightBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectIndex  =indexPath.row;
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.tableView reloadData];
}

//提交－－辞退
-(void)tijiao
{
    //////////////辞退
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.OrderModel.userid forKey:@"userid2"];
    [parm setObject:self.OrderModel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_citui params:parm success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            pop
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    footerView.userInteractionEnabled = YES;
     textV = [[PlaceholdertextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    textV.placeholder = @"请输入辞退原因，谢谢您的配合";
    textV.placeholderColor = [UIColor redColor];
    textV.delegate = self;
    textV.font = [UIFont systemFontOfSize:14.f];
    // textView.backgroundColor = [UIColor redColor];
    
    [footerView addSubview:textV];
    textV.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    
    // 辞退按钮
    UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 108, [UIScreen mainScreen].bounds.size.width - 16, 44)];
    
    quitButton.backgroundColor = [UIColor colorWithRed:211/255.0 green:42/255.0 blue:65/255.0 alpha:1.000];
    
    quitButton.layer.cornerRadius = 20;
    quitButton.clipsToBounds = YES;
    
    [quitButton setTitle:@"提交" forState:UIControlStateNormal];
    
    [quitButton addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:quitButton];
    
    return footerView;
    //self.tableView.tableFooterView = footerView;
    //self.tableView.tableFooterView.userInteractionEnabled = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 200;
}

-(void)TableviewClicked:(UITapGestureRecognizer*)tap
{
    NSLog(@"123");
    [textV resignFirstResponder];
}

//键盘弹出
-(void)keyboardWasShown
{
  [self addTap];
}

//键盘收回
-(void)keyboardWillbehiden
{
    [self removeTap];
}

@end
