//
//  MyAnnotationView.h
//  zhaiyi
//
//  Created by ass on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAnnotationViewWithGZ : UIView

+(instancetype) appView;

- (void)addTarget:(nullable id)target action:(SEL)action;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;

-(void)showXingxing :(int)num;

@end
