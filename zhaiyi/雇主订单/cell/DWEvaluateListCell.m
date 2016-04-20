//
//  DWEvaluateListCell.m
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWEvaluateListCell.h"

@implementation DWEvaluateListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataSource:(NSMutableDictionary *)dataSource
{
    _dataSource =dataSource;

    self.nameLb.text = [_dataSource objectForKey:@"name"];
    
    
    for (int i = 1;  i<=[[_dataSource objectForKey:@"zongtifuwu"] intValue]; i++)
    {
       UIButton *btn = (UIButton *)[self.contentView viewWithTag:i];
        
       //[btn setBackgroundImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
    }
    
    self.time.text = [_dataSource objectForKey:@"createtime"];
    
}

@end
