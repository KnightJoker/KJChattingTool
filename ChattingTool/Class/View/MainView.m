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
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];

    UIButton* messageBtn = [[UIButton alloc] init];
    [messageBtn setImage:[UIImage imageNamed:@"shortcut_multichat.png"] forState:UIControlStateNormal];
    
     UIButton* contactBtn = [[UIButton alloc] init];
    [contactBtn setImage:[UIImage imageNamed:@"shortcut_addFri.png"] forState:UIControlStateNormal];
    
    [self addSubview:messageBtn];
    [self addSubview:contactBtn];
    
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(SCREEN_HEIGHT - (SCREEN_HEIGHT / 8));
        make.left.mas_equalTo(SCREEN_WIDTH / 8);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(messageBtn);
        make.left.mas_equalTo(messageBtn).with.offset(SCREEN_WIDTH / 2);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [messageBtn addTarget:self action:@selector(messageBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)messageBtnDidClick:(id)sender {

    if ([_delegate respondsToSelector:@selector(mainView:messageBtnDidClick:)]) {
        [_delegate mainView:self messageBtnDidClick:sender];
    }
}
@end
