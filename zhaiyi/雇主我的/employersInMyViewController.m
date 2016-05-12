//
//  employersInMyViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "employersInMyViewController.h"
#import "My_Login_UserInfo_Cell.h"
#import "My_NoLogin_UserInfo_Cell.h"
#import <objc/message.h>
#import "My_pocket_index_ViewController.h"
#import "My_pocket_index_ContactController.h"
#import "My_pocket_tixian_ShareController.h"
#import "My_pocket_tixian_FeedbackController.h"
#import "My_pocket_qiehuan_View.h"
#import "My_Login_In_ViewController.h"
#import "My_jidanshezhi_Controller.h"
#import "PersonalGongRenController.h"
#import "PersonalGuZhuController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "AFNetFirst.h"
#import "PayPasswordViewController.h"
#import "MyInfoGz.h"

@interface employersInMyViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate
>
{
    UITableView * tb;
    NSString * userid;
    NSString * passWord;
    NSString * userName;

    NSString * leixing;
    NSArray * actions;
    My_pocket_qiehuan_View * qh;
    UIButton * btn;
    //头像保存
    NSString *_imageFilePath;
    NSString *_em_imageFilePath;

    NSString *_imageUrl;
    NSString *  _id;
    NSData *_imageData;
    //相机
    UIImagePickerController *_picker;
 //    NSDictionary *userInfoDict;
    ADAccount *_account;
    //版本更新
    NSString *updateUrl;
    
    //记住选择的登录状态
    NSUserDefaults *userDefaults;
    
    UIButton *Ritghbtns;
}
//雇主信息数据源model
@property (nonatomic, strong)MyInfoGz *MyInfoGz;

@property (nonatomic, strong)MyInfoGz *MyInfoGr;

@end

@implementation employersInMyViewController

-(MyInfoGz *)dataSourceInfo_gz
{
    if (!_MyInfoGz) {
        _MyInfoGz = [[MyInfoGz alloc]init];
    }
    return _MyInfoGz;
}
-(MyInfoGz *)dataSourceInfo_gr
{
    if (!_MyInfoGr) {
        _MyInfoGr = [[MyInfoGz alloc]init];
    }
    return _MyInfoGr;
}
-(void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onScreenTouch:) name:@"notiScreenTouch" object:nil];
    //雇主端信息
    
    if (GetUserDefaultsGZ) {
        [self netWork_Info_gz_gr:1];
    }else
    {
        [self netWork_Info_gz_gr:2];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalData];
    //设置右上角按钮－title
    [self setRightBarButtonItem];
    [self MakeUI];
    
    // Do any additional setup after loading the view.
}
-(void)MakeUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
 
    _imageFilePath = nil;
    _em_imageFilePath = nil;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    userName = [userDefaults objectForKey:@"userName"];
    passWord = [userDefaults objectForKey:@"passWord"];


    tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kU, Ga)];
    tb.delegate=self;
    tb.dataSource=self;
    tb.bounces=YES;
    tb.scrollEnabled = YES;
    [self.view addSubview:tb];
    
}

#pragma mark 雇主端请求个人信息数据
/*
 type  1.雇主  2.工人
 */
