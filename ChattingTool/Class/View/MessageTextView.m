//
//  MessageText.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "MessageTextView.h"
#import "PublicDefine.h"

@interface MessageTextView ()

@property (strong, nonatomic) UITextField *messageTextView;

@property (strong, nonatomic)   UIButton *voice;
@property (strong, nonatomic)   UIButton *emotion;
@property (strong, nonatomic)   UIButton *more;

@end

@implementation MessageTextView

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
    [self initGesture];
    //test
}

- (void)initTextView{
    
    _messageTextView = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 360, SCREEN_HEIGHT - 60, 250, 40)];
    _messageTextView.backgroundColor = [UIColor grayColor];
    _messageTextView.keyboardType = UIKeyboardTypeASCIICapable;
    _messageTextView.returnKeyType = UIReturnKeySend;
    
    _messageTextView.delegate = self;
    
    [self addSubview:_messageTextView];
    
}


- (void)initUI{
    _voice = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 60, 40, 40)];
    [_voice setImage:[UIImage imageNamed:@"chat_bottom_PTT_nor@3x.png"] forState:UIControlStateNormal];
    _voice.tag = 1;
    
    _emotion = [[UIButton alloc]initWithFrame:CGRectMake(310, SCREEN_HEIGHT - 60, 40, 40)];
    [_emotion setImage:[UIImage imageNamed:@"chat_bottom_emotion_nor@3x.png"] forState:UIControlStateNormal];
    
    _more = [[UIButton alloc]initWithFrame:CGRectMake(360, SCREEN_HEIGHT - 60, 40, 40)];
    [_more setImage:[UIImage imageNamed:@"chat_bottom_more_nor@3x.png"] forState:UIControlStateNormal];
    
    [self addSubview:_voice];
    [self addSubview:_emotion];
    [self addSubview:_more];
    
    [_voice addTarget:self action:@selector(voiceBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_emotion addTarget:self action:@selector(emotionBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_more addTarget:self action:@selector(moreBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initGesture{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
    
}
- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_messageTextView resignFirstResponder];
}

#pragma mark - 按钮事件处理

//语音按钮
- (void)voiceBtnDidClick:(id)sender{
    if (_voice.tag == 1) {
        [_voice setImage:[UIImage imageNamed:@"chat_bottom_PTT_press@3x.png"] forState:UIControlStateNormal];
        _voice.tag = 0;
        
        UIButton *speak = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 360, SCREEN_HEIGHT - 60, 250, 40)];
        [speak setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self addSubview:speak];
        [speak addTarget:self action:@selector(speakBtnDidClick:) forControlEvents:UIControlEventTouchDown];
        [speak addTarget:self action:@selector(speakBtnUnpressClick:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
    }
    else{
        [_voice setImage:[UIImage imageNamed:@"chat_bottom_PTT_nor@3x.png"] forState:UIControlStateNormal];
        _voice.tag = 1;
        [self addSubview:_messageTextView];
        
    }
}

- (void)speakBtnDidClick:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(speakBtnDidClick)]) {
        [_delegate speakBtnDidClick];
    }
}
- (void)speakBtnUnpressClick:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(speakBtnUnpressClick)]) {
        [_delegate speakBtnUnpressClick];
    }
}

//表情按钮
- (void)emotionBtnDidClick:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(emotionBtnDidClick)]) {
        [_delegate emotionBtnDidClick];
    }
}

//更多按钮
- (void)moreBtnDidClick:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(moreBtnDidClick)]) {
        [_delegate moreBtnDidClick];
    }
}

#pragma mark - UITextFieldDelegate方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //View内部UI改变
    
    //改变结束后，回调VC
    if (_delegate && [_delegate respondsToSelector:@selector(textView:textFieldDidBeginEditing:)]) {
        [_delegate textView:self textFieldDidBeginEditing:textField];
    }
    
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //View内部UI改变
    
    //改变结束后，回调VC
    if (_delegate && [_delegate respondsToSelector:@selector(textView:textFieldDidEndEditing:)]) {
        [_delegate textView:self textFieldDidEndEditing:textField];
    }
    NSLog(@"结束编辑");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //改变结束后，回调VC
    if (_delegate && [_delegate respondsToSelector:@selector(textViewTextFieldDidPressedReturnButton:)]) {
        [_delegate textViewTextFieldDidPressedReturnButton:textField];
    }
    
    //View内部UI改变
    textField.text = @"";

    
    return YES;
}
@end
