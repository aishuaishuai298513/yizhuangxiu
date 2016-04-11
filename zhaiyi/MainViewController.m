//
//  MainViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "workerOrderViewController.h"

#import "DWOrderViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MySearch.h"
#import "APService.h"

#import "SSAnnotation.h"
#import "HMAnnotationView.h"

#import <iflyMSC/IFlySpeechRecognizer.h>
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"

#import "My_Login_In_ViewController.h"

#import "CusAnnotationView.h"
#import "ReGeocodeAnnotation.h"
#import "MANaviAnnotationView.h"

#import "employersLookingViewController.h"

#import "Select_ID.h"

typedef NS_ENUM(NSInteger,daTouZhenType)
{
    GongRentype,
    GuZhutype
};

@interface MainViewController ()<UIAlertViewDelegate,IFlySpeechRecognizerDelegate,MAMapViewDelegate,UITextFieldDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

{
    MySearch *searchView;
    IFlySpeechRecognizer *iFlySpeechRecognizer;
    BOOL YuYinShibie;
    UIWindow *window;
    int AnnCount;
    
}

@property (nonatomic,strong)NSString * userStatus;
@property (strong, nonatomic) IBOutlet UIButton *myBtn;
@property (strong, nonatomic) IBOutlet UIButton *orderBtn;
@property (strong, nonatomic) IBOutlet UIButton *firstBtn;

@property (nonatomic,strong) CLLocationManager *manger;
@property (weak, nonatomic) IBOutlet UIView *BottomMenuView;
// 大头针数组
@property (nonatomic,strong) NSMutableArray *anncoationArray;
//搜索提示
@property (nonatomic, strong) NSMutableArray *tips;
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;
//反地理编码
@property (nonatomic, readwrite, strong) AMapReGeocode *reGeocode;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
 /* 包含 省, 市, 区以及乡镇.  */
@property (nonatomic, copy) NSString *titles;
/* 包含 社区，建筑. */
@property (nonatomic, copy) NSString *subtitle;

//coreLocation
//@property (nonatomic, strong) CLLocationManager *lm;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong)UITableView *searchTableView;

@property (nonatomic, strong) AMapSearchAPI *search;
//大头针类型
@property (nonatomic, assign) daTouZhenType *datouzhenType;
//纪录当前工人类型
@property (nonatomic, strong) NSString *gongRenLeiXing;

#define kCalloutViewMargin          -8

@end

@implementation MainViewController

-(NSMutableArray *)anncoationArray
{
    if (_anncoationArray == nil) {
        _anncoationArray = [NSMutableArray array];
    }
    return _anncoationArray;
}

-(NSMutableArray *)tips
{
    if (_tips == nil) {
        _tips = [NSMutableArray array];
    }
    return _tips;
}

-(UITableView *)searchTableView
{
    if (_searchTableView == nil) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(searchView.x, searchView.y+searchView.height+10, searchView.width, 200)];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
    }
    return _searchTableView;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
   window = [[UIApplication sharedApplication] keyWindow];
    
    //选择身份
    [self SelectViewType];
    //刷新地图
    if (self.mapView) {
        if (GetUserDefaultsGR) {
            
            if ([self.gongRenLeiXing isEqualToString: @"79"]) {
                _mapView.showsUserLocation = YES;
            }
            self.gongRenLeiXing = @"78";
            
        }else
        {
            if ([self.gongRenLeiXing isEqualToString: @"78"]) {
                _mapView.showsUserLocation = YES;
            }
            self.gongRenLeiXing = @"79";
        }
        
    }
    
}

#pragma mark 根据身份选择对应页面

