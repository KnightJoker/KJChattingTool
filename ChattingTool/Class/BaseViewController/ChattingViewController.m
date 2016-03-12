//
//  ChattingViewController.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/9.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "ChattingViewController.h"
#import "PublicDefine.h"

NSInteger temp = 80;
@interface ChattingViewController ()

@property (strong, nonatomic) UITextField* messageTextView;
@property (strong, nonatomic) UILabel* dialogLable;

@end

@implementation ChattingViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification
        object:nil];
    [super viewWillDisappear:animated];
}

- (void)initView{
    
    _messageTextView = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 380, SCREEN_HEIGHT - 80, 350, 40)];
    _messageTextView.backgroundColor = [UIColor yellowColor];
    _messageTextView.keyboardType = UIKeyboardTypeDefault;
    _messageTextView.returnKeyType = UIReturnKeySend;
    _messageTextView.delegate = self;
    
    [self.view addSubview:_messageTextView];
    
}
- (void)handleKeyboardDidShow:(NSNotification *)notification {
    
    NSDictionary *keyboardDic = notification.userInfo;
    CGFloat keyboardHeight = CGRectGetHeight([[keyboardDic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect textViewFrame = _messageTextView.frame;
        if (textViewFrame.origin.y > (SCREEN_HEIGHT - 80 - keyboardHeight)) {
            textViewFrame.origin.y -= keyboardHeight;
             _messageTextView.frame = textViewFrame;
        }
        
    }];
    
    NSLog(@"1111");
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {

    NSDictionary *keyboardDic = notification.userInfo;
    CGFloat keyboardHeight = CGRectGetHeight([[keyboardDic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect textViewFrame = _messageTextView.frame;
        if (textViewFrame.origin.y <= (SCREEN_HEIGHT - 80 - keyboardHeight)) {
            textViewFrame.origin.y += keyboardHeight;
            _messageTextView.frame = textViewFrame;
        }
    }];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_messageTextView resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    NSLog(@"结束编辑");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%@",_messageTextView.text);
//    NSInteger temp = 80;
    if ((temp >= 80) && (temp < (_messageTextView.frame.origin.y - 260))) {
        _dialogLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - _messageTextView.text.length - 70, temp, _messageTextView.text.length + 50, 40)];
        _dialogLable.backgroundColor = [UIColor yellowColor];
        _dialogLable.text = _messageTextView.text;
        [_messageTextView setText:@""];
        [self.view addSubview:_dialogLable];
        temp += 60;
    }
    
    return YES;
}
@end
