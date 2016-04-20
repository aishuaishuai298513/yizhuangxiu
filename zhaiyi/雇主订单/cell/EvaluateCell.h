//
//  EvaluateCell.h
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"
@protocol CellXingClicked <NSObject>

@optional
-(void)cellXingClicked:(int)xingJi row:(int)Row;

@end

@interface EvaluateCell : UITableViewCell

@property (nonatomic, strong) ADAccount *UserAcount;
@property (nonatomic, strong) DWOrderModel *OrderModel;
@property (nonatomic,weak)id<CellXingClicked>delegate;

@property (nonatomic, assign) int row;
@property (weak, nonatomic) IBOutlet UILabel *zongtifuwu;
@end
