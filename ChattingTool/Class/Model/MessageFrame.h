//
//  MessageFrame.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/14.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Message;

@interface MessageFrame : NSObject

@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,assign) CGRect timeFrame;
@property (nonatomic,assign) CGRect iconFrame;
@property (nonatomic,assign) CGRect textFrame;
@property (nonatomic,strong) Message *message;

+ (NSMutableArray *)messageFrameList;

@end
