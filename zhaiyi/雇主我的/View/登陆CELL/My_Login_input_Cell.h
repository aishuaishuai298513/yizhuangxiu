//
//  My_Login_input_Cell.h
//  zhaiyi
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginOrRegin <NSObject>
-(void)ReginClick:(NSString *)userName PassWord:(NSString *)PassWord;

-(void)ForgetPassClicked:(NSString *)userName PassWord:(NSString *)PassWord;

@end

@interface My_Login_input_Cell : UITableViewCell

@property (nonatomic,assign)id <LoginOrRegin> delegate;

-(NSString *)getUserName;
-(NSString *)getPassWord;
-(BOOL)getLeiXinag;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;

@property (weak, nonatomic) IBOutlet UIButton *dengLuBtn;

@end
