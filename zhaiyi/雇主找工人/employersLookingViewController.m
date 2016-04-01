//
//  employersLookingViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "employersLookingViewController.h"
#import "SZCalendarPicker.h"
#import <CoreLocation/CoreLocation.h>
#import "My_pocket_recharge_Controller.h"
#import "NSDate+ITTAdditions.h"

//#define ZhaoGongRen @"http://drf.unioncloud.com:10094/drf/datagateway/drfrestservice/ExecuteFunction"

@interface employersLookingViewController () <CLLocationManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *employerIdentityView;

@property (weak, nonatomic) IBOutlet UILabel *moenyLabel;
@property (assign,nonatomic)NSInteger isInsure;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (strong,nonatomic)SZCalendarPicker *calendarPicker;

@property (weak, nonatomic) IBOutlet UILabel *starTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *sureView;


//保险
@property (weak, nonatomic) IBOutlet UILabel *BaoXIanMoney;
//开工日期
@property (weak, nonatomic) IBOutlet UILabel *StarTimeLb;
//竣工日期
@property (weak, nonatomic) IBOutlet UILabel *EndTimeLb;
//工程地点
@property (weak, nonatomic) IBOutlet UITextField *GongChengDiDian;
//工程内容
@property (weak, nonatomic) IBOutlet UITextField *GongZuoNeiRong;
//需求人数
@property (weak, nonatomic) IBOutlet UITextField *XuQiuRenShu;
//联系人
@property (weak, nonatomic) IBOutlet UITextField *LianXIRen;
//联系电话
@property (weak, nonatomic) IBOutlet UITextField *LianXiDianHua;
//备注
@property (weak, nonatomic) IBOutlet UITextField *BeiZhu;

//是否需要保险
@property (nonatomic,assign) NSString *isNeedBaoXian;

//分类按钮父视图
@property (weak, nonatomic) IBOutlet UIView *FenLeiSuperView;

//分类数据源
@property (nonatomic, strong) NSMutableArray *dataSourceFenLei;

//工种分类ID
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *GongZhongType;

@property (nonatomic, strong) UILabel *SelectLabel;
//天数
@property (weak, nonatomic) IBOutlet UIButton *dayNum;
@property (copy, nonatomic) NSString  *peopleCount;

//保险费
@property (weak, nonatomic) IBOutlet UITextField *baoxianFei;


@property (strong, nonatomic) IBOutlet UIView *FatherView;

//总费用
@property (assign, nonatomic) float amountCost;
//需要钱数
@property (assign, nonatomic) float needCost;



@property (weak, nonatomic) IBOutlet UIScrollView *ScrrolView;


@property (nonatomic, strong)UITextField *TextFiled;


/////////////////////////确认订单信息界面///////
@property (weak, nonatomic) IBOutlet UILabel *TopGongzhong;

@property (weak, nonatomic) IBOutlet UILabel *topRenShu;
@property (weak, nonatomic) IBOutlet UILabel *topKaiGongRiQi;
@property (weak, nonatomic) IBOutlet UILabel *topJunGongRiqi;
@property (weak, nonatomic) IBOutlet UILabel *TopYongGongTianShu;
@property (weak, nonatomic) IBOutlet UILabel *TopDanRiGongzi;
@property (weak, nonatomic) IBOutlet UILabel *TopBaoXianFeie;
@property (weak, nonatomic) IBOutlet UILabel *TopGongZuoNeiRong;
@property (weak, nonatomic) IBOutlet UILabel *topGongZuoDiDian;

@property (strong, nonatomic) UIView *shadowView;

//
@property (strong, nonatomic) NSMutableDictionary *params;
//帐号信息
@property (strong, nonatomic) ADAccount *account;

//确定或者充值按钮
@property (weak, nonatomic) IBOutlet UIButton *queDingOrChongZhi;

- (IBAction)TopBack:(id)sender;

- (IBAction)TopQueDing:(id)sender;


- (IBAction)TouchUp:(id)sender;

@end

@implementation employersLookingViewController