-(void)SelectViewType
{
    if(GetUserDefaultsGR)
    {
        [self.firstBtn setTitle:@"抢单" forState:(UIControlStateNormal)];
        [self.myBtn setTitle:@"我的" forState:(UIControlStateNormal)];
        [self.orderBtn setTitle:@"订单" forState:(UIControlStateNormal)];
        
    }else
    {
        [self.firstBtn setTitle:@"找工人" forState:(UIControlStateNormal)];
        [self.myBtn setTitle:@"我的" forState:(UIControlStateNormal)];
        [self.orderBtn setTitle:@"订单" forState:(UIControlStateNormal)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //未登陆选择身份
    [self SelectShenFen];
    
    //极光推送
    [self jiGuangTuiSong];
    
    YuYinShibie = NO;
    
    //导航栏  菜单按钮view
    [self updateNav];
    //添加搜索框
    [self addSearchView];
    [self YuYinResign];
    //高德地图
    [self initMapView];
    [self initSearch];
   //[self addAction];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:21],
       NSForegroundColorAttributeName:[UIColor redColor]}];
    
    AnnCount =0;
}
#pragma mark 未登陆选择身份
-(void)SelectShenFen
{
    
    __weak typeof (self)weakSelf = self;
    ADAccount *account = [ADAccountTool account];
    if(!account)
    {
        Select_ID *select = [Select_ID loadView];
        select.selectShenFen=^()
        {
            [weakSelf SelectViewType];
        };
        //说明第一次登陆身份
        select.ifFirstLogin = YES;
        
        select.frame = [UIApplication sharedApplication].keyWindow.bounds;
        
       [[UIApplication sharedApplication].keyWindow addSubview:select];
    }
    
}

- (void)initMapView
{
    
   // self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
   // self.mapView = [[MAMapView alloc] init];
   // self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
    self.search = [[AMapSearchAPI alloc] init];
    
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    
    [_mapView setZoomLevel:12 animated:YES];

    [self.view insertSubview:_mapView atIndex:0];
    
   // [self addAnnotationWithCooordinate:self.mapView.centerCoordinate];
    
}
/* 初始化search. */
- (void)initSearch
{
    self.search.delegate = self;
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    //显示工人
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CusAnnotationView *annotationView = (CusAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CusAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:customReuseIndetifier];
        }
        if (self.datouzhenType == GongRentype) {
            annotationView.datouzhentype = 1;
        }
        else
        {
            annotationView.datouzhentype = 2;
        }
        // must set to NO, so we can show the custom callout view.
        annotationView.canShowCallout   = NO;
        annotationView.TypeGongRen = @"油工";
        annotationView.backgroundColor = [UIColor clearColor];
        
        return annotationView;
    }
    
    else if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MANaviAnnotationView *poiAnnotationView = (MANaviAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MANaviAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:invertGeoIdentifier];
        }
        poiAnnotationView.animatesDrop   = YES;
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.draggable      = YES;
        
        //show detail by right callout accessory view.
        //poiAnnotationView.rightCalloutAccessoryView     = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        poiAnnotationView.rightCalloutAccessoryView.tag = 1;
        
        //call online navi by left accessory.
        poiAnnotationView.leftCalloutAccessoryView.tag  = 2;
        
        return poiAnnotationView;

    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    [self clear];
    
    //坐标
    CLLocationCoordinate2D coord2D = userLocation.location.coordinate;
    
    NSString *lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    
    NSLog(@"%@",lon);
    NSLog(@"%@",lat);
    
    //保存经纬度
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"lon"];
    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"lat"];
    
    
    //标注我的位置
    [self.mapView setCenterCoordinate:coord2D];
    
    ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc]init];
    reGeocodeAnnotation.coordinate = coord2D;
    reGeocodeAnnotation.title = @"我的位置";
    [self.mapView addAnnotation:reGeocodeAnnotation];
    
    //上传经纬度
    [self uploadLocation:lat lon:lon];
    
    //显示大头针
    if (GetUserDefaultsGZ) {
    self.datouzhenType = GuZhutype;
        [self searchGonRen_gz:lat lon:lon];
        
    }else if(GetUserDefaultsGR)
    {
        
      self.datouzhenType = GongRentype;
        [self searchGuZhu_gr:lat lon:lon];
    }

    _mapView.showsUserLocation = NO;
    
    //[self fujin:lon lat:lat];

    
}

