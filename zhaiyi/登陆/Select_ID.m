//
//  Select_ID.m
//  zhaiyi
//
//  Created by ass on 16/3/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Select_ID.h"

@interface Select_ID()
@property (weak, nonatomic) IBOutlet UIImageView *grImageV;
@property (weak, nonatomic) IBOutlet UIImageView *gzImageV;

@property (weak, nonatomic) IBOutlet UIButton *findwork;
@property (weak, nonatomic) IBOutlet UIButton *findPeopleBtn;


- (IBAction)findWorkClicked:(id)sender;

- (IBAction)findPeopleClicked:(id)sender;
@end
@implementation Select_ID

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)findWorkClicked:(id)sender {
    SetUserDefaultsGR
    if (self.ifFirstLogin) {
        [self animationToDisapper];
        //block
        if (self.selectShenFen) {
            
            _selectShenFen();
        }
        
    }else
    {
       [self setMainView];
    }
}

- (IBAction)findPeopleClicked:(id)sender {
    SetUserDefaultsGZ
    
    if (self.ifFirstLogin) {
        
        //block
        if (self.selectShenFen) {
            
            _selectShenFen();
        }
        [self animationToDisapper];
    }else
    {
        [self setMainView];
    }
}


-(void)animationToDisapper
{
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



-(void)setMainView
{
    UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController* MainCotroller = [MainStoryboard instantiateViewControllerWithIdentifier:@"MainNav"];
    
    // 设置窗口的根控制器
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    keyWindow.rootViewController = MainCotroller;
}

+(instancetype)loadView
{
    
    Select_ID *view = [[[NSBundle mainBundle]loadNibNamed:@"Select_ID" owner:nil options:nil]lastObject];
    
    view.findPeopleBtn.layer.cornerRadius = 5;
    view.findPeopleBtn.clipsToBounds = YES;
    
    view.findwork.layer.cornerRadius = 5;
    view.findwork.clipsToBounds = YES;
    
    return view;
}
@end
