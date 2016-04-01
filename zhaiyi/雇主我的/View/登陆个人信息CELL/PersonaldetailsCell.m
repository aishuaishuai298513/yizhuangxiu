//
//  PersonaldetailsCell.m
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PersonaldetailsCell.h"

@implementation PersonaldetailsCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)loadPersonaldetailsCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"PersonaldetailsCell" owner:nil options:nil]lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