#pragma mark - Action Handle

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CusAnnotationView class]]) {
        CusAnnotationView *cusView = (CusAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint screenAnchor = [self.mapView getMapStatus].screenAnchor;
            CGPoint theCenter = CGPointMake(self.mapView.bounds.size.width * screenAnchor.x, self.mapView.bounds.size.height * screenAnchor.y);
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}


- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}


-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = @"AutoNavi";
    annotation.subtitle = @"CustomAnnotationView";
    
    [self.mapView addAnnotation:annotation];
}

- (CGPoint)randomPoint
{
    CGPoint randomPoint = CGPointZero;
    
    randomPoint.x = arc4random() % (int)(CGRectGetWidth(self.view.bounds));
    randomPoint.y = arc4random() % (int)(CGRectGetHeight(self.view.bounds));
    
//    NSLog(@"%f",randomPoint.x);
//    NSLog(@"%f",randomPoint.y);
    
    return randomPoint;
}


//随机添加大头针
- (void)addAction
{
    CLLocationCoordinate2D randomCoordinate = [self.mapView convertPoint:[self randomPoint] toCoordinateFromView:self.view];
    
    [self addAnnotationWithCooordinate:randomCoordinate];
}

// 初始化
-(void)YuYinResign
{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"569e5130"];
    [IFlySpeechUtility createUtility:initString];
}


#pragma mark 添加搜索框
-(void)addSearchView
{
    searchView = [MySearch item];
    searchView.x = 10;
    searchView.y = 84;
    searchView.width = kU-20;
    searchView.height = 50;
    
    searchView.layer.cornerRadius = 5;
    searchView.clipsToBounds = YES;
    
    searchView.layer.borderWidth = 1;
    searchView.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2]CGColor];
    
    //[searchView SearchAddTarget:self action:@selector(Search)];
    [searchView YuYinAddTarget:self action:@selector(YuYin)];
    searchView.textFiled.delegate = self;
    
    //searchView.height = 10;
    
    //searchView.frame = CGRectMake(0, 0, 320, 100);
    [self.view addSubview:searchView];
    
}
#pragma mark 导航栏
-(void)updateNav
{
//    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
//    lab.backgroundColor = [UIColor redColor];
//    lab.text = @"小木匠";
//    lab.textColor = [UIColor blueColor];
//    lab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16];
//    lab.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = lab;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
    imageV.image = [UIImage imageNamed:@"亿装修@2x"];
//    
     self.navigationItem.titleView = imageV;
    
    //设置下面按钮界面
    self.BottomMenuView.layer.cornerRadius = 5;
    self.BottomMenuView.clipsToBounds = YES;
    
    self.BottomMenuView.layer.borderWidth = 1;
    self.BottomMenuView.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]CGColor];
    
    
}

#pragma mark textFiledd代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",string);
    
    NSString *AllStr = [searchView.textFiled.text stringByAppendingString:string];
    
    NSLog(@"%@",searchView.textFiled.text);
    
    //此处判断输入框为空的情况
    if (searchView.textFiled.text.length ==1 && string.length == 0) {
        
        [self ClearSearchtableView];
    }else
    {
       [self searchTipsWithKey:AllStr];
    }
    
    return YES;
}


//输入关键字搜索
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = @"北京";
    
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - AMapSearchDelegate
/* 输入提示回调. */
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    //NSLog(@"%ld",self.tips.count);
    [self CreatSearchtableView];
}

//创建搜索提示View
-(void)CreatSearchtableView
{
    if (!_searchTableView) {
        
        [self.view addSubview:self.searchTableView];
    }
    [self.searchTableView reloadData];
}
//清楚View
-(void)ClearSearchtableView
{
    [_searchTableView removeFromSuperview];
    _searchTableView.delegate = nil;
    _searchTableView.dataSource = nil;
    _searchTableView = nil;
    
    
}
#pragma mark  搜索提示tableView  Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
        //cell.imageView.image = [UIImage imageNamed:@"locate"];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
