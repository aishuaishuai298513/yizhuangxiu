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
//以辞退
@property (weak, nonatomic) IBOutlet UIButton *yiCiTuiBtn;


@end

@implementation ADOrderViewCell

+(instancetype)cell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ADOrderViewCell" owner:nil options:nil]lastObject];
}

-(void)setOrderModel:(DWOrderModel *)OrderModel
{
     self.yiCiTuiBtn.hidden = YES;
    
    _OrderModel = OrderModel;
    
     self.Timelabel.text = OrderModel.kaigongriqi;

     self.orderNumlb.text = _OrderModel.ordercode;
     self.AdressLb.text = _OrderModel.adr;
     self.workNumLb.text = _OrderModel.n;
    self.priceLb.text = [NSString stringWithFormat:@"价格:%d元／天",[_OrderModel.price intValue]];
     [self.gongZhongLb setTitle:[NSString stringWithFormat:@"%@",_OrderModel.gzname] forState:
     UIControlStateNormal];
    
    //以抢单
    if (_workStue == 1) {
        [self.QueRenBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.QueRenBtn addTarget:self action:@selector(cancleOrderC) forControlEvents:UIControlEventTouchUpInside];
        
    }
    //施工中
    if (_workStue == 2){
        //结算
        if ([self.OrderModel.status isEqualToString:@"9"]||[self.OrderModel.status isEqualToString:@"10"]) {
            
            [self.QueRenBtn setTitle:@"实时结算" forState:UIControlStateNormal];
            [self.QueRenBtn addTarget:self action:@selector(jisuanOrderC) forControlEvents:UIControlEventTouchUpInside];
        }else if([self.OrderModel.status isEqualToString:@"11"])
        {
            [self.QueRenBtn setTitle:@"待结算" forState:UIControlStateNormal];
        }else if ([self.OrderModel.status isEqualToString:@"12"])
        {
            [self.QueRenBtn setTitle:@"确认收款" forState:UIControlStateNormal];
            [self.QueRenBtn addTarget:self action:@selector(queRenShouKuanC) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    //已竣工
    if (_workStue == 3) {
        [self.QueRenBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.QueRenBtn addTarget:self action:@selector(shanchuOrderC) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //37正常工作38已被辞退
    if([self.OrderModel.shifoucitui isEqualToString:@"38"])
    {
        self.yiCiTuiBtn.hidden = NO;
    }
    
    //10开工后被辞退
    if ([self.OrderModel.status isEqualToString:@"10"]) {
        self.yiCiTuiBtn.hidden = NO;
    }
    
    
}


#pragma mark 取消订单
-(void)cancleOrderC
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    //抢单id
    [parm setObject:self.OrderModel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_quxiaodingdan_gr params:parm success:^(id responseObj) {
       // NSLog(@"%@",responseObj);
        if (self.cancleOrder) {
            _cancleOrder(responseObj);
        }
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网路错误"];
    }];
    
}


#pragma mark 实时结算
-(void)jisuanOrderC
{
    if(self.jisuanOrder)
    {
        _jisuanOrder(self.OrderModel);
    }
}

#pragma mark 确认首款
-(void)queRenShouKuanC
{
    
}

#pragma mark 删除订单
-(void)shanchuOrderC
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    //抢单id
    [parm setObject:self.OrderModel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_shanchudingdan_gr params:parm success:^(id responseObj) {
       // NSLog(@"%@",responseObj);
        if (self.shanchuOrder) {
            _shanchuOrder(responseObj);
        }
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网路错误"];
    }];
}


-(void)jiesuan{

}
@end
