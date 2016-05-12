//
//  ADOrderViewCell.m
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADOrderViewCell.h"

#import "SelectDeleteView.h"

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

@property (weak, nonatomic) IBOutlet UIImageView *Bao;



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
    self.Timelabel.font = [UIFont systemFontSizeWithScreen:13];

    self.orderNumlb.text = _OrderModel.ordercode;
    self.orderNumlb.font = [UIFont systemFontSizeWithScreen:10];
    
    self.AdressLb.text = _OrderModel.adr;
    self.AdressLb.font = [UIFont systemFontSizeWithScreen:15];
    

    self.workNumLb.text = [NSString stringWithFormat:@"工作人数:%@人",_OrderModel.n];
    self.workNumLb.font = [UIFont systemFontSizeWithScreen:13];
    self.priceLb.text = [NSString stringWithFormat:@"价格%.2f元／天",[_OrderModel.price floatValue]];
    self.priceLb.font = [UIFont systemFontSizeWithScreen:13];
    
     [self.gongZhongLb setTitle:[NSString stringWithFormat:@"%@",_OrderModel.gzname] forState:
     UIControlStateNormal];
    
    //是否显示保
    if([_OrderModel.baozhengjin floatValue]>0)
    {
        self.Bao.hidden = NO;
        
    }else
    {
        self.Bao.hidden = YES;
    }
    
    //以抢单
    if (_workStue == 1) {
        
        if([self.OrderModel.shifoucitui isEqualToString:@"38"])
        {
            [self.QueRenBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            
        }else
        {
           [self.QueRenBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        }
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
    
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    //抢单id
    [parm setObject:self.OrderModel.ID forKey:@"id"];
    
    [NetWork postNoParm:YZX_querenshoukuan params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            //[ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            
                if (self.queRenShouKuan) {
                    _queRenShouKuan(responseObj);
                }
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网路错误"];
    }];
    
}

-(void)Cancle
{

}
#pragma mark 删除订单
-(void)shanchuOrderC
{
    
    SelectDeleteView *selectV = [SelectDeleteView loadView];
    
    UIView *backView = [Function createBackView:self action:@selector(Cancle)];
    backView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    
    selectV.frame = CGRectMake((ScreenW-164)/2, (ScreenH-130)/2, 164, 130);
    
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [[UIApplication sharedApplication].keyWindow addSubview:selectV];
    
    __block  SelectDeleteView *select = selectV;
    __block  UIView *back = backView;
    selectV.Cancle = ^(){
        [select removeFromSuperview];
        [back removeFromSuperview];
        
    };
    __weak typeof (self)WeakSelf = self;
    selectV.makeSure = ^(){
        [select removeFromSuperview];
        [back removeFromSuperview];
        
        [WeakSelf shanchu];
    };
    
    
    }


#pragma mark 删除
-(void)shanchu
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