//    if (tip.location == nil)
//    {
//        cell.imageView.image = [UIImage imageNamed:@"search"];
//    }
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.district;
    
    return cell;
}
#pragma mark 点击搜索地点
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
   // [self.displayController setActive:NO animated:NO];
    
    searchView.textFiled.text = tip.name;
    [self ClearSearchtableView];
    [self clearAndShowAnnotationWithTip:tip];
    
    //保存到本地
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@%@",tip.district,tip.name] forKey:@"position"];
    
   // self.searchBar.placeholder = tip.name;
}

- (void)clearAndShowAnnotationWithTip:(AMapTip *)tip
{
    
//    [[NSUserDefaults standardUserDefaults]setObject:@"78" forKey:@"shenfentype"];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:@"79" forKey:@"shenfentype"];
//    
//    
//    [[[NSUserDefaults standardUserDefaults]objectForKey:@"shenfentype"]isEqualToString:@"78"];
//    [[[NSUserDefaults standardUserDefaults]objectForKey:@"shenfentype"]isEqualToString:@"79"];
    
    
    /* 清除annotations & overlays */
    [self clear];
    
    if (tip.uid != nil && tip.location != nil) /* 可以直接在地图打点  */
    {
//        AMapTipAnnotation *annotation = [[AMapTipAnnotation alloc] initWithMapTip:tip];
//        [self.mapView setCenterCoordinate:annotation.coordinate];
//        [self.mapView selectAnnotation:annotation animated:YES];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        [self.mapView setCenterCoordinate:coordinate];
        
        
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc]init];
        reGeocodeAnnotation.coordinate = coordinate;
        reGeocodeAnnotation.title = tip.name;
        reGeocodeAnnotation.subtitle = tip.district;
        
        [self.mapView addAnnotation:reGeocodeAnnotation];
        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];
       // self.mapView.zoomLevel = 10;
        [self.mapView setZoomLevel:15 animated:YES];
        
        
        //雇主端搜索工人/
        if (GetUserDefaultsGZ) {
            self.datouzhenType = GongRentype;
            [self searchGonRen_gz:[NSString stringWithFormat:@"%f",tip.location.latitude] lon:[NSString stringWithFormat:@"%f",tip.location.longitude]];
        }else if(GetUserDefaultsGR)
        {
            self.datouzhenType = GuZhutype;
            [self searchGuZhu_gr:[NSString stringWithFormat:@"%f",tip.location.latitude] lon:[NSString stringWithFormat:@"%f",tip.location.longitude]];
        }
        
        //[self addAction];
        //反地理编码
        //[self searchReGeocodeWithCoordinate:coordinate];

    }
}

#pragma mark 反地理编码
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark 反地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        
        self.reGeocode = response.regeocode;
        self.coordinate = coordinate;
        self.titles = [NSString stringWithFormat:@"%@%@%@%@",
                      self.reGeocode.addressComponent.province?: @"",
                      self.reGeocode.addressComponent.city ?: @"",
                      self.reGeocode.addressComponent.district?: @"",
                      self.reGeocode.addressComponent.township?: @""];
        self.subtitle = [NSString stringWithFormat:@"%@%@",
                         self.reGeocode.addressComponent.neighborhood?: @"",
                         self.reGeocode.addressComponent.building?: @""];
        
        NSLog(@"%@",self.titles);
        NSLog(@"%@",self.subtitle);
        
        
    }
}


#pragma mark 地理编码
-(void)tapAction:(NSString *)didian
{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = didian;
    
    [self.search AMapGeocodeSearch:geo];
}

