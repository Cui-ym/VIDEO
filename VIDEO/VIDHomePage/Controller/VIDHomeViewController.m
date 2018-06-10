//
//  VIDHomeViewController.m
//  VIDEO
//
//  Created by 崔一鸣 on 2018/6/7.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "VIDHomeViewController.h"
#import "VIDHomeView.h"

@interface VIDHomeViewController ()

@property (nonatomic, strong) VIDHomeView *videoHomeView;

@end

@implementation VIDHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.93f green:0.33f blue:0.19f alpha:1.00f]];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"教学大厅";
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationItem.title = @"教学大厅";
    self.videoHomeView = [[VIDHomeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_videoHomeView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
