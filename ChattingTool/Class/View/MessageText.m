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
    [self initGesture];
}

- (void)initTextView{
    
    _messageTextView = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 360, SCREEN_HEIGHT - 60, 250, 40)];
    _messageTextView.backgroundColor = [UIColor grayColor];
    _messageTextView.keyboardType = UIKeyboardTypeDefault;
    _messageTextView.returnKeyType = UIReturnKeySend;
    
    _messageTextView.delegate = self;
    
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

- (void)initGesture{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
    
}
- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_messageTextView resignFirstResponder];
}

#pragma mark - UITextFieldDelegate方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //View内部UI改变
    
    //改变结束后，回调VC
    if ([_delegate respondsToSelector:@selector(textView:textFieldDidBeginEditing:)]) {
        [_delegate textView:self textFieldDidBeginEditing:textField];
    }
    
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //View内部UI改变
    
    //改变结束后，回调VC
    if ([_delegate respondsToSelector:@selector(textView:textFieldDidEndEditing:)]) {
        [_delegate textView:self textFieldDidEndEditing:textField];
    }
    NSLog(@"结束编辑");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //改变结束后，回调VC
    if ([_delegate respondsToSelector:@selector(textViewTextFieldDidPressedReturnButton:)]) {
        [_delegate textViewTextFieldDidPressedReturnButton:textField];
    }
    
    //View内部UI改变
    textField.text = @"";

    
    return YES;
}
@end
