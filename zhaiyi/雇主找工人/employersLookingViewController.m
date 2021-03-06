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
#import "My_pocket_Pay_Controller.h"
#import "NSDate+ITTAdditions.h"
#import "My_Login_In_ViewController.h"
#import "ShuoMingViewController.h"
#import "MainViewController.h"

#import "CancleTiXing2.h"

#import "PersonalGuZhuController.h"

//#define ZhaoGongRen @"http://drf.unioncloud.com:10094/drf/datagateway/drfrestservice/ExecuteFunction"

@interface employersLookingViewController () <CLLocationManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *employerIdentityView;

@property (weak, nonatomic) IBOutlet UILabel *moenyLabel;
@property (assign,nonatomic)NSInteger isInsure;

@property (strong,nonatomic)SZCalendarPicker *calendarPicker;

@property (weak, nonatomic) IBOutlet UILabel *starTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *sureView;
@property (weak, nonatomic) IBOutlet UIButton *addMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceMoneyBtn;

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

//发布按钮
@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;

//分类按钮父视图
@property (weak, nonatomic) IBOutlet UIView *FenLeiSuperView;

//分类数据源
@property (nonatomic, strong) NSMutableArray *dataSourceFenLei;
//联系人
@property (nonatomic, strong)NSString *lianxiRen;
//联系电话
@property (nonatomic, strong)NSString *lianxiDianHua;
//重新发布数据源
@property (nonatomic, strong) NSMutableDictionary *dataSourceChongXinFaBu;

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
//质保金额
@property (weak, nonatomic) IBOutlet UILabel *zhiabaojin;
//联系电话
@property (weak, nonatomic) IBOutlet UILabel *lianxidianhua;
//联系人
@property (weak, nonatomic) IBOutlet UILabel *lianxiren;
//工种
@property (weak, nonatomic) IBOutlet UILabel *gongzhong;
//备注
@property (weak, nonatomic) IBOutlet UILabel *beizhu;
//天数
@property (weak, nonatomic) IBOutlet UITextField *tianshu;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrrolView;


@property (nonatomic, strong)UITextField *TextFiled;

//余额
@property (nonatomic, strong) NSString *Yue;
//支付金额／保证金
@property (nonatomic, strong) NSString *ZhiFuJinE;
//工人Id
@property (nonatomic, strong) NSString *Id;


//不能发单提醒
@property (nonatomic, strong)CancleTiXing2 *tixingView2;

/////////////////////////确认订单信息界面///////

@property (weak, nonatomic) IBOutlet UILabel *topKaiGongRiQi;
@property (weak, nonatomic) IBOutlet UILabel *TopYongGongTianShu;
@property (weak, nonatomic) IBOutlet UILabel *TopDanRiGongzi;
@property (weak, nonatomic) IBOutlet UILabel *TopGongZuoNeiRong;
@property (weak, nonatomic) IBOutlet UILabel *topGongZuoDiDian;

@property (strong, nonatomic) UIView *shadowView;

//遮盖
@property (strong, nonatomic) UIView *backView;

//
@property (strong, nonatomic) NSMutableDictionary *params;
//帐号信息
@property (strong, nonatomic) ADAccount *account;

//确定或者充值按钮
@property (weak, nonatomic) IBOutlet UIButton *queDingOrChongZhi;

- (IBAction)queDingChongZhi:(id)sender;

- (IBAction)TopBack:(id)sender;

- (IBAction)TouchUp:(id)sender;


- (IBAction)baoZhengJinShuoMing:(id)sender;

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


-(NSMutableDictionary *)dataSourceChongXinFaBu
{
    if (!_dataSourceChongXinFaBu) {
        _dataSourceChongXinFaBu = [NSMutableDictionary dictionary];
    }
    return _dataSourceChongXinFaBu;
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
    _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kU, Ga)];
    //_GongChengDiDian.text =[[NSUserDefaults standardUserDefaults]objectForKey:@"placemark"];
    
    _GongChengDiDian.text =[[NSUserDefaults standardUserDefaults]objectForKey:@"position"];
    