-(void)netWork_Info_gz_gr :(int)Type;
{
    
    ADAccount *acount = [ADAccountTool account];
    if (!acount) {
        return;
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    NSLog(@"%@",parm);
    NSString *url;
    if (Type == 1) {
        url = wode_gz;
    }else if (Type == 2)
    {
        url = wode_gr;
    }
    
    [NetWork postNoParm:url params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        //转模型
        self.MyInfoGz = [MyInfoGz mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
        
        
        [tb reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 设置右上角按钮
-(void)setRightBarButtonItem
{
    //设置title
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:21],
    
    NSForegroundColorAttributeName:[UIColor redColor]}];
    
    Ritghbtns = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 27)];
    Ritghbtns.selected = NO;
    [Ritghbtns setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    [Ritghbtns setTitle:@"切换身份" forState:UIControlStateNormal];
    [Ritghbtns.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [Ritghbtns setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc]initWithCustomView:Ritghbtns];
    self.navigationItem.rightBarButtonItem = BtnItem;
    
    [Ritghbtns addTarget:self action:@selector(QH:) forControlEvents:UIControlEventTouchUpInside];
    
   // [self QH:Ritghbtns];
}


-(void)initalData{
    
    //获取用户信息
    //[self getUserInfo];
    //默认不显示切换
    [qh removeFromSuperview];
   // Ritghbtns.selected = NO;
    _account = [ADAccountTool account];
    //获取登录信息
   // _imageUrl = _account.picture;
    
    _id = _account.userid;
    
    userid = _account.userid;
   // if ([_account.type isEqualToString:@"78"]) {
        
        actions = @[@{@"action":@"pushPersonalDetails"},
                    @{@"action":@"pushWalletVc"},
                   // @{@"action":@"pushSettingVc"},
                    @{@"action":@"pushShareVc"},
                    @{@"action":@"pushFeedbackVc"},
                    @{@"action":@"pushMyXiaoxi"},
                    @{@"action":@"pushTelVc"},
                   // @{@"action":@"pushUpdateAlert"},
                    @{@"action":@"pushLogoutVc"}];
   // }
//    else
//    {
//        actions = @[@{@"action":@"pushPersonalDetails"},
//                    @{@"action":@"pushWalletVc"},
//                    @{@"action":@"pushShareVc"},
//                    @{@"action":@"pushFeedbackVc"},
//                    @{@"action":@"pushTelVc"},
//                   // @{@"action":@"pushUpdateAlert"},
//                    @{@"action":@"pushLogoutVc"}];
//    }
    
    [self refreshData];

    [tb reloadData];
    
}



-(void)getUserInfo{
    
    NSLog(@"用户信息:%@",[ADAccountTool backWitDictionary]);
}
#pragma mark  刷新数据
-(void)refreshData{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (GetUserDefaultsGR) {
        //return 8;
        return 7;
    }else
    {
        //return 7;
        return 7;
    }
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (indexPath.row==0) {
        if (userid.length==0) {
            //未登录
            My_NoLogin_UserInfo_Cell * cell;
            if (!cell) {
                cell =[[[NSBundle mainBundle]loadNibNamed:@"My_NoLogin_UserInfo_Cell" owner:self options:nil]lastObject];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            [cell.login addTarget:self action:@selector(clickedLogin:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else
        {
            My_Login_UserInfo_Cell * cell;
            if (!cell) {
                cell =[[[NSBundle mainBundle]loadNibNamed:@"My_Login_UserInfo_Cell" owner:self options:nil]lastObject];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
//            if([self.MyInfoGr.ordernum isEqualToString:@""])
//            {
//              cell.orderNum.text = @"0单";
//            }
            cell.orderNum.text = [NSString stringWithFormat:@"%@单",self.MyInfoGz.ordernum];
            //
            if (GetUserDefaultsGR) {
                
                //工人姓名
                if (self.MyInfoGz.name) {
                    cell.userNameLb.text = self.MyInfoGz.name;
                }else
                {
                    cell.userNameLb.text =@"未登陆";
                }
                
                  //工人头像
                if (_imageFilePath != nil) {
                    NSLog(@"工人头像 :%@",_imageFilePath);
                    cell.userImgV.image = [UIImage imageWithContentsOfFile:_imageFilePath];
                } else {
                    NSString *pic_url = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,self.MyInfoGz.headpic];
                    [cell.userImgV sd_setImageWithURL:[NSURL URLWithString:pic_url] placeholderImage:[UIImage imageNamed:@"我的3"]];
                }
                
            } else {
                
                //雇主姓名
                if (self.MyInfoGz.name) {
                    cell.userNameLb.text = self.MyInfoGz.name;
                }else
                {
                    cell.userNameLb.text =@"未登陆";
                }
                
                //雇主头像
                if (_em_imageFilePath != nil) {
                    NSLog(@"雇主头像 :%@",_em_imageFilePath);
                     cell.userImgV.image = [UIImage imageWithContentsOfFile:_em_imageFilePath];
                } else {
                    NSString *pic_url = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,self.MyInfoGz.headpic];
                    [cell.userImgV sd_setImageWithURL:[NSURL URLWithString:pic_url] placeholderImage:[UIImage imageNamed:@"我的3"]];
                }
            
            }
            
            //地址
            
            NSString *position = [[NSUserDefaults standardUserDefaults]objectForKey:@"position"];
            
            if (self.MyInfoGz.lng) {
                cell.userAddressLb.text = position;
            } else {
                cell.userAddressLb.text = position;
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
            [cell.userImgV addGestureRecognizer:tap];
            
            return cell;
        }
    }else
    {
        UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            cell1=[[UITableViewCell alloc]init];
        }
        UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(8, 20, 20, 20)];
        [cell1.contentView addSubview:img];
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(40, 20, 100, 20)];
        title.font=[UIFont systemFontOfSize:16];
        [cell1.contentView addSubview:title];
        //箭头
        
        UIImageView *arrowsImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kU - 26, 21, 10, 18)];
        arrowsImgV.image = [UIImage imageNamed:@"钱包3"];
        [cell1.contentView addSubview:arrowsImgV];
        
        NSArray *picArr = [[NSArray alloc]init];
        //工人
        if (GetUserDefaultsGR) {
            picArr=@[@"我的_03.png",@"fenXiang",@"我的_12.png",@"xiaoxi",@"我的_14.png",@"我的_19.png"];
            NSArray * name=@[@"钱       包",@"分       享",@"意见反馈",@"我的消息",@"客服电话",@"退        出"];
             img.image=[UIImage imageNamed:picArr[indexPath.row-1]];
            title.text=name[indexPath.row-1];
            //雇主
        }else{
            picArr=@[@"我的_03.png",@"fenXiang",@"我的_12.png",@"xiaoxi",@"我的_14.png",@"我的_19.png"];
            NSArray * name=@[@"钱       包",@"分       享",@"意见反馈",@"我的消息",@"客服电话",@"退        出"];
            img.image=[UIImage imageNamed:picArr[indexPath.row-1]];
            title.text=name[indexPath.row-1];
        }
        
//        if (indexPath.row == picArr.count - 1) {
//            arrowsImgV.hidden = YES;
//            UILabel * updateLb =[[UILabel alloc]initWithFrame:CGRectMake(kU - 130, 20, 120, 20)];
//            updateLb.font = [UIFont systemFontOfSize:14];
//            updateLb.textAlignment = NSTextAlignmentRight;
//            updateLb.text = [NSString stringWithFormat:@"当前版本:%@",CURRENT_VERSION ];
//            [cell1.contentView addSubview:updateLb];
//        }
        if (indexPath.row == picArr.count) {
            arrowsImgV.hidden = YES;
        }
        
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(10, 59, kU-10, 1)];
        view.backgroundColor=[UIColor myColorWithString:@"f4f4f4"];
        [cell1.contentView addSubview:view];
        return cell1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 130;
    }else
    {
        return 55;
    }
}

