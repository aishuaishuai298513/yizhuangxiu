//
//  My_pocket_jiaoyijilu_ViewCell.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_jiaoyijilu_ViewCell.h"
#import "TradeRecordModel.h"

@interface My_pocket_jiaoyijilu_ViewCell ()

@property (nonatomic, strong) TradeRecordModel *recordModel;

@end

@implementation My_pocket_jiaoyijilu_ViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)RecordModel:(NSDictionary *)dict{

    _recordModel = [[TradeRecordModel alloc]init];
    
    [_recordModel setValuesForKeysWithDictionary:dict];
//    _RecordModel = recordModel;
    
    NSLog(@"goods_type   %@",_recordModel.goods_type);
    self.jiaoyiTitleLb.text = _recordModel.goods_type;
    
    NSString *timeLb = _recordModel.createtime;
    NSRange range = NSMakeRange(5, 11);
    self.jiaoyiTimeLb.text = [timeLb substringWithRange:range];
    
    self.jiaoyiMoneyLb.text = [NSString stringWithFormat:@"￥%@",_recordModel.carry_cash];
 
    if ([_recordModel.status isEqualToString:@"107"]) {
        self.jiaoyiDesLb.text = [NSString stringWithFormat:@"%@申请已提交",_recordModel.goods_type];
    }else {
//        @"108"
        self.jiaoyiDesLb.text = [NSString stringWithFormat:@"%@已完成",_recordModel.goods_type];
    }
 
    
}

@end
