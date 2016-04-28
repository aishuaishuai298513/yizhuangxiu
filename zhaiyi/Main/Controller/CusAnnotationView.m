//
//  CusAnnotationView.m
//  MAMapKit_static_demo
//
//  Created by songjian on 13-10-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CusAnnotationView.h"
#import "CustomCalloutView.h"
#import "MyAnnotationView.h"
#import "MyAnnotationViewWithGZ.h"

#define kWidth  100.f
#define kHeight 84.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CusAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) MyAnnotationView *MyAnnView;
@property (nonatomic, strong) MyAnnotationViewWithGZ *MyAnnViewGz;

@end

@implementation CusAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(10, 10, 40, 40);
            [btn setTitle:@"Test" forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.calloutView addSubview:btn];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
            name.backgroundColor = [UIColor clearColor];
            name.textColor = [UIColor whiteColor];
            name.text = @"Hello Amap!";
            [self.calloutView addSubview:name];
           
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits, 
     even if they actually lie within one of the receiver’s subviews. 
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        self.superview.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        //[self addSubview:self.portraitImageView];
        
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
                                                                   kVertMargin,
                                                                   kWidth - kPortraitWidth - kHoriMargin,
                                                                   kHeight - 2 * kVertMargin)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor whiteColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
        
        
//        //添加自定义大头针数据
//        _MyAnnView = [MyAnnotationView appView];
//        _MyAnnView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+50);
//        _MyAnnView.backgroundColor = [UIColor clearColor];
//        
//        [_MyAnnView addTarget:self action:@selector(daTouZhenClicked)];
//
//        [self addSubview:_MyAnnView];

        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}


-(void)daTouZhenClicked
{
    NSLog(@"大头针被点击了");
}

-(void)setTypeGongRen:(NSString *)TypeGongRen
{
    _MyAnnView.gongzhong.text = TypeGongRen;
}


-(void)setDatouzhentype:(int)datouzhentype
{
    _datouzhentype = datouzhentype;
    
    //工人
    if (datouzhentype == 1) {
        [_MyAnnView removeFromSuperview];
        //添加自定义大头针数据
        _MyAnnView = [MyAnnotationView appView];
        _MyAnnView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+50);
        _MyAnnView.backgroundColor = [UIColor clearColor];
        
        _MyAnnView.userInfo = self.userinfo;
        
        //NSLog(@"aaaasdsdadsd%@",_MyAnnView.userInfo);
        [_MyAnnView addTarget:self action:@selector(daTouZhenClicked)];
        
        [self addSubview:_MyAnnView];
        
    }else if (datouzhentype == 2)
    {
        
        self.layer.cornerRadius = 22;
        self.layer.masksToBounds = YES;
        
        self.width = 140;
        self.height = 47;
        [_MyAnnViewGz removeFromSuperview];
        _MyAnnViewGz = [MyAnnotationViewWithGZ appView];
        _MyAnnViewGz.frame = CGRectMake(0, 0, 140, 47);
        _MyAnnViewGz.userInfo = self.userinfo;
        //SLog(@"％@",_MyAnnView.userInfo);
        //_MyAnnViewGz.backgroundColor = [UIColor clearColor];
         [self addSubview:_MyAnnViewGz];
    }
}

-(void)setUserinfo:(NSMutableDictionary *)userinfo
{
    _userinfo = userinfo;
    //NSLog(@"%@",_userinfo);
    
    
}

@end
