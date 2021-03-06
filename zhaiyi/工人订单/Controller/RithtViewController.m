//
//  RithtViewController.m
//  zhaiyi
//
//  Created by exe on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RithtViewController.h"
#import "ADDetailViewCell.h"
#import "ADDeatiCell.h"
#import "ADAssessController.h"

#import "UIImageView+WebCache.h"
@interface RithtViewController ()<UITableViewDataSource,UITableViewDelegate>

//删除操作
- (IBAction)deleteClick:(id)sender;

- (IBAction)accessClick:(id)sender;

- (IBAction)callPhone:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIView *tanchuKuangView;
@property (weak, nonatomic) IBOutlet UIView *beijingView;

- (IBAction)quxiaoOrder:(id)sender;

- (IBAction)quedingOrder:(id)sender;

@end

@implementation RithtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    ADAccount *acount = [ADAccountTool account];

   // [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://zhaiyi.bjqttd.com%@",acount.picture]]];
    
    [self configueRightBarItem];
    
    [self netWorkInfo];
}

-(void)netWorkInfo
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.Ordermodel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_qiangdanxiangqing params:parm success:^(id responseObj) {
        
    } failure:^(NSError *error) {
        
    }];
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
        
//        detailcell.starDateLb.text =[NSString date2String:_Ordermodel.startDate];
//        detailcell.endDateLb.text =[NSString date2String:_Ordermodel.endDate];
        
        NSString *day= [NSString numberOfDays1:detailcell.starDateLb.text numberOfDays2:detailcell.endDateLb.text timeStringFormat:@"yyyy-MM-dd"];
        //detailcell.dayCountNum.text =[NSString stringWithFormat:@"共%@天",@"30"];
        [detailcell.dayNum setTitle:day forState:UIControlStateNormal];
        return detailcell;
        
    }else{
        static NSString *ID = @"cell";
        ADDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [ADDetailViewCell cell];
        }
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text = @"工程地点";
               // cell.midLabel.text = _Ordermodel.address;
                cell.rightLable.text = @"";
                break;
            case 1:
                cell.leftLabel.text = @"工作内容";
               // cell.midLabel.text = _Ordermodel.txt;
                cell.rightLable.text = @"";
                break;
            case 2:
                cell.leftLabel.text = @"需求人数";
                //cell.midLabel.text = [NSString stringWithFormat:@"%@人",_Ordermodel.num];
                cell.rightLable.text = @"";
                break;
            case 4:
                cell.leftLabel.text = @"价格";
                //cell.midLabel.text = [NSString stringWithFormat:@"%d",[_Ordermodel.money intValue]];
                cell.midLabel.textColor = [UIColor redColor];
                cell.rightLable.text = @"元/天";
                break;
            case 5:
                cell.leftLabel.text = @"联系人";
                //cell.midLabel.text = _Ordermodel.name;
                cell.rightLable.text = @"";
                break;
            case 6:
                cell.leftLabel.text = @"订单号";
                //cell.midLabel.text = _Ordermodel.ddh;
                cell.rightLable.text = @"";
                break;
            case 7:
                cell.leftLabel.text = @"备注";
                //cell.midLabel.text = _Ordermodel.txt1;
                cell.rightLable.text = @"";
                break;
                
            default:
                break;
        }
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
//删除操作
- (IBAction)deleteClick:(id)sender {
    
    self.beijingView.hidden  = NO;
    self.tanchuKuangView.hidden = NO;
    
//    //初始化一个弹框控制器（标题部分）
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除订单？" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    //取消按钮
//    UIAlertAction * cancel=[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    //确定按钮（在block里面执行要做的动作）
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self shanchudingdan];
//        
//    }];
//    //把动作添加到控制器
//    [alertController addAction:cancel];
//    [alertController addAction:sure];
//    [self presentViewController:alertController animated:YES completion:^{
//        
//    }];
}

-(void)shanchudingdan
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"user_id"];
    [parm setObject:self.Ordermodel.ID forKey:@"indent_id"];
    
    [NetWork postNoParm:gongrenshanchuDingdan params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {

            [ITTPromptView showMessage:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
//跳到评价控制器
- (IBAction)accessClick:(id)sender {
    
    ADAssessController *assess = [[ADAssessController alloc]init];
    assess.OrderModel =self.Ordermodel;
    [self.navigationController pushViewController:assess animated:YES];
}

- (IBAction)callPhone:(id)sender {
    
   // [ADAccountTool CallPhone:self.Ordermodel.tel];
    
}

// 评价列表
-(void)evaluateList
{
    NSLog(@"123");
}
- (IBAction)quxiaoOrder:(id)sender {
    
    self.beijingView.hidden = YES;
    self.tanchuKuangView.hidden = YES;
}

- (IBAction)quedingOrder:(id)sender {
    
    self.beijingView.hidden = YES;
    self.tanchuKuangView.hidden = YES;
    
    [self shanchudingdan];
}
@end