-(void)clickedLogin:(UIButton *)sender{
    
    My_Login_In_ViewController *my_login = [[My_Login_In_ViewController alloc]init];
    [self.navigationController pushViewController:my_login animated:YES];
}


#pragma mark -------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (userid.length != 0) {
        NSDictionary *actionDict = actions[indexPath.row];
        if (actionDict[@"action"]) {
            SEL sel = NSSelectorFromString(actionDict[@"action"]);
            if ([self respondsToSelector:sel]) {
                objc_msgSend(self,sel);
            }
        }
    }else {
        [self goLogin];
    }
}


#pragma mark  我的消息
-(void)pushMyXiaoxi
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    My_pocket_tixian_FeedbackController *vc = [story instantiateViewControllerWithIdentifier:@"xiaoxi"];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark  登陆
-(void)goLogin
{
    My_Login_In_ViewController *login = [[My_Login_In_ViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark 个人详细信息
- (void)pushPersonalDetails {
    
    if (GetUserDefaultsGR) {
        
        PersonalGongRenController *personalGR = [[PersonalGongRenController alloc]init];
        personalGR.title = @"个人资料";
        [self.navigationController pushViewController:personalGR animated:YES];
    } else {
        PersonalGuZhuController *personalGZ = [[PersonalGuZhuController alloc]init];
        personalGZ.title = @"个人资料";
        [self.navigationController pushViewController:personalGZ animated:YES];
    }
}
#pragma mark 钱包
- (void)pushWalletVc {
    
    //未设置密码
    if ([self.MyInfoGz.zhifumima isEqualToString:@"0"]) {
        PayPasswordViewController *payC = [[PayPasswordViewController alloc]init];
        payC.payController = setPassword;
        
        [self.navigationController pushViewController:payC animated:YES];
        
    }else
    {
        My_pocket_index_ViewController * pocket=[[My_pocket_index_ViewController alloc]init];
        [self.navigationController pushViewController:pocket animated:YES];
    }

}
//跳转到分享有礼
- (void)pushShareVc {
    My_pocket_tixian_ShareController *vc = [My_pocket_tixian_ShareController new];
    vc.title = @"分享有礼";
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到意见反馈
- (void)pushFeedbackVc {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"My_pocket_tixian_FeedbackController" bundle:nil];
    My_pocket_tixian_FeedbackController *vc = [story instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//跳转到服务电话
- (void)pushTelVc{
    
    My_pocket_index_ContactController * vc = [My_pocket_index_ContactController new];
    vc.title = @"联系我们";
    [self.navigationController pushViewController:vc animated:YES];
    
}
//版本更新
-(void)pushUpdateAlert{
//    NSLog(@"最新版本");
    
    [self getNewVersion];
    
}


//退出
- (void)pushLogoutVc {
    NSLog(@"-----7------");
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:U];
    [defaults setObject:@"" forKey:P];
    [defaults setObject:@"" forKey:L];
    [defaults synchronize];
    
    
    [ADAccountTool deleteAccount];
    
    if (![ADAccountTool account]) {
        
        [ITTPromptView showMessage:@"退出成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
       [self viewWillAppear:YES];
    }

}

#pragma mark 版本更新

-(void)getNewVersion{
    
    NSMutableDictionary *paramater = [NSMutableDictionary dictionary];
    [paramater setObject:_account.userid forKey:@"user_id"];
    
    [NetWork postNoParm:POST_UPDATE_VERSION params:paramater success:^(id responseObj) {
        NSLog(@"版本 %@",CURRENT_VERSION);
        
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            NSDictionary *dict = [responseObj objectForKey:@"data"];
            NSLog(@"dict %@",dict);
            NSString *number = [dict objectForKey:@"view_number"];
             if ([number floatValue]>[CURRENT_VERSION floatValue]) {
                NSString *time = [dict objectForKey:@"updatetime"];
                NSString *message = [NSString stringWithFormat:@"有新版本了!\n更新于%@",[time substringToIndex:10]];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前去更新", nil];
                updateUrl = [dict objectForKey:@"ios_url"];
                [alert show];
                
            } else {
                
                [ITTPromptView showMessage:@"暂时没有新版本更新"];
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            NSLog(@"前去更新版本");
            if (updateUrl != nil|updateUrl.length !=0) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:updateUrl]];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 切换身份按钮

- (void)QH:(id)sender {
    
    ADAccount *acount = [ADAccountTool account];
    
    UIButton *changeIdentityBtn = (UIButton *)sender;
    changeIdentityBtn.selected = !changeIdentityBtn.selected;
    
    if (changeIdentityBtn.selected) {
        [changeIdentityBtn setTitle:@"取消切换" forState:UIControlStateSelected];
        qh=[My_pocket_qiehuan_View initViewWithXib];
        qh.frame=CGRectMake(0, 64, kU, 130);
        qh.LX=_account.type;
        [qh.goren addTarget:self action:@selector(gongren) forControlEvents:UIControlEventTouchUpInside];
        [qh.guzhu addTarget:self action:@selector(guzhu) forControlEvents:UIControlEventTouchUpInside];
        
        if (GetUserDefaultsGR) {
            qh.gongrenCheckImageV.hidden = NO;
            qh.guzhuCheckImageV.hidden = YES;
        }else if (GetUserDefaultsGZ)
        {
            qh.gongrenCheckImageV.hidden = YES;
            qh.guzhuCheckImageV.hidden = NO;
        }
        
        [self.view addSubview:qh];
        
    } else {
        [qh removeFromSuperview];

    }
}

//工人切换
-(void)gongren
{
    SetUserDefaultsGR
    pop
    [self qiehuan:27];
}
//雇主切换
-(void)guzhu
{
    SetUserDefaultsGZ
    pop
    [self qiehuan:26];
}

#pragma mark 切换接口

/*
 *26雇主27工人
 */
-(void)qiehuan:(int)shenFenType
{
    ADAccount *acount = [ADAccountTool account];
    
    if (!acount) {
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:[NSString stringWithFormat:@"%d",shenFenType] forKey:@"shenfen"];
    
    [NetWork postNoParmForMap:YZX_qiehuan params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark 相机相册

-(void)changePhoto:(UITapGestureRecognizer *)sender
{
    UIActionSheet *myAction = [[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [myAction showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                _picker = [[UIImagePickerController alloc]init];
                _picker.delegate = self;
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _picker.allowsEditing = YES;
                [self presentViewController:_picker animated:YES completion:^{
                    
                }];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
        case 1:{
            //相册
            _picker = [[UIImagePickerController alloc]init];
            _picker.delegate = self;
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_picker animated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma Delegate method UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _imageData = UIImageJPEGRepresentation(image, 0.3);
       // _userImage = image;
        //保存图片
        [self saveImage:image];
        [self changeImage];
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"来自相册");
        }];
    } else if (_picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        _imageData = UIImageJPEGRepresentation(image, 0.3);
//        _userImage = image;
        //保存图片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self saveImage:image];
        [self changeImage];
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"来自相机");
        }];
    }
}

//上传头像
-(void)changeImage{
    ADAccount *acount = [ADAccountTool account];
    
    if (!acount) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:acount.userid forKey:@"userid"];
    [params setObject:acount.token forKey:@"token"];
    [params setObject:@"ios" forKey:@"apptype"];
    
    
    //判断
    if (GetUserDefaultsGR) {
        //工人端
        [AFNetFirst typePicturePOST:YZX_genghuantouxiang_gr parameters:params withPicureData:_imageData withKey:@"headpic" finish:^(NSData *data, NSError *error) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",dic);
            if ([[dic objectForKey:@"result"] isEqualToString:@"1"]) {
                [ITTPromptView showMessage:@"头像修改成功"];
                [tb reloadData];
            }
        }];
     }
    else {
         //雇主端
         [AFNetFirst typePicturePOST:YZX_genghuantouxiang_gz parameters:params withPicureData:_imageData withKey:@"headpic" finish:^(NSData *data, NSError *error) {
             NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSLog(@"%@",dic);
             if ([[dic objectForKey:@"result"] isEqualToString:@"1"]) {
                 [tb reloadData];
                 [ITTPromptView showMessage:@"头像修改成功"];
             }
         }];
     }
}

//保存图片
-(void)saveImage:(UIImage *)image{
    
    
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docunmentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [docunmentsDirectory stringByAppendingPathComponent:@"myPhoto_xiaomujiang.jpg"];
    success = [fileManager fileExistsAtPath:imageFilePath];
    
    if (success) {
        
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
        
        //判断保存
        if (GetUserDefaultsGR) {
            _imageFilePath = imageFilePath;
        } else {
            _em_imageFilePath = imageFilePath;

        }
    }
    
    //写入
    [UIImageJPEGRepresentation(image, 0.3f) writeToFile:imageFilePath atomically:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end




