//
//  ADOrderViewCell.m
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADOrderViewCell.h"

@interface ADOrderViewCell()

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
//确认完工
@property (weak, nonatomic) IBOutlet UIButton *QueRenBtn;


@end

@implementation ADOrderViewCell

+(instancetype)cell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ADOrderViewCell" owner:nil options:nil]lastObject];
}

-(void)setOrderModel:(DWOrderModel *)OrderModel
{
    _OrderModel = OrderModel;
    
     self.Timelabel.text = OrderModel.kaigongriqi;

     self.orderNumlb.text = _OrderModel.ordercode;
     self.AdressLb.text = _OrderModel.adr;
     self.workNumLb.text = _OrderModel.n;
    self.priceLb.text = [NSString stringWithFormat:@"价格:%d元／天",[_OrderModel.price intValue]];
     [self.gongZhongLb setTitle:[NSString stringWithFormat:@"%@",_OrderModel.gzname] forState:
     UIControlStateNormal];
}
@end