//    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@%@",tip.district,tip.name] forKey:@"position"];
    
    self.ScrrolView.userInteractionEnabled = YES;
    
    //登陆后的操作
        if (self.isChongXinFaBu) {
            
            [self chongxinfabu];
        }else
        {
            //工种分类接口
            [self netWork];
        }
    
    
    self.LianXIRen.delegate = self;
    self.LianXiDianHua.delegate = self;
    self.BeiZhu.delegate = self;
    self.GongChengDiDian.delegate = self;
    self.GongZuoNeiRong.delegate = self;
    self.XuQiuRenShu.delegate = self;
    self.tianshu.delegate = self;
    
    self.XuQiuRenShu.keyboardType = UIKeyboardTypeNumberPad;
    self.tianshu.keyboardType =UIKeyboardTypeNumberPad;
    self.LianXiDianHua.keyboardType =UIKeyboardTypeNumberPad;
    
    self.GongZuoNeiRong.tag = 101;
    self.XuQiuRenShu.tag = 102;
    self.tianshu.tag = 103;
    self.LianXiDianHua.tag = 104;
    
    //设置日期
    self.starTimeLabel.text = [NSDate stringWithNowData];
    
   //设置按钮
    self.fabuBtn.layer.cornerRadius = self.fabuBtn.height/2;
    self.fabuBtn.layer.masksToBounds = YES;
    //初始化地图搜索
    [self initSearch];
}

- (void)initSearch
{
    self.search.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.fabuBtn.enabled = YES;
    self.queDingOrChongZhi.enabled = YES;
}


