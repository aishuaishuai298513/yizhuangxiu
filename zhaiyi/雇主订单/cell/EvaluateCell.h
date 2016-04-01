//
//  EvaluateCell.h
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"
@protocol CellDelete <NSObject>

@optional
-(void)cellDeleteClicked:(id)Target;

@end

@interface EvaluateCell : UITableViewCell

@property (nonatomic, strong) ADAccount *UserAcount;
@property (nonatomic, strong) DWOrderModel *OrderModel;
@property (nonatomic,weak)id<CellDelete>delegate;

@property (weak, nonatomic) IBOutlet UILabel *zongtifuwu;
@end