#pragma mark - 地理编码回调 AMapSearchDelegate

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        AMapGeoPoint *coor2D = obj.location;
        [annotations addObject:coor2D];
    }];
    
     AMapGeoPoint *coor2D = annotations[0];
    NSLog(@"%f",coor2D.latitude);
    NSLog(@"%f",coor2D.longitude);
    
    NSString *lat = [NSString stringWithFormat:@"%lf",coor2D.latitude];
     NSString *lng = [NSString stringWithFormat:@"%lf",coor2D.longitude];
    
    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"gongchengdidianlat"];
    [[NSUserDefaults standardUserDefaults]setObject:lng forKey:@"gongchengdidianlng"];

}

/* 清除annotations */
-(void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}


// 抢单
//1属于工人,0属于雇主
#pragma mark找工人 抢单
- (IBAction)grabASingle:(UIButton *)sender {
    
    
    __weak typeof (self)weakSelf =self;
    //工人抢单
    if (GetUserDefaultsGR)
    {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"workerRob" bundle:nil];
        UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"workerRob"];
        [self.navigationController pushViewController:test2obj animated:YES];
    }else
    {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"employersLooking" bundle:nil];
        employersLookingViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"employersLooking"];
        
        //block 地点
        test2obj.diLiBianMa = ^(NSString *diDian)
        {
            [weakSelf tapAction:diDian];
        };
        
        [self.navigationController pushViewController:test2obj animated:YES];
    }
}

#pragma mark 订单
- (IBAction)theOrder:(UIButton *)sender {
    
    //[self IfLogin];
    
    ADAccount *account = [ADAccountTool account];
    if (!account) {
        My_Login_In_ViewController *login = [[My_Login_In_ViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
   // if ([self.userStatus isEqualToString:@"0"]) {
    
    if (GetUserDefaultsGZ) {
        
        DWOrderViewController *dwOrderVc = [[DWOrderViewController alloc] initWithNibName:@"DWOrderViewController" bundle:nil];
        [self.navigationController pushViewController:dwOrderVc animated:YES];
        
    }else
    {
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"workerOrder" bundle:nil];
        UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"workerOrder"];
        [self.navigationController pushViewController:test2obj animated:YES];
}
   
}
#pragma mark 外界通过此方法跳转
-(void)setPushOrder:(BOOL)pushOrder
{
    _pushOrder = pushOrder;
    if (pushOrder) {
        [self theOrder:nil];
    }
}
#pragma mark 我的
- (IBAction)myList:(UIButton *)sender {
    
    //
    //[self IfLogin];
    ADAccount *account = [ADAccountTool account];
    if (!account) {
        
        My_Login_In_ViewController *Login = [[My_Login_In_ViewController alloc]init];
        
        [self.navigationController pushViewController:Login animated:YES];
        return;
    }
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"employersInMy" bundle:nil];
    
    UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"employersInMy"];
    [self.navigationController pushViewController:test2obj animated:YES];
}


//点击空白
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [searchView.textFiled resignFirstResponder];
    
    if (_searchTableView!=nil) {
        [_searchTableView removeFromSuperview];
        _searchTableView  = nil;
        
    }
    
}

#pragma mark 是否登陆
-(void)IfLogin
{
    ADAccount *acount = [ADAccountTool account];
        if (! acount.userid) {
    
            //初始化一个弹框控制器（标题部分）
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"需要登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            //取消按钮
            UIAlertAction * cancel=[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
    
            //确定按钮（在block里面执行要做的动作）
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
                        My_Login_In_ViewController *login = [[My_Login_In_ViewController alloc]init];
                
                [self.navigationController pushViewController:login animated:YES];
                
//                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
//                        window.rootViewController = nav;
            }];
    
            //把动作添加到控制器
            [alertController addAction:cancel];
            [alertController addAction:sure];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
            
            return;
            
        }
}


#pragma mark sugue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender

{
    if ([identifier isEqualToString:@"xiaoxi"] || [identifier isEqualToString:@"libao"]) {
        
        ADAccount *account = [ADAccountTool account];
        
        if (!account) {
            
            My_Login_In_ViewController *login = [[My_Login_In_ViewController alloc]init];
            
            [self.navigationController pushViewController:login animated:YES];
            
            return NO;
        }
            //[self IfLogin];
    }
    
    return YES;//执行跳转方法
    
}

