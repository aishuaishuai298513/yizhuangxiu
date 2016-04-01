//
//  contactMeButton.m
//  zhaiyi
//
//  Created by sks on 15/12/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "contactMeButton.h"
#import "UIView+Extension.h"
@implementation contactMeButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // code
    }
    return self;
}


//自定义的button,在这个方法里面交换label和imageView的位置
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.x = self.width - 14;
    self.titleLabel.x =  self.imageView.x-14-self.titleLabel.width ;
//    self.titleLabel.x = 0;
//    self.imageView.x = self.titleLabel.width + 14;
}
@end
