//
//  My_Login_UserInfo_Cell.h
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My_Login_UserInfo_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImgV;

@property (weak, nonatomic) IBOutlet UIButton *InfoDetil;

@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLb;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;


@end