#pragma mark  上传经纬度
-(void)uploadLocation:(NSString *) lat lon:(NSString *)lon
{
    
    ADAccount *account = [ADAccountTool account];
    if (!account) {
        return;
    }
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:account.userid forKey:@"userid"];
    [parms setObject:account.token forKey:@"token"];
    [parms setObject:lat forKey:@"lat"];
    [parms setObject:lon forKey:@"lng"];
    
    NSLog(@"%@",parms);
    [NetWork postNoParmForMap:YZX_shangchuanjingweidu params:parms success:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark 雇主段搜索工人
-(void)searchGonRen_gz:(NSString *)lat lon:(NSString *)lon
{
    
    ADAccount *account = [ADAccountTool account];
    if (!account) {
        return;
    }
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    
    [parms setObject:account.userid forKey:@"userid"];
    [parms setObject:account.token forKey:@"token"];
    [parms setObject:lat forKey:@"lat"];
    [parms setObject:lon forKey:@"lng"];
    
    NSLog(@"%@",parms);
    [NetWork postNoParmForMap:YZX_search_gz params:parms success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        
        for (int i = 0; i<3; i++) {
            [self addAction];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 工人端搜索雇主
-(void)searchGuZhu_gr:(NSString *)lat lon:(NSString *)lon
{
    
    ADAccount *account = [ADAccountTool account];
    if (!account) {
        return;
    }
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    
    [parms setObject:account.userid forKey:@"userid"];
    [parms setObject:account.token forKey:@"token"];
    [parms setObject:lat forKey:@"lat"];
    [parms setObject:lon forKey:@"lng"];
    
    NSLog(@"%@",parms);
    [NetWork postNoParmForMap:YZX_search_gr params:parms success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        
        for (int i = 0; i<3; i++) {
            [self addAction];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark 推送相关
//******************************************推送相关******************************************
//极光推送
-(void)jiGuangTuiSong
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}


- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接");
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    
    if ([APService registrationID]) {
        NSLog(@"get RegistrationID");
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message: content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    if (buttonIndex == 0 ) {
        NSLog(@"123");
        
    }else if (buttonIndex == 1 )
    {
        NSLog(@"456");
    }
    
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


#pragma mark 语音相关
//****************************************************语音相关************************************
//语音按钮
-(void)YuYin
{
    YuYinShibie = !YuYinShibie;
    
    if (YuYinShibie == YES) {
        
        [searchView.YuYin setImage:[UIImage imageNamed:@"讲话"] forState:UIControlStateNormal];
        
        if(iFlySpeechRecognizer == nil)
        {
            [self initRecognizer];
        }
        
        [iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [iFlySpeechRecognizer startListening];
        
        if (ret) {
            NSLog(@"－－－－－－－－－－－－识别中---------");
        }else{
            NSLog(@"－－－－－－－－－－－－识别错误---------");
            //[popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        }
        
    }else
    {
        [searchView.YuYin setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        [iFlySpeechRecognizer stopListening];
    }
}

//语音
-(void)initRecognizer
{
    if (iFlySpeechRecognizer == nil) {
        iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    iFlySpeechRecognizer.delegate = self;
    
    if (iFlySpeechRecognizer != nil) {
        
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
        [iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT_NODOT]];
        
    }
    
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    // [_popUpView showText: @"正在录音"];
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    //[_popUpView showText: @"停止录音"];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"%@",error);
    
    
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSLog(@"%@",results);
    
    //_result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    
    if (isLast){
        
        NSLog(@"听写结果(json)：%@测试", resultFromJson);
        
    }else
    {
        NSLog(@"resultFromJson=%@",resultFromJson);
        searchView.textFiled.text = resultFromJson;
        [searchView.YuYin setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        [iFlySpeechRecognizer stopListening];
        //搜索
       // [self Search];
    }
}
/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void) showPopup
{
    // [_popUpView showText: @"正在上传..."];
}



@end
