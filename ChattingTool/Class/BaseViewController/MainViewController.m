//
//  MainViewController.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/8.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "MainViewController.h"
#import "PublicDefine.h"
#import "ChattingViewController.h"
#import "MainView.h"

@interface MainViewController () <MainViewDelegate>

@end

@implementation MainViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - initiation

- (void)initView {
    MainView *mainView = [[MainView alloc]init];
    mainView.delegate = self;
    mainView.frame = self.view.frame;
    [self.view addSubview:mainView];
}

- (void)mainView:(MainView *)view messageBtnDidClick:(id)sender {
    NSLog(@"消息成功");
    ChattingViewController* vc = [[ChattingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
