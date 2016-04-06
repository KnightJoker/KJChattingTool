//
//  MessageText.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageTextView;

@protocol MessageTextDelegate <NSObject>

- (void)textView:(MessageTextView *)messageText textFieldDidBeginEditing:(UITextField *)textField;
- (void)textView:(MessageTextView *)messageText textFieldDidEndEditing:(UITextField *)textField;
- (void)textViewTextFieldDidPressedReturnButton:(UITextField *)textField;

- (void)speakBtnDidClick;
- (void)speakBtnUnpressClick;
- (void)emotionBtnDidClick;
- (void)moreBtnDidClick;

@end

@interface MessageTextView : UIView <UITextFieldDelegate>

@property (nonatomic,assign)id <MessageTextDelegate> delegate;

@end
