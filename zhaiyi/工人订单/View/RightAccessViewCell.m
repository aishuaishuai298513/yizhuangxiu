//
//  RightAccessViewCell.m
//  zhaiyi
//
//  Created by exe on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RightAccessViewCell.h"

@interface RightAccessViewCell()
//日期
@property (weak, nonatomic) IBOutlet UILabel *Timelabel;
//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumlb;
//地址
@property (weak, nonatomic) IBOutlet UILabel *AdressLb;
//工作人数
@property (weak, nonatomic) IBOutlet UILabel *workNumLb;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
//工种
@property (weak, nonatomic) IBOutlet UIButton *gongZhongLb;
//评价
@property (weak, nonatomic) IBOutlet UIButton *pingjia;



@end

@implementation RightAccessViewCell


+(instancetype)rightCell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"RightAccessViewCell" owner:nil options:nil]lastObject];
}

-(void)setOrderModel:(DWOrderModel *)orderModel
{
    
    _OrderModel = orderModel;
    
//    NSString *datestr1=[NSString dateString:_OrderModel.startDate];
//    NSString *datestr2=[NSString dateString:_OrderModel.endDate];
//    
//    self.Timelabel.text = [NSString stringWithFormat:@"%@-%@",datestr1,datestr2];
//    
//    NSLog(@"%@",_OrderModel.startDate);
//    self.orderNumlb.text = _OrderModel.ID;
//    self.AdressLb.text = _OrderModel.address;
//    self.workNumLb.text = [NSString stringWithFormat:@"工作人数:%@人",_OrderModel.in_num];
//    self.priceLb.text = [NSString stringWithFormat:@"价格:%d元／天",[_OrderModel.money intValue]];
//    
//    if([_OrderModel.gztypeid isEqualToString:@"1"])
//    {
//        [self.gongZhongLb setTitle:@"泥工" forState:
//         UIControlStateNormal];
//    }else if ([_OrderModel.gztypeid isEqualToString:@"2"])
//    {
//        [self.gongZhongLb setTitle:@"油工" forState:
//         UIControlStateNormal];
//    }else if ([_OrderModel.gztypeid isEqualToString:@"3"])
//    {
//        [self.gongZhongLb setTitle:@"水工" forState:
//         UIControlStateNormal];
//    }else if ([_OrderModel.gztypeid isEqualToString:@"4"])
//    {
//        [self.gongZhongLb setTitle:@"电工" forState:
//         UIControlStateNormal];
//    }else if ([_OrderModel.gztypeid isEqualToString:@"5"])
//    {
//        [self.gongZhongLb setTitle:@"木工" forState:
//         UIControlStateNormal];
//    }else if ([_OrderModel.gztypeid isEqualToString:@"6"])
//    {
//        [self.gongZhongLb setTitle:@"小工" forState:
//         UIControlStateNormal];
//    }

    
//    [self.gongZhongLb setTitle:[NSString stringWithFormat:@"%@",_OrderModel.gztypeid] forState:UIControlStateNormal];
    
}


@end