//懒加载
-(NSMutableArray *)dataSourceFenLei
{
    if (!_dataSourceFenLei) {
        _dataSourceFenLei = [NSMutableArray array];
    }
    return  _dataSourceFenLei;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找工人";
    //设置title颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:21],
       NSForegroundColorAttributeName:[UIColor redColor]}];

    self.automaticallyAdjustsScrollViewInsets = NO;
    _isInsure = 30;
    _params = [NSMutableDictionary dictionary];
    _isNeedBaoXian = @"1";
    _GongZhongType = @"泥工";
    _peopleCount = @"";
    _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kU, Ga)];
    _shadowView.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.6];
    
    _GongChengDiDian.text =[[NSUserDefaults standardUserDefaults]objectForKey:@"placemark"];

    [self netWork];
    self.ScrrolView.userInteractionEnabled = YES;
    
    self.LianXIRen.delegate = self;
    self.LianXiDianHua.delegate = self;
    self.BeiZhu.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_shadowView removeFromSuperview];
    _account = [ADAccountTool account];
    
    [self refreshMoney];
}


//开工/竣工日期
- (IBAction)calendarAction:(id)sender {
    UIButton *butt = sender;
    NSInteger tag1 = butt.tag;
    _calendarPicker = [SZCalendarPicker showOnView:self.view];
    _calendarPicker.today = [NSDate date];
    _calendarPicker.date = _calendarPicker.today;
    _calendarPicker.frame = CGRectMake(20, 140, self.view.frame.size.width-40, 400);
    
    
    switch (tag1) {
            
            //开工
        case 21:{
            __weak typeof(self) weakSelf = self;
            _calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
                
                NSString *dateStr =[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
                
                NSDate *selectDate = [NSDate dateWithString:dateStr formate:@"yyyy-MM-dd"];
                NSDate *nowDate = [NSDate date];
                
                if (([nowDate timeIntervalSince1970]*1 - [selectDate timeIntervalSince1970]*1)>=0) {
                    [ITTPromptView showMessage:@"日期不合法"];
                    return ;
                }else
                {
                    weakSelf.starTimeLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
                }

                //NSLog(@"123");
                if (weakSelf.starTimeLabel.text.length && weakSelf.endTimeLabel.text.length) {
                    
                    NSString *day = [NSString numberOfDays1:weakSelf.starTimeLabel.text numberOfDays2:weakSelf.endTimeLabel.text timeStringFormat:@"yyyy-MM-dd"];
                      [weakSelf.dayNum setTitle:day forState:UIControlStateNormal];
                }
            };
        }
            
            break;
            //
        case 22:{
            __weak typeof(self) weakSelf = self;
            _calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
                //NSLog(@"456");
                NSString *dateStr =[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
                NSDate *selectDate = [NSDate dateWithString:dateStr formate:@"yyyy-MM-dd"];
                NSDate *nowDate = [NSDate date];
                
                if (([nowDate timeIntervalSince1970]*1 - [selectDate timeIntervalSince1970]*1)>=0) {
                    [ITTPromptView showMessage:@"日期不合法"];
                    return ;
                }else
                {
                    weakSelf.endTimeLabel.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
                }
                
                
                if (weakSelf.starTimeLabel.text.length && weakSelf.endTimeLabel.text.length) {
                    
                    NSString *day = [NSString numberOfDays1:weakSelf.starTimeLabel.text numberOfDays2:weakSelf.endTimeLabel.text timeStringFormat:@"yyyy-MM-dd"];
                    
                    NSString *dayP = [NSString stringWithFormat:@"%d",[day integerValue]+1];
                    
                    [weakSelf.dayNum setTitle:dayP forState:UIControlStateNormal];
                }
            };
        }
            break;
        default:
            break;
    }
}

- (IBAction)addOrSubMoney:(id)sender {
    
    UIButton *button = sender;
    NSInteger number = [_moenyLabel.text intValue];
    if (button.tag == 20) {
        number = number +5;
    }else{
        number = number -5;
    }
    _moenyLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
    
}

