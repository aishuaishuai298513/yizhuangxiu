//
//  My_Login_input_Cell.m
//  zhaiyi
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_Login_input_Cell.h"

@interface My_Login_input_Cell()
{
    NSDictionary *_userDict;
}
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;



//@property (weak, nonatomic) IBOutlet UIButton *Guzhu;
//
//@property (weak, nonatomic) IBOutlet UIButton *GongRen;
//
////
//@property (weak, nonatomic) IBOutlet UIView *guZhuLine;
//@property (weak, nonatomic) IBOutlet UIView *gongZhongLine;

@property (nonatomic, assign)BOOL IsGuzhu;

@end

@implementation My_Login_input_Cell

- (void)awakeFromNib {
    // Initialization code
    _IsGuzhu = YES;
    self.dengLuBtn.layer.cornerRadius = 8;
    self.dengLuBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)Resign:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReginClick:PassWord:)]) {
        
        [self.delegate ReginClick:self.UserName.text PassWord:self.passWord.text];
    }
    
}

- (IBAction)forgetPassWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(ForgetPassClicked:PassWord:)]) {
        
        [self.delegate ForgetPassClicked:self.UserName.text PassWord:self.passWord.text];
    }
    
}

-(NSString *)getUserName
{
    
    return self.UserName.text;
}
-(NSString *)getPassWord
{
    return  self.passWord.text;
}
-(BOOL)getLeiXinag
{
    return _IsGuzhu;
}
@end
