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
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSLog(@"%f",SCREEN_HEIGHT);
//    NSLog(@"%f",SCREEN_WIDTH);
    
    UIButton* messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 380, SCREEN_HEIGHT - 80, 50, 50)];

    [messageBtn setImage:[UIImage imageNamed:@"shortcut_multichat.png"] forState:UIControlStateNormal];
    
    
    UIButton* contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 240, SCREEN_HEIGHT - 80, 50, 50)];

    [contactBtn setImage:[UIImage imageNamed:@"shortcut_addFri.png"] forState:UIControlStateNormal];
    
    
    UIButton* dynamicBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 80, 50, 50)];

    [dynamicBtn setImage:[UIImage imageNamed:@"favorite_classify_qzone@2x.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:messageBtn];
    [self.view addSubview:contactBtn];
    [self.view addSubview:dynamicBtn];
    
    [messageBtn addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)message:(id)sender{
    NSLog(@"消息成功");
    ChattingViewController* vc = [[ChattingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
