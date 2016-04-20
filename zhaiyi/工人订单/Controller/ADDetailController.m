//
//  ADDetailController.m
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADDetailController.h"
#import "ADDetailViewCell.h"
#import "ADDeatiCell.h"
#import "ADFinishController.h"
#import "CancelViewController.h"

@interface ADDetailController ()<UITableViewDataSource,UITableViewDelegate>

- (IBAction)cancelClick:(id)sender;
//确认完工
- (IBAction)OrderClick:(id)sender;
//一键拨号
- (IBAction)callPhone:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *CancleView;

- (IBAction)quxiaoDingDan:(id)sender;

- (IBAction)shanchuOrder:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *beijingkuang;


@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation ADDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"详情";
    ADAccount *acount = [ADAccountTool account];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",XMJ_BASE_URL,acount.picture]]];
    
    [self configueRightBarItem];
    
}
- (void)configueRightBarItem{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(evaluateList) forControlEvents:UIControlEventTouchUpInside];
    
//    [rightBtn setImage:[UIImage imageNamed:@"邓军1、"] forState:UIControlStateNormal];
//    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = barBtnItem;
}

#pragma mark---数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        static NSString *ID = @"detail";
        ADDeatiCell *detailcell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!detailcell) {
            detailcell = [ADDeatiCell detailCell];
        }
//        detailcell.starDateLb.text = [NSString date2String:_OrderModel.startDate];
//        detailcell.endDateLb.text = [NSString date2String:_OrderModel.endDate];
        
//        NSLog(@"%@",detailcell.starDateLb.text);
//        NSLog(@"%@",detailcell.endDateLb.text);
        
        NSString *day = [NSString numberOfDays1:detailcell.starDateLb.text numberOfDays2:detailcell.endDateLb.text timeStringFormat:@"yyyy-MM-dd"];

        //detailcell.dayCountNum.text = [NSString stringWithFormat:@"共%@天",day];
        [detailcell.dayNum setTitle:day forState:UIControlStateNormal];

    
        return detailcell;
        
    }else{
        static NSString *ID = @"cell";
        ADDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
        cell = [ADDetailViewCell cell];
    }
//        switch (indexPath.row) {
//            case 0:
//                cell.leftLabel.text = @"工程地点";
//                cell.midLabel.text = _OrderModel.address;
//                cell.rightLable.text = @"";
//                break;
//            case 1:
//                cell.leftLabel.text = @"工作内容";
//                cell.midLabel.text = _OrderModel.txt;
//                cell.rightLable.text = @"";
//                break;
//            case 2:
//                cell.leftLabel.text = @"需求人数";
//                cell.midLabel.text = _OrderModel.num;
//                cell.rightLable.text = @"";
//                break;
//            case 4:
//                cell.leftLabel.text = @"价格";
//                cell.midLabel.text = [NSString stringWithFormat:@"%d",[_OrderModel.money intValue]];
//                cell.midLabel.textColor = [UIColor redColor];
//                cell.rightLable.text = @"元/天";
//                break;
//            case 5:
//                cell.leftLabel.text = @"联系人";
//                cell.midLabel.text = _OrderModel.name;
//                cell.rightLable.text = @"";
//                break;
//            case 6:
//                cell.leftLabel.text = @"订单号";
//                cell.midLabel.text = _OrderModel.ddh;
//                cell.rightLable.text = @"";
//                break;
//            case 7:
//                cell.leftLabel.text = @"备注";
//                cell.midLabel.text = _OrderModel.txt1;
//                cell.rightLable.text = @"";
//                break;
//
//            default:
//                break;
//        }
         return cell;
    }
}
#pragma mark---代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 88;
    }
    return 44;
}

- (IBAction)cancelClick:(id)sender {
    
    
    self.CancleView.hidden = NO;
    self.beijingkuang.hidden = NO;
    
    
//  初始化一个弹框控制器（标题部分）
//  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认取消订单？" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    //取消按钮
//    UIAlertAction * cancel=[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    //确定按钮（在block里面执行要做的动作）
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//        CancelViewController *cancel = [[CancelViewController alloc]init];
//        cancel.OrderModel = self.OrderModel;
//        [self.navigationController pushViewController:cancel animated:YES];
//    }];
//    //把动作添加到控制器
//    [alertController addAction:cancel];
//    [alertController addAction:sure];
//    [self presentViewController:alertController animated:YES completion:^{
//        
//    }];
}

- (IBAction)OrderClick:(id)sender {
    
    //确认完工
    [self queRenWanGongNewWork];
    
//    ADFinishController *finish = [[ADFinishController alloc]init];
//    [self.navigationController pushViewController:finish animated:YES];
    
}


//一键拨号
- (IBAction)callPhone:(id)sender {
    
   // NSLog(@"123");
    //拨号
    //[ADAccountTool CallPhone:self.OrderModel.tel];
    
}

- (IBAction)quxiaoDingDan:(id)sender {
    
    self.beijingkuang.hidden = YES;
    self.CancleView.hidden = YES;
}

- (IBAction)shanchuOrder:(id)sender {
    
    self.beijingkuang.hidden = YES;
    self.CancleView.hidden = YES;
    
    CancelViewController *cancel = [[CancelViewController alloc]init];
    cancel.OrderModel = self.OrderModel;
    [self.navigationController pushViewController:cancel animated:YES];
    
}

-(void)queRenWanGongNewWork
{
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm= [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"user_id"];
    [parm setObject:self.OrderModel.ID forKey:@"order_id"];
    [NetWork postNoParm:gongRenJungong params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            
            [ITTPromptView showMessage:@"成功"];
           
            //跳到评价列表
            ADFinishController *finish = [[ADFinishController alloc]init];
            finish.OrderModel =self.OrderModel;
            [self.navigationController pushViewController:finish animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

// 评价列表
-(void)evaluateList
{
    
    
    NSLog(@"123");
}
@end