//开工/竣工日期
- (IBAction)calendarAction:(id)sender {
    [self IfLogin];
    
    UIButton *butt = sender;
    NSInteger tag1 = butt.tag;
    _calendarPicker = [SZCalendarPicker showOnView:self.view];
    _calendarPicker.today = [NSDate date];
    _calendarPicker.date = _calendarPicker.today;
    _calendarPicker.frame = CGRectMake(20, 140, self.view.frame.size.width-40, ScreenH-200);
    
    switch (tag1) {
            
            //开工
        case 21:{
            __weak typeof(self) weakSelf = self;
            _calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
                
                NSString *dateStr =[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
                
                NSDate *selectDate = [NSDate dateWithString:dateStr formate:@"yyyy-MM-dd"];
                NSDate *nowDate = [NSDate date];
                
//                if (([nowDate timeIntervalSince1970]*1 - [selectDate timeIntervalSince1970]*1)>-1) {
                if ([NSDate numDayFromDate:selectDate]<=0) {
                    
                    //NSLog(@"%lf",([nowDate timeIntervalSince1970]*1 - [selectDate timeIntervalSince1970]*1));
                    [ITTPromptView showMessage:@"日期不合法"];
                    return ;
                }else if ([NSDate numDayFromDate:selectDate]>=3)
                {
                    [ITTPromptView showMessage:@"开工日期最晚为当前日期的后三天"];
                    return;
                   //NSLog(@"%ld",[NSDate numDayFromDate:selectDate]);
                }
                else
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

#pragma mark 钱数加减方法
- (IBAction)addOrSubMoney:(id)sender {

    [self IfLogin];
    
    UIButton *button = sender;
    NSInteger number = [_moenyLabel.text intValue];
    if (button.tag == 20) {
        number = number +5;
        
    }else{

        number = number -5;
        if (number<=0) {
            return;
        }
    }
    _moenyLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
    
}


#pragma mark 填写完毕发布按钮
- (IBAction)commintAction:(id)sender {
    
    self.queDingOrChongZhi.enabled = YES;
    //self.fabuBtn.enabled = NO;
    
    ADAccount *account = [ADAccountTool account];
    
    if (!account) {
        My_Login_In_ViewController *login = [[My_Login_In_ViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        
        return;
    }
    
    if ([self.GongChengDiDian.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入工程地点"];
        return;
    }
    if ([self.GongZuoNeiRong.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入工作内容"];
        return;
    }
    if ([self.XuQiuRenShu.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入需求人数"];
        return;
    }
    if ([self.tianshu.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入预计天数"];
        return;
    }
    if ([self.LianXIRen.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入联系人"];
        return;
    }
    if ([self.LianXiDianHua.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"请输入联系电话"];
        return;
    }
    
    //添加遮盖
    self.backView = [Function createBackView:self action:@selector(backClicked)];
    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1000);
    [self.ScrrolView insertSubview:self.backView belowSubview:self.sureView];
    
    if (self.diLiBianMa) {
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"gongchengdidianlat"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"gongchengdidianlat"];
    
//        NSLog(@"%@",self.topGongZuoDiDian.text);
//        NSLog(@"%@",self.GongChengDiDian.text);
        _diLiBianMa(self.GongChengDiDian.text);
    }
    
    self.sureView.hidden = NO;
    //判断按钮状态
    //[self SelectBtn:_queDingOrChongZhi];
    //余额不足提示
    
    //工种
    self.gongzhong.text = [NSString stringWithFormat:@"%@",_SelectLabel.text];
    //开工日期
    self.topKaiGongRiQi.text = [NSString stringWithFormat:@"%@",_starTimeLabel.text];
    //天数
    self.TopYongGongTianShu.text = [NSString stringWithFormat:@"%@天",self.tianshu.text];
    //单日工资
    self.TopDanRiGongzi.text = self.moenyLabel.text;
    //工作内容
    self.TopGongZuoNeiRong.text = [NSString stringWithFormat:@"%@",self.GongZuoNeiRong.text];
    //工作地点
    self.topGongZuoDiDian.text = self.GongChengDiDian.text;
    //联系人
    self.lianxiren.text = self.LianXIRen.text;
    //联系电话
    self.lianxidianhua.text = self.LianXiDianHua.text;
    //备注
    self.beizhu.text = self.BeiZhu.text;

    
    //获取保证金数
    if (self.isChongXinFaBu) {
         self.zhiabaojin.text = @"0";
    }else
    {
        [self netWorkgetBaoZhengJinForNumber];
    }
}

#pragma mark 点击确定 到支付也面
//提示框返回
- (IBAction)queDingChongZhi:(id)sender {
    
    
    if(!self.isChongXinFaBu)
    {
        [self toVC:nil];
    }else
    {
        [self chongXinFaBu];
    }
    
}

#pragma mark 提交订单／跳转支付页
- (void)toVC:(UIButton *)button{
    
    self.queDingOrChongZhi.enabled = NO;
    
    [self backClicked];
    
   // _sureView.hidden = YES;
    
    ADAccount *account = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    [parm setObject:self.Id forKey:@"gongzhongid"];
    [parm setObject:self.GongChengDiDian.text forKey:@"adr"];
    [parm setObject:self.XuQiuRenShu.text forKey:@"n"];
    [parm setObject:self.starTimeLabel.text forKey:@"kaigongriqi"];
    [parm setObject:self.tianshu.text forKey:@"yuji"];
    [parm setObject:self.moenyLabel.text forKey:@"price"];
    [parm setObject:self.LianXIRen.text forKey:@"lianxiren"];
    [parm setObject:self.LianXiDianHua.text forKey:@"lianxidianhua"];
    [parm setObject:self.BeiZhu.text forKey:@"beizhu"];
    [parm setObject:self.zhiabaojin.text forKey:@"baozhengjin"];
    [parm setObject:self.GongZuoNeiRong.text forKey:@"gongzuoneirong"];
    

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"gongchengdidianlat"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"gongchengdidianlng"]) {
        
        [parm setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"gongchengdidianlat"] forKey:@"lat"];
        [parm setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"gongchengdidianlng"] forKey:@"lng"];
    }
    
    //NSLog(@"%@",parm);
    //提交订单
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_tijiaodingdan params:parm success:^(id responseObj) {
        // NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            
            if ([self.ZhiFuJinE isEqualToString:@"0"]||[self.ZhiFuJinE floatValue]<=0) {
                
                MainViewController *controller = self.navigationController.childViewControllers[0];
                //[self.navigationController popToRootViewControllerAnimated:YES];
                [self.navigationController popToViewController:controller animated:NO];
                controller.pushOrder = YES;
                
                return ;
            }
            
            [weakSelf pushToZhiFu:[[responseObj objectForKey:@"data"] objectForKey:@"ordercode"]];
            
        }else
        {
            _tixingView2 = [CancleTiXing2 LoadView];
            _tixingView2.Content.text =[responseObj objectForKey:@"message"];
            //grabOrderV.frame = CGRectMake(50, 200, SCREEN_WIDTH -100, SCREEN_WIDTH -100);
            _tixingView2.frame = CGRectMake((SCREEN_WIDTH-250)/2, 180, 250, 180);
            
            [_tixingView2 YesBtnAddTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
            
            _backView = [Function createBackView:self action:@selector(backViewClicked)];
            [[[UIApplication sharedApplication]keyWindow]addSubview:_backView];
            [[[UIApplication sharedApplication]keyWindow]addSubview:_tixingView2];

            //[ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 不能发单提醒取消
-(void)quxiao
{
    [_tixingView2 removeFromSuperview];
    [_backView removeFromSuperview];
    
}
-(void)backViewClicked
{

}


#pragma mark 判断充值还是确定/Users/ass/Desktop/宅易/zhaiyi/雇主找工人/employersLookingViewController.m
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


- (IBAction)TopBack:(id)sender {
    
    _sureView.hidden = YES;
    [self.backView removeFromSuperview];
    
}
#pragma mark遮盖
-(void)backClicked
{
    [self TopBack:nil];
    //[self.backView removeFromSuperview];

}

- (void)TopQueDing:(id)sender {
    
}


- (IBAction)TouchUp:(id)sender {
    
    //NSLog(@"123");
    for (UITextField *text in self.FatherView.subviews) {
        
        [text resignFirstResponder];
    }
    
    [self.FatherView endEditing:YES];
}

#pragma mark 保证金说明
- (IBAction)baoZhengJinShuoMing:(id)sender {
    
    ShuoMingViewController *baozhengjinShuoming = [[ShuoMingViewController alloc]init];
    
    [self.navigationController pushViewController:baozhengjinShuoming animated:YES];
}

#pragma mark 跳转支付页
-(void)pushToZhiFu:(NSString *)orderCode
{
    My_pocket_Pay_Controller *rechargeController = [[My_pocket_Pay_Controller alloc]init];

    rechargeController.Yue = self.Yue;
    rechargeController.ZhiFuJinE = self.ZhiFuJinE;
    rechargeController.orderCode = orderCode;
    rechargeController.zhiFuNeirong = @"支付保证金";
    
    [self.navigationController pushViewController:rechargeController animated:YES];
}
#pragma mark 重新发布请求
-(void)chongXinFaBu
{
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.orderId forKey:@"id"];
    [parm setObject:self.moenyLabel.text forKey:@"price"];
    
    [NetWork postNoParm:YZX_chongxinfabu params:parm success:^(id responseObj) {

        if ([[responseObj objectForKey:@"result"] isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            UIViewController *ViewC = self.navigationController.childViewControllers[1];
            [self.navigationController popToViewController:ViewC animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
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
    
}
#pragma mark 重新发布工种
-(void)UpdateFenLeiChongXin
{
//    int colNum = 3;
//    int rowNum= 2;
//    
//    CGFloat squareWidth = 45;
//    CGFloat squareHeight = 45;
//    CGFloat colPan = 20;
//    CGFloat rowpan = 10;
//    
//    //UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, squareHeight * rowNum)];
//        //行号
//    int row = 0;
//        //列号
//    int col = 0;
//        
//    UILabel *squareLab = [[UILabel alloc] initWithFrame:CGRectMake( colPan+squareWidth * col+((ScreenW-colPan*2-squareWidth*colNum)/(colNum-1))*col, rowpan+squareHeight * row+(rowpan *row), squareWidth, squareHeight)];
//    
//        // NSLog(@"%ld",squareLab.tag);
//    squareLab.textAlignment = NSTextAlignmentCenter;
//    squareLab.font = [UIFont systemFontOfSize:16];
//        
//    squareLab.backgroundColor = [UIColor whiteColor];
//    _SelectLabel =squareLab;
//            //切割成圆
//    _SelectLabel.layer.cornerRadius = 22;
//    _SelectLabel.clipsToBounds = YES;
//        
//    squareLab.text = [self.dataSourceChongXinFaBu objectForKey:@"gzname"];
//    
//    [self.FenLeiSuperView addSubview:squareLab];
    
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
        squareLab.textColor = [UIColor whiteColor];
        
        // NSLog(@"%ld",squareLab.tag);
        squareLab.textAlignment = NSTextAlignmentCenter;
        squareLab.font = [UIFont systemFontOfSize:16];
        
        NSLog(@"%@",[self.dataSourceFenLei[i] objectForKey:@"gzname"]);
        NSLog(@"%@",[self.dataSourceChongXinFaBu objectForKey:@"gzname"]);
        
        if ([self.dataSourceFenLei[i] objectForKey:@"gzname"] == [self.dataSourceChongXinFaBu objectForKey:@"gzname"]) {
            
            squareLab.backgroundColor = [UIColor whiteColor];
            squareLab.textColor = [UIColor blackColor];
            _SelectLabel =squareLab;
            //切割成圆
            _SelectLabel.layer.cornerRadius = 22;
            _SelectLabel.clipsToBounds = YES;
            _classId =[NSString stringWithFormat:@"%ld",squareLab.tag];
            
        }else
        {
            squareLab.backgroundColor = [UIColor clearColor];
        }
        
//        if (i == 0) {
//            
//            
//            squareLab.backgroundColor = [UIColor whiteColor];
//            squareLab.textColor = [UIColor blackColor];
//            _SelectLabel =squareLab;
//            //切割成圆
//            _SelectLabel.layer.cornerRadius = 22;
//            _SelectLabel.clipsToBounds = YES;
//            _classId =[NSString stringWithFormat:@"%ld",squareLab.tag];
//        }else
//        {
//            squareLab.backgroundColor = [UIColor clearColor];
//        }
        //后台返回null
        // NSString *str = [self.titleArr[i] objectForKey:@"title"];
        // NSLog(@"%@",str);
        
        squareLab.text = [self.dataSourceFenLei[i] objectForKey:@"gzname"];
        [self.FenLeiSuperView addSubview:squareLab];
    }

    
    [self makeUIChognxinFaBu];
}


#pragma mark 继续发布设置UI
-(void)makeUIChognxinFaBu
{
    self.GongChengDiDian.text = [self.dataSourceChongXinFaBu objectForKey:@"adr"];
    self.GongChengDiDian.userInteractionEnabled = NO;
    
    self.GongZuoNeiRong.text = [self.dataSourceChongXinFaBu objectForKey:@"gongzuoneirong"];
    self.GongZuoNeiRong.userInteractionEnabled = NO;
    
    self.XuQiuRenShu.text = [self.dataSourceChongXinFaBu objectForKey:@"n"];
    self.XuQiuRenShu.userInteractionEnabled = NO;
    
    //self.starTimeLabel.text = [self.dataSourceChongXinFaBu objectForKey:@"kaigongriqi"];
    self.starTimeLabel.text =  [NSDate stringWithNowData];
    self.starTimeLabel.userInteractionEnabled = NO;
    self.dayNum.userInteractionEnabled = NO;
    
    self.tianshu.text = [self.dataSourceChongXinFaBu objectForKey:@"yuji"];
    self.tianshu.userInteractionEnabled = NO;
    
    self.BeiZhu.text = [self.dataSourceChongXinFaBu objectForKey:@"beizhu"];
    self.BeiZhu.userInteractionEnabled = NO;
    
    self.LianXIRen.text = [self.dataSourceChongXinFaBu objectForKey:@"lianxiren"];
    self.LianXIRen.userInteractionEnabled = NO;
    
    self.LianXiDianHua.text = [self.dataSourceChongXinFaBu objectForKey:@"lianxidianhua"];
    self.LianXiDianHua.userInteractionEnabled = NO;
    
    self.moenyLabel.text = [NSString stringWithFormat:@"%@元",[self.dataSourceChongXinFaBu objectForKey:@"price"]];

    
    
}
#pragma mark 正常工种分类
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
        squareLab.textColor = [UIColor whiteColor];
        
        // NSLog(@"%ld",squareLab.tag);
        squareLab.textAlignment = NSTextAlignmentCenter;
        squareLab.font = [UIFont systemFontOfSize:16];
        
        if (i == 0) {
            squareLab.backgroundColor = [UIColor whiteColor];
            squareLab.textColor = [UIColor blackColor];
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
    
        squareLab.text = [self.dataSourceFenLei[i] objectForKey:@"gzname"];

        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HeaderClicked:)];
        squareLab.userInteractionEnabled = YES;
        [squareLab addGestureRecognizer:tap];
        [self.FenLeiSuperView addSubview:squareLab];
        
        //保险费额赋值
        NSInteger money = [[self.dataSourceFenLei[0] objectForKey:@"price"] integerValue];
        self.moenyLabel.text =[NSString stringWithFormat:@"%ld",money];
        
        self.Id = [self.dataSourceFenLei[0] objectForKey:@"id"];
        
        if(ScreenW<=320)
        {
            self.GongChengDiDian.font = [UIFont systemFontOfSize:12];
            self.BeiZhu.font = [UIFont systemFontOfSize:12];
        }
        
    }
    
    NSString *money = [self.dataSourceFenLei[0] objectForKey:@"price"];
    //self.baoxianFei.text =[NSString stringWithFormat:@"%ld",money];
    self.moenyLabel.text =money;
}
#pragma mark 点击工种
- (void)HeaderClicked: (UITapGestureRecognizer *)gestureRecognizer
{
    _SelectLabel.backgroundColor = [UIColor clearColor];
    _SelectLabel.clipsToBounds = NO;
    _SelectLabel.textColor = [UIColor whiteColor];
    
    _SelectLabel = (UILabel *)[gestureRecognizer view];
    _SelectLabel.backgroundColor = [UIColor whiteColor];
    _SelectLabel.layer.cornerRadius = 22;
    _SelectLabel.clipsToBounds = YES;
    _SelectLabel.textColor = [UIColor blackColor];
    
    
    self.classId = [NSString stringWithFormat:@"%ld",_SelectLabel.tag];
    self.GongZhongType = _SelectLabel.text;
    
    //NSInteger money = [[self.dataSourceFenLei[_SelectLabel.tag -1] objectForKey:@"price"] integerValue];
    NSString *money = [self.dataSourceFenLei[_SelectLabel.tag -1] objectForKey:@"price"];
   //self.baoxianFei.text =[NSString stringWithFormat:@"%ld",money];
    self.moenyLabel.text =money;
    
    self.Id =[self.dataSourceFenLei[_SelectLabel.tag -1] objectForKey:@"id"];

}

#pragma mark 工种分类接口
-(void)netWork
{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    ADAccount *acount = [ADAccountTool account];
    if (acount) {
        
        [parm setObject:acount.userid forKey:@"userid"];
        [parm setObject:acount.token forKey:@"token"];
    }
    
    NSLog(@"%@",parm);
    [NetWork postNoParm:YZX_zhaogongren params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
        
            //完善个人资料
            if ([[responseObj objectForKey:@"message"]isEqualToString:@"请您先完善您的个人资料"]) {
                [ITTPromptView showMessage:@"请您先完善您的个人资料"];
                
                PersonalGuZhuController *personalGZ = [[PersonalGuZhuController alloc]init];
                personalGZ.title = @"个人资料";
                [self.navigationController pushViewController:personalGZ animated:YES];
                
               // return ;
            }
            
       //NSLog(@"%@",[responseObj objectForKey:@"data"] );
        self.dataSourceFenLei = [[responseObj objectForKey:@"data"]objectForKey:@"gongzhong"];
        self.LianXIRen.text = [[responseObj objectForKey:@"data"]objectForKey:@"lianxiren"];
        self.LianXiDianHua.text = [[responseObj objectForKey:@"data"]objectForKey:@"lianxidianhua"];
       // NSLog(@"%@",self.dataSourceFenLei);
       //更新分类界面
            if (_isChongXinFaBu) {
                 [self UpdateFenLeiChongXin];
            }else
            {
                [self UpdateFenLei];
            }
            
            
    }else
    {
        [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
    }
        
    } failure:^(NSError *error) {
        [ITTPromptView showMessage:@"网络错误"];
        NSLog(@"%@",error);
        
    }];
}
#pragma mark 通过发布人数获取应缴质保金（雇主端）
-(void)netWorkgetBaoZhengJinForNumber
{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    ADAccount *acount = [ADAccountTool account];
    
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.XuQiuRenShu.text forKey:@"n"];
    
    [NetWork postNoParmForMap:YZX_returnzhibaojin params:parm success:^(id responseObj) {
        
       // NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            self.zhiabaojin.text =[NSString stringWithFormat:@"%@元",[[responseObj objectForKey:@"data"]objectForKey:@"zhibaojin"]];
            self.ZhiFuJinE = [[responseObj objectForKey:@"data"]objectForKey:@"zhibaojin"];
            self.Yue = [[responseObj objectForKey:@"data"]objectForKey:@"yue"];
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 重新发布接口
-(void)chongxinfabu
{
    ADAccount *account = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    [parm setObject:self.orderId forKey:@"id"];
    
    //NSLog(@"%@");
    
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_jixufabu params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        self.dataSourceChongXinFaBu = [responseObj objectForKey:@"data"];
    
       // [weakSelf UpdateFenLeiChongXin];
        [weakSelf netWork];
        
    } failure:^(NSError *error) {
        
    }];
}

//
- (IBAction)touchs:(id)sender {
    
    [self.FatherView endEditing:YES];
}


#pragma mark TextFiledDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    switch (textField.tag) {
        case 101://工作内容
            return YES;
            break;
        case 102://需求人数
            if (textField.text.length>=4) {
                return NO;
            }else
            {
                return YES;
            }
            break;
        case 103://天数
            if (textField.text.length>=3) {
                return NO;
            }else
            {
                return YES;
            }
            break;
        case 104://联系电话
            return YES;
            break;
            
        default:
            break;
    }
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 101://工作内容
            
            break;
        case 102://需求人数
            
            break;
        case 103://天簌
            
            break;
        case 104://联系电话
            
            break;
            
        default:
            break;
    }
    
    [self IfLogin];
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
//    NSLog( @"%lf",ScreenH);
//    NSLog(@"%lf",self.TextFiled.y);
//    NSLog(@"%lf",deltaY);
    
    // NSLog(@"%lf",self.TableView.y);
    
    NSLog(@"%lf",[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]);
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
//        NSLog(@"%lf",deltaY-(_TextFiled.y-self.ScrrolView.contentOffset.y+64+64+_TextFiled.height)+20);
//        NSLog(@"%lf",deltaY);

        if ((deltaY-(_TextFiled.y-self.ScrrolView.contentOffset.y+64+_TextFiled.height)+20)<=0) {
            self.view.y = deltaY-(_TextFiled.y-self.ScrrolView.contentOffset.y+64+_TextFiled.height)+2;
            [self.ScrrolView setContentOffset:CGPointMake(0, self.ScrrolView.contentOffset.y+64) animated:YES];
        }

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
        //[self.ScrrolView setContentOffset:CGPointMake(0, self.ScrrolView.contentOffset.y-64) animated:YES];
    } completion:^(BOOL finished) {
        //
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 是否登陆
-(void)IfLogin
{
    ADAccount *acount = [ADAccountTool account];
    if (!acount) {
        
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




@end
