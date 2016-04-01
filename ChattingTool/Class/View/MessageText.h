//
//  MessageText.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageText;

@protocol MessageTextDelegate <NSObject>

- (void)textView:(MessageText *)messageText textFieldDidBeginEditing:(UITextField *)textField;
- (void)textView:(MessageText *)messageText textFieldDidEndEditing:(UITextField *)textField;
- (void)textViewTextFieldDidPressedReturnButton:(UITextField *)textField;

@end

@interface MessageText : UIView <UITextFieldDelegate>

@property (nonatomic,assign)id <MessageTextDelegate> delegate;

@end
