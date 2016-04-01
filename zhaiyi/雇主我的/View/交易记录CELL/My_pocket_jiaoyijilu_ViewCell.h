//
//  My_pocket_jiaoyijilu_ViewCell.h
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeRecordModel.h"

@interface My_pocket_jiaoyijilu_ViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiDesLb;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiMoneyLb;

-(void)RecordModel:(NSDictionary *)dict;


@end
