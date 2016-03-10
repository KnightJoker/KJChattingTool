//
//  ChattingViewController.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/9.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "ChattingViewController.h"
#import "PublicDefine.h"

@implementation ChattingViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initView{
    UITextField* message = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 380, SCREEN_HEIGHT - 80, 350, 40)];
    message.backgroundColor = [UIColor yellowColor];
    message.keyboardType = UIKeyboardTypeDefault;
    message.returnKeyType = UIReturnKeySend;
    
    [self.view addSubview:message];
    
    message.delegate = self;
    [self textFieldDidBeginEditing:message];
    [self textFieldDidEndEditing:message];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"开始编辑");
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 70);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    NSLog(@"结束编辑");
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}
@end
