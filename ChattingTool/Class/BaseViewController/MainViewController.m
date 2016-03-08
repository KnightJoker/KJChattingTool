//
//  MainViewController.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/8.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "MainViewController.h"
#import "PublicDefine.h"

@implementation MainViewController


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - initiation

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 100, 30, 30, 30)];
    
    [self.view addSubview:messageBtn];
}
@end
