//
//  Message.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/14.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageTypeSelf,
    MessageTypeOther
}MessageType;

@interface Message : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,assign) MessageType type;
@property (nonatomic,assign,getter = isHiddemTime) BOOL hiddemTime;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)messageWithDic:(NSDictionary *)dic;
+ (NSMutableArray *)messageList;

@end
