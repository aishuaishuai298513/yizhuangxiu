//
//  PersonalDetails2Cell.h
//  zhaiyi
//
//  Created by cajan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalDetails2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;
+ (instancetype)loadPersonaldetailsCell;
@end
