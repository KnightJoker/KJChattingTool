//
//  MessageText.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "MessageText.h"
#import "PublicDefine.h"

@interface MessageText ()

@property (strong, nonatomic) UITextField *messageTextView;

@end

@implementation MessageText

- (id)initWithFrame:(CGRect)frame{
  
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"");
        [self initView];
    }
    return self;
}
- (void)initView{
    [self initTextView];
    [self initUI];
}

- (void)initTextView{
    
    _messageTextView = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 360, SCREEN_HEIGHT - 60, 250, 40)];
    _messageTextView.backgroundColor = [UIColor grayColor];
    _messageTextView.keyboardType = UIKeyboardTypeDefault;
    _messageTextView.returnKeyType = UIReturnKeySend;
    
    _messageTextView.delegate = self.delegate;
    [self addSubview:_messageTextView];
    
}

- (void)initUI{
    UIButton *voice = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 60, 40, 40)];
    [voice setImage:[UIImage imageNamed:@"chat_bottom_PTT_nor@3x.png"] forState:UIControlStateNormal];
    
    UIButton *emotion = [[UIButton alloc]initWithFrame:CGRectMake(310, SCREEN_HEIGHT - 60, 40, 40)];
    [emotion setImage:[UIImage imageNamed:@"chat_bottom_emotion_nor@3x.png"] forState:UIControlStateNormal];
    
    UIButton *more = [[UIButton alloc]initWithFrame:CGRectMake(360, SCREEN_HEIGHT - 60, 40, 40)];
    [more setImage:[UIImage imageNamed:@"chat_bottom_more_nor@3x.png"] forState:UIControlStateNormal];
    
    [self addSubview:voice];
    [self addSubview:emotion];
    [self addSubview:more];
}
@end
