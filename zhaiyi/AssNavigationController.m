//
//  AssNavigationController.m
//  zhaiyi
//
//  Created by ass on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AssNavigationController.h"

@interface AssNavigationController ()

@end

@implementation AssNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)initialize
{
    //UINavigationBar *navBar = [UINavigationBar appearance];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;

        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"left红"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 15, 25);
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        viewController.navigationItem.leftBarButtonItem = item;
        
        //viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"left红" selectedImage:@"left红" target:self action:@selector(back)];
    }
    
    [super pushViewController:viewController animated:YES];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}






@end
