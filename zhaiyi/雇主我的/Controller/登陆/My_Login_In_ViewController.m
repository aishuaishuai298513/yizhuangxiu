//
//  My_Login_In_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_Login_In_ViewController.h"
#import "My_Login_logo_Cell.h"
#import "My_Login_input_Cell.h"
#import "NSString+MD5Addition.h"
#import "employersInMyViewController.h"

#import "ReginTextViewCell.h"
#import "APService.h"

#import "MyResignViewController.h"
#import "MyForgetPwdController.h"

#import "Select_ID.h"
@interface My_Login_In_ViewController ()<LoginOrRegin,ReginDelegate>
{
  My_Login_input_Cell * cell2;
    
    BOOL isSuccessEnter;
}

@property (assign,nonatomic) BOOL isKebord;

@property (strong, nonatomic) IBOutlet UITableView *TableView;

@end

@implementation My_Login_In_ViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登陆";
    self.navigationController.navigationBarHidden=YES;
    self.TableView.scrollEnabled = NO;
    
    
    //监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    //注销第一响应
    [self resignTheFirstResponser];
}

//
-(void)keyboardShow:(NSNotification *)note
{
    NSLog(@"%@",note);
    
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.origin.y;
    NSLog( @"%lf",ScreenH);
    NSLog(@"%lf",self.TableView.contentOffset.y);
    NSLog(@"%lf",deltaY);
    
   // NSLog(@"%lf",self.TableView.y);
    
    NSLog(@"%lf",[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]);
    
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.view.y = deltaY-ScreenH+20;
        }];
    
}

-(void)keyboardHide:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.origin.y;
    
       // CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.view.y = 0;
        } completion:^(BOOL finished) {
            //
        }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (indexPath.row==0) {
        My_Login_logo_Cell * cell;
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"My_Login_logo_Cell" owner:self options:nil]lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if (indexPath.row==1){
        //My_Login_input_Cell * cell2;
        if (!cell2) {
            
        cell2=[[[NSBundle mainBundle]loadNibNamed:@"My_Login_input_Cell" owner:self options:nil]lastObject];
        cell2.selectionStyle=UITableViewCellSelectionStyleNone;
           cell2.delegate = self;
            
        }
        //显示保存的帐号信息
        NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
       NSDictionary *dict = [defaults objectForKey:@"enter_user_info"];
        cell2.userNameTF.text = [dict objectForKey:@"mobile"];
        
        return cell2;
    }
    else
    {
        //注册
        ReginTextViewCell * cell;
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ReginTextViewCell" owner:self options:nil]lastObject];
            cell.delegate = self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
    
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return (ScreenH-64) *0.4;
    }
    else if(indexPath.row==1)
    {
        return (ScreenH-64)*0.4;
    }else
    {
        return (ScreenH-64)*(1-0.87);
    }
}

#pragma mark CellDelegate

#pragma mark 登陆
-(void)ReginClick:(NSString *)userName PassWord:(NSString *)PassWord
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *parm  =[NSMutableDictionary dictionary];
    [parm setObject:userName forKey:@"mobile"];
    [parm setObject:PassWord forKey:@"password"];
    [parm setObject:[APService registrationID] forKey:@"jpushcode"];
    
    NSLog(@"%@",parm);
    
    [NetWork postNoParm:YZX_login params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        //登录返回信息
        if ([[responseObj objectForKey:@"result"] isEqualToString:@"1"]) {
            
            NSMutableDictionary *data = responseObj[@"data"];
            ADAccount *account = [ADAccount accountWithDict:data];
            //存储账号模型
            [ADAccountTool save:account];
            
            //选择身份
            Select_ID *selectView = [Select_ID loadView];
            selectView.frame = [[UIApplication sharedApplication]keyWindow].bounds;
            selectView.alpha = 0;
            [[[UIApplication sharedApplication]keyWindow]addSubview:selectView];
            
            [UIView animateWithDuration:2 animations:^{
                selectView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            
            //切换页面 选择身份
//            UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UINavigationController* MainCotroller = [MainStoryboard instantiateViewControllerWithIdentifier:@"MainNav"];
//            // 设置窗口的根控制器
//            UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
//            keyWindow.rootViewController = MainCotroller;
           // [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ITTPromptView showMessage:@"失败"];
        
    }];

    
}
#pragma mark 忘记密码
-(void)ForgetPassClicked:(NSString *)userName PassWord:(NSString *)PassWord
{
    NSLog(@"%@",userName);
    NSLog(@"%@",PassWord);
    MyForgetPwdController *forgetPwd = [[MyForgetPwdController alloc]init];
    [self.navigationController pushViewController:forgetPwd animated:YES];
    
}
#pragma mark ReginCellDelegate
//注册
-(void)reginClicked
{
    MyResignViewController *resign = [[MyResignViewController alloc]init];
    [self.navigationController pushViewController:resign animated:YES];
}

#pragma mark 登录
-(void)netWorkLogin:(NSString *)userName PassWord:(NSString *)PassWord
{
}

//注销第一事件
-(void)resignTheFirstResponser{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancel:)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapCancel:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    
}





@end


