//
//  MyAnnotationViewWithGz2.m
//  zhaiyi
//
//  Created by ass on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyAnnotationViewWithGz2.h"

@interface MyAnnotationViewWithGz2()
@property (weak, nonatomic) IBOutlet UIView *myView;


@end
@implementation MyAnnotationViewWithGz2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype) appView{
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"MyAnnotationViewWithGz2" owner:nil options:nil];
    return [objs lastObject];
    
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.myView.backgroundColor = [UIColor clearColor];
    
//        self.iconImage.layer.cornerRadius = self.iconImage.width/2;
//    self.iconImage.layer.masksToBounds = YES;

}
- (void)addTarget:(nullable id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    //UIView *selfview = self;
    //    self.datouzhenTopImageView.userInteractionEnabled = YES;
    //    [self.datouzhenTopImageView addGestureRecognizer:tap];
}

//-(void)setUserInfo:(NSDictionary *)userInfo
//{
//    _userInfo = userInfo;
//    
//    //    self.name.text = [userInfo objectForKey:@"name"];
//    //    self.type.text = [userInfo objectForKey:@"gzname"];
//    self.gzName.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:13];
//    
//    
//    NSLog(@"%@",[userInfo objectForKey:@"headpic"]);
//    
//    //    [[SDImageCache sharedImageCache] clearDisk];
//    //
//    //    [[SDImageCache sharedImageCache] clearMemory];//可有可无
//    
//    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,[userInfo objectForKey:@"headpic"]]]];
//    
//    //[self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,@"/headpic.jpg"]]];
//    
//    self.gzName.text = [userInfo objectForKey:@"gzname"];
//    
//    //      NSLog(@"ccccccccc%@",[userInfo objectForKey:@"gzname"]);
//    //     NSLog(@"nnnnnnnn%@",[userInfo objectForKey:@"headpic"]);
//    
//    //    [Function xingji:self xingji:[[userInfo objectForKey:@"xing"] intValue] startTag:1];
//    
//}



@end
