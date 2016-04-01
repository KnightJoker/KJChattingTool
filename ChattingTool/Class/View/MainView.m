//
//  MainView.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "MainView.h"
#import "PublicDefine.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"");
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    //    NSLog(@"%f",SCREEN_HEIGHT);
    //    NSLog(@"%f",SCREEN_WIDTH);
    
    UIButton* messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 380, SCREEN_HEIGHT - 80, 50, 50)];
    
    [messageBtn setImage:[UIImage imageNamed:@"shortcut_multichat.png"] forState:UIControlStateNormal];
    
    
    UIButton* contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 240, SCREEN_HEIGHT - 80, 50, 50)];
    
    [contactBtn setImage:[UIImage imageNamed:@"shortcut_addFri.png"] forState:UIControlStateNormal];
    
    
    UIButton* dynamicBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 80, 50, 50)];
    
    [dynamicBtn setImage:[UIImage imageNamed:@"favorite_classify_qzone@2x.png"] forState:UIControlStateNormal];
    
    [self addSubview:messageBtn];
    [self addSubview:contactBtn];
    [self addSubview:dynamicBtn];
    
    [messageBtn addTarget:self action:@selector(messageBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)messageBtnDidClick:(id)sender {

    if ([_delegate respondsToSelector:@selector(mainView:messageBtnDidClick:)]) {
        [_delegate mainView:self messageBtnDidClick:sender];
    }
}
@end