#pragma mark 是否购买保险
- (IBAction)isOrNoAction:(id)sender {
    
     UIButton *button = sender;
    if (30 == button.tag) {
        
        self.isNeedBaoXian=@"1";
        
        [_yesButton setImage:[UIImage imageNamed:@"找工人5"] forState:(UIControlStateNormal)];
        [_noButton setImage:nil forState:(UIControlStateNormal)];
        
        self.baoxianFei.text = @"100";
        
    }else{
        
        self.isNeedBaoXian=@"0";
        
        [_noButton setImage:[[UIImage imageNamed:@"找工人5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
        [_yesButton setImage:nil forState:(UIControlStateNormal)];
        self.baoxianFei.text = @"0";
    }
}


//发布
- (IBAction)commintAction:(id)sender {
    
    self.sureView.hidden = NO;
    //判断按钮状态
    [self SelectBtn:_queDingOrChongZhi];
    //余额不足提示
    self.TopGongzhong.text = [NSString stringWithFormat:@"工种:%@",_SelectLabel.text];
    self.topRenShu.text = [NSString stringWithFormat:@"人数:%@人",_XuQiuRenShu.text];
    self.topKaiGongRiQi.text = [NSString stringWithFormat:@"开工日期:%@",_starTimeLabel.text];
        
    self.topJunGongRiqi.text = [NSString stringWithFormat:@"竣工日期:%@",_endTimeLabel.text];
        
    self.TopYongGongTianShu.text = [NSString stringWithFormat:@"用工天数:%@天",self.dayNum.titleLabel.text];
        
    self.TopDanRiGongzi.text = self.moenyLabel.text;
        
        //self.TopBaoXianFeie.text = self.BaoXIanMoney.text;
        
    self.TopBaoXianFeie.text = @"0";
        
    self.TopGongZuoNeiRong.text = [NSString stringWithFormat:@"工作内容:%@",self.GongZuoNeiRong.text];
        
    self.topGongZuoDiDian.text = self.GongChengDiDian.text;
    
}

#pragma mark 判断充值还是确定
-(void)SelectBtn:(id)sender
{
    UIButton *button = (UIButton *)sender;
    ADAccount *account = [ADAccountTool account];
    
    int renshu = [self.XuQiuRenShu.text intValue];
    if (renshu > 5 ) {
        //人数 * 钱数 * 天数 + 保险 *人数
        int costCount = [self.XuQiuRenShu.text intValue]*([self.moenyLabel.text intValue]*[self.dayNum.titleLabel.text intValue]+ [self.baoxianFei.text intValue]);
        _amountCost = costCount *0.2;
        NSLog(@"总额:%f !!! %f 现有:%@",_amountCost,_needCost,account.recharge_money);
        
        if (_amountCost > [account.recharge_money intValue]) {
            [button setTitle:@"充值" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(toVC:) forControlEvents:(UIControlEventTouchUpInside)];
            
        } else {
            NSString *amount = [NSString stringWithFormat:@"%f",_amountCost];
            [_params setObject:amount forKey:@"total_money"];
            
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(TopQueDing:) forControlEvents:(UIControlEventTouchUpInside)];
            
        }
        
    } else {
        NSLog(@"不需要扣钱");
        [_params setObject:@"0.0" forKey:@"total_money"];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(TopQueDing:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }

    
}

#pragma mark 点击确定 发布
//提示框返回
- (IBAction)TopBack:(id)sender {
    
    _sureView.hidden = YES;
    
}

//提示框确认 发布
- (void)TopQueDing:(id)sender {
    
    //发布
    [self netWorkFaBu];
    
    //_sureView.hidden = YES;
}


- (IBAction)TouchUp:(id)sender {
    
    //NSLog(@"123");
    for (UITextField *text in self.FatherView.subviews) {
        
        [text resignFirstResponder];
    }
    
    [self.FatherView endEditing:YES];
}


#pragma mark 判断余额 是否需要充值
-(BOOL)YuEe
{
    
    ADAccount *account = [ADAccountTool account];

    int renshu = [self.XuQiuRenShu.text intValue];
    if (renshu > 5 ) {
        
        //人数 * 钱数 * 天数 + 保险 *人数
        int costCount = [self.XuQiuRenShu.text intValue]*([self.moenyLabel.text intValue]*[self.dayNum.titleLabel.text intValue]+ [self.baoxianFei.text intValue]);
        _amountCost = costCount *0.2;
        NSLog(@"总额:%f !!! %f 现有:%@",_amountCost,_needCost,account.recharge_money);
        
        if (_amountCost > [account.recharge_money intValue]) {
            UIView *view1 = [[UIView alloc]initWithFrame:(CGRectMake(40, self.view.frame.size.height/2-100, self.view.frame.size.width-80, 140))];
            view1.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view1];
            
            UILabel *abel = [[UILabel alloc]initWithFrame:(CGRectMake(20, 10, view1.frame.size.width-40, 60))];
            [view1 addSubview:abel];
            abel.text = @"账户余额不足,请立即前往钱包充值";
            abel.numberOfLines = 0;
            abel.textAlignment = NSTextAlignmentCenter;
            UIButton *button = [[UIButton alloc]initWithFrame:(CGRectMake(view1.frame.size.width/2-40, view1.frame.size.height-50, 80, 30))];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [button setTitle:@"前往" forState:(UIControlStateNormal)];
            [button setBackgroundImage:[UIImage imageNamed:@"充值anniu"] forState:(UIControlStateNormal)];
            
            [button addTarget:self action:@selector(toVC:) forControlEvents:(UIControlEventTouchUpInside)];
            [view1 addSubview:button];
            
            [self.view insertSubview:_shadowView belowSubview:view1];
            
            return NO;
        } else {
            NSString *amount = [NSString stringWithFormat:@"%f",_amountCost];
            [_params setObject:amount forKey:@"total_money"];
            return YES;
        }
    
    } else {
        NSLog(@"不需要扣钱");
        [_params setObject:@"0.0" forKey:@"total_money"];
        return YES;
       
    }
 
}

- (void)toVC:(UIButton *)button{
    
//    UIView *view2 = [button superview];
//    [view2 removeFromSuperview];
    _sureView.hidden = YES;
    
    My_pocket_recharge_Controller *rechargeController = [[My_pocket_recharge_Controller alloc]init];
    [self.navigationController pushViewController:rechargeController animated:YES];
    
    
}

#pragma mark 工人类型选择
- (IBAction)chageEmployersIdentity:(id)sender {
    UIButton *choosenBut = sender;
    choosenBut.backgroundColor = [UIColor whiteColor];
    for (UIButton *butt in [_employerIdentityView subviews]) {
        if (butt.tag != choosenBut.tag) {
            butt.backgroundColor = [UIColor clearColor];
            [butt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        }
    }
    
//    switch (choosenBut.tag) {
//        case 10:
//            self.moenyLabel.text = @"260";
//            break;
//        case 11:
//            self.moenyLabel.text = @"300";
//            break;
//        case 12:
//            self.moenyLabel.text = @"320";
//            break;
//        case 13:
//            self.moenyLabel.text = @"330";
//            break;
//        case 14:
//            self.moenyLabel.text = @"400";
//            break;
//        case 15:
//            self.moenyLabel.text = @"420";
//            break;
//        default:
//            break;
//    }
}

-(void)UpdateFenLei
{
    int colNum = 3;
    int rowNum;
    if (self.dataSourceFenLei.count % colNum == 0) {
        rowNum = (int)(self.dataSourceFenLei.count / colNum);
    }else
    {
        rowNum = (int)(self.dataSourceFenLei.count / colNum) + 1;
    }
    NSLog(@"%d",rowNum);
    CGFloat squareWidth = 45;
    CGFloat squareHeight = 45;
    CGFloat colPan = 20;
    CGFloat rowpan = 10;
    //UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, squareHeight * rowNum)];
    for (int i = 0; i < self.dataSourceFenLei.count; i++) {
        int row = i / colNum;
        int col = i % colNum;
        
        UILabel *squareLab = [[UILabel alloc] initWithFrame:CGRectMake( colPan+squareWidth * col+((ScreenW-colPan*2-squareWidth*colNum)/(colNum-1))*col, rowpan+squareHeight * row+(rowpan *row), squareWidth, squareHeight)];
        squareLab.tag = [[self.dataSourceFenLei[i] objectForKey:@"id"] integerValue];
        
        // NSLog(@"%ld",squareLab.tag);
        squareLab.textAlignment = NSTextAlignmentCenter;
        squareLab.font = [UIFont systemFontOfSize:14];
        
        if (i == 0) {
            squareLab.backgroundColor = [UIColor whiteColor];
            _SelectLabel =squareLab;
            //切割成圆
            _SelectLabel.layer.cornerRadius = 22;
            _SelectLabel.clipsToBounds = YES;
            _classId =[NSString stringWithFormat:@"%ld",squareLab.tag];
        }else
        {
            squareLab.backgroundColor = [UIColor clearColor];
        }
        
        //后台返回null
        // NSString *str = [self.titleArr[i] objectForKey:@"title"];
        // NSLog(@"%@",str);
    
        squareLab.text = [self.dataSourceFenLei[i] objectForKey:@"typeName"];

        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HeaderClicked:)];
        squareLab.userInteractionEnabled = YES;
        [squareLab addGestureRecognizer:tap];
        [self.FenLeiSuperView addSubview:squareLab];
        
        //报销费额赋值
        NSInteger money = [[self.dataSourceFenLei[0] objectForKey:@"money"] integerValue];
        self.baoxianFei.text =[NSString stringWithFormat:@"%ld",money];
    }


}
#pragma mark 点击工种
- (void)HeaderClicked: (UITapGestureRecognizer *)gestureRecognizer
{
    _SelectLabel.backgroundColor = [UIColor clearColor];
    _SelectLabel.clipsToBounds = NO;
    _SelectLabel = (UILabel *)[gestureRecognizer view];
    _SelectLabel.backgroundColor = [UIColor whiteColor];
    _SelectLabel.layer.cornerRadius = 22;
    _SelectLabel.clipsToBounds = YES;
    
    self.classId = [NSString stringWithFormat:@"%ld",_SelectLabel.tag];
    self.GongZhongType = _SelectLabel.text;
    
    NSInteger money = [[self.dataSourceFenLei[_SelectLabel.tag -1] objectForKey:@"money"] integerValue];
   //self.baoxianFei.text =[NSString stringWithFormat:@"%ld",money];
    self.moenyLabel.text =[NSString stringWithFormat:@"%ld",money];

}

#pragma mark 工种分类接口
-(void)netWork
{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    ADAccount *acount = [ADAccountTool account];
    
    [parm setObject:acount.userid forKey:@"user_id"];
    
    NSLog(@"%@",parm);
    
    [NetWork postNoParm:GongZhongFenLei params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
        
     //   NSLog(@"%@",[responseObj objectForKey:@"data"] );
        
        self.dataSourceFenLei = [responseObj objectForKey:@"data"];
        
        NSLog(@"%@",self.dataSourceFenLei);
        
     //更新分类界面
      [self UpdateFenLei];
                }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
//    [NetWork post:ZhaoGongRen params:parm success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        if ([responseObj objectForKey:@"IsSuccess"]) {
//            
//            NSLog(@"%@",[responseObj objectForKey:@"Data"] );
//            
//            self.dataSourceFenLei = [[responseObj objectForKey:@"Data"] objectForKey:@"table0"];
//            
//            NSLog(@"%@",self.dataSourceFenLei);
//            
//            //更新分类界面
//            [self UpdateFenLei];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}


#pragma mark 发布接口
-(void)netWorkFaBu
{
    if([self.LianXIRen.text isEqualToString:@""])
    {
        [ITTPromptView showMessage:@"联系人不能为空"];
        return;
    }
    if ([self.LianXiDianHua.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"联系电话不能为空"];
    }
    if ([self.starTimeLabel.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"时间不能为空"];
    }
//    if ([self.endTimeLabel.text isEqualToString:@""]) {
//        [ITTPromptView showMessage:@"时间不能为空"];
//    }
    if ([self.XuQiuRenShu.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"需求人数不能为空"];
    }
    
    ADAccount *acount = [ADAccountTool account];
    //经纬度
    NSString *lon =[[NSUserDefaults standardUserDefaults]objectForKey:@"lon"];
    NSString *lat =[[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
    NSLog(@"%@",lon);
    NSLog(@"%@",lat);
    
//    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    //[parm setObject:@"发布需求" forKey:@"functionName"];
    [_params setObject:acount.userid forKey:@"user_id"];
    
    if ([self.GongZhongType isEqualToString:@"泥工"]) {
        
        [_params setObject:@"1" forKey:@"type"];//工种分类
        
    }else if ([self.GongZhongType isEqualToString:@"油工"])
    {
        [_params setObject:@"2" forKey:@"type"];//工种分类
    }else if ([self.GongZhongType isEqualToString:@"水工"])
    {
        [_params setObject:@"3" forKey:@"type"];//工种分类
    }else if ([self.GongZhongType isEqualToString:@" 电工"])
    {
        [_params setObject:@"4" forKey:@"type"];//工种分类
    }else if ([self.GongZhongType isEqualToString:@"木工"])
    {
        [_params setObject:@"5" forKey:@"type"];//工种分类
    }else if ([self.GongZhongType isEqualToString:@"小工"])
    {
        [_params setObject:@"6" forKey:@"type"];//工种分类
    }else
    {
        [_params setObject:@"1" forKey:@"type"];
    }
    
    [_params setObject:self.GongChengDiDian.text forKey:@"address"];//地址
    [_params setObject:self.GongZuoNeiRong.text forKey:@"content"];//工作内容
    [_params setObject:self.starTimeLabel.text forKey:@"startdate"];//开始时间
    [_params setObject:@"2016-05-01" forKey:@"enddate"];//结束时间
    [_params setObject:self.moenyLabel.text forKey:@"money"];//价格区间
    [_params setObject:@"1" forKey:@"is_safe"];//是否需要保险
    [_params setObject:@"200" forKey:@"safe_money"];//保险金额
    [_params setObject:self.LianXIRen.text forKey:@"name"];//联系人
    [_params setObject:self.LianXiDianHua.text forKey:@"phone"];//联系方式
    [_params setObject:self.BeiZhu.text forKey:@"descript"];//描述
    
    if ( lon ) {
        
     [_params setObject:lon forKey:@"lng"];//经度
     NSLog(@"%@",lon);
    }
    if (lat)
    {
        NSLog(@"%@",lat);
     [_params setObject:lat forKey:@"lat"];//纬度
    }
    
    [_params setObject:self.XuQiuRenShu.text forKey:@"number"];//需求人数
   
    NSLog(@"上传 %@",_params);
   
    [NetWork postNoParm:FaBuXuQiu params:_params success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"code"] isEqualToString:@"1000"]) {
            
            [ITTPromptView showMessage:@"发布成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"失败"];

        NSLog(@"%@",error);
        
    }];
    
}
//
- (IBAction)touchs:(id)sender {
    
//    
//    for (UITextField *text in self.FatherView.subviews) {
//        
//        [text resignFirstResponder];
//    }
    
    [self.FatherView endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _TextFiled = textField;
    
    //监听键盘
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"123");
}


//
-(void)keyboardShow:(NSNotification *)note
{
    NSLog(@"%@",note);
    
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.origin.y;
    NSLog( @"%lf",ScreenH);
    NSLog(@"%lf",self.TextFiled.y);
    NSLog(@"%lf",deltaY);
    
    // NSLog(@"%lf",self.TableView.y);
    
    NSLog(@"%lf",[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]);
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        NSLog(@"%lf",deltaY-(_TextFiled.y-self.ScrrolView.contentOffset.y+64+64+_TextFiled.height)+20);
        NSLog(@"%lf",deltaY);

        self.view.y = deltaY-(_TextFiled.y-self.ScrrolView.contentOffset.y+64+64+_TextFiled.height)+20;
       // self.view.y = deltaY-ScreenH+20;
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
//    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat deltaY=keyBoardRect.origin.y;
    
    // CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        //
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark 更新钱币
-(void)refreshMoney{
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:_account.type forKey:@"type"];
//    [params setObject:_account.userid forKey:@"user_id"];
//    [NetWork postNoParm:POST_REMAIN_MONEY params:params success:^(id responseObj) {
//        
//        NSLog(@"最新余额  %@",responseObj);
//
//        NSDictionary *dict = responseObj[@"data"];
//        _needCost  = [dict[@"recharge_money"] floatValue];
//        
//    } failure:^(NSError *error) {
//    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
