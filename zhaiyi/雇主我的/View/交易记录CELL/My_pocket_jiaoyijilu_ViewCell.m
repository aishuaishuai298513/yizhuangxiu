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
    
    self.jiaoyiTitleLb.text = _recordModel.title;
    
    self.jiaoyiTimeLb.text = _recordModel.createtime;
    
    self.jiaoyiMoneyLb.text = [NSString stringWithFormat:@"%@",_recordModel.money];
    
}

@end
