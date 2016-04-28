//
//  CusAnnotationView.h
//  MAMapKit_static_demo
//
//  Created by songjian on 13-10-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//



#import <MAMapKit/MAMapKit.h>

@interface CusAnnotationView : MAAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;


//自定义大头针View需要显示的数据
@property (nonatomic, strong) NSString *TypeGongRen;

//大头针类型
@property (nonatomic, assign) int datouzhentype;

@property (nonatomic, strong)NSMutableDictionary *userinfo;

@end
