//
//  PayPasswordViewController.h
//  zhaiyi
//
//  Created by ass on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PayController) {
    setPassword,
    updatePassword
};

@interface PayPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassword;

@property (weak, nonatomic) IBOutlet UITextField *code;

@property (weak, nonatomic) IBOutlet UIButton *maekSurebtn;


@property (nonatomic, assign) PayController payController;

@end
