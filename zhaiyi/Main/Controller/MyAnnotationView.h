//
//  MyAnnotationView.h
//  zhaiyi
//
//  Created by ass on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAnnotationView : UIView

+(instancetype) appView;

- (void)addTarget:(nullable id)target action:(SEL)action;


@property (weak, nonatomic) IBOutlet UILabel *gongzhong;

@property (weak, nonatomic) IBOutlet UILabel *renShu;

@property (weak, nonatomic) IBOutlet UILabel *zhaoGongZhungTai;
@property (weak, nonatomic) IBOutlet UIImageView *datouzhenTopImageView;

@property (nonatomic, strong)NSDictionary *userInfo;

@end
