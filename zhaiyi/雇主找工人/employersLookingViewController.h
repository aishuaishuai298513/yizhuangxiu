//
//  employersLookingViewController.h
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface employersLookingViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>


//怕断是否是重新发布跳转
@property (nonatomic, assign) BOOL isChongXinFaBu;
//重新发布订单ID
@property (nonatomic, strong) NSString *orderId;

//地图相关
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;


@property (nonatomic, copy) void(^diLiBianMa)(NSString *diDian);

@end
