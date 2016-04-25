//
//  MessageText.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

//
////定义block块变量类型，用于回调,把本View上的按钮的index传到Controller中
//typedef void (^ToolIndex) (NSInteger index);

@class MessageTextView;

@protocol MessageTextDelegate <NSObject>

- (void)textView:(MessageTextView *)messageText textFieldDidBeginEditing:(UITextField *)textField;
- (void)textView:(MessageTextView *)messageText textFieldDidEndEditing:(UITextField *)textField;
- (void)textViewTextFieldDidPressedReturnButton:(UITextField *)textField;

- (void)speakBtnDidClick;
- (void)speakBtnUnpressClick;
- (void)emotionBtnDidClick;
- (void)moreBtnDidClick;
- (void)moreBtnUnPressClick;

@end

@interface MessageTextView : UIView <UITextFieldDelegate>

@property (nonatomic,assign)id <MessageTextDelegate> delegate;

////块变量类型的setter方法
//-(void)setToolIndex:(ToolIndex) toolBlock;

@end
