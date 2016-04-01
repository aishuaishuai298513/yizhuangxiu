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
    NSString *name =[_dataSource objectForKey:@"nickname"];
    NSString *nameHeader = [name substringToIndex:1];
    NSString *nameFooter = [name substringFromIndex:name.length - 1];
    
    NSLog(@"%@",nameHeader);
    NSLog(@"%@",nameFooter);
    self.nameLb.text = [NSString stringWithFormat:@"%@*%@",nameHeader,nameFooter];
    
    
    for (int i = 1;  i<=[[_dataSource objectForKey:@"degree"] intValue]; i++)
    {
       UIButton *btn = (UIButton *)[self.contentView viewWithTag:i];
        
       //[btn setBackgroundImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
    }
    
    self.pingjia.text = [_dataSource objectForKey:@"content"];
    self.time.text = [NSString date2String:[_dataSource objectForKey:@"updatetime"]];
    
}

@end
