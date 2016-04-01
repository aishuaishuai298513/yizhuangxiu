//
//  My_Login_UserInfo_Cell.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_Login_UserInfo_Cell.h"

@implementation My_Login_UserInfo_Cell

- (void)awakeFromNib {
    // Initialization code
    _userImgV.layer.cornerRadius = _userImgV.size.height/2;
    _userImgV.userInteractionEnabled = YES;
    _userImgV.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
