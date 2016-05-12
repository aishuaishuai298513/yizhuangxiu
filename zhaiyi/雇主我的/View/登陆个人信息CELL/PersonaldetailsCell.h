//
//  PersonaldetailsCell.h
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonaldetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (weak, nonatomic) IBOutlet UIButton *finashBtn;

+ (instancetype)loadPersonaldetailsCell;

@property (weak, nonatomic) IBOutlet UIView *Line;

@property (weak, nonatomic) IBOutlet UIScrollView *textVScrool;
@end
