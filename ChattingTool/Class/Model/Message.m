//
//  Message.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/14.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        }
    return self;
}
+ (instancetype)messageWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
    }

+ (NSMutableArray *)messageList {
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    NSMutableArray *tempArray = [NSMutableArray array];
//定义一个前信息
    Message *preMessage;
    for (NSDictionary *dic in array) {
            Message *message = [Message messageWithDic:dic];
//判断前信息和当前信息是否相同，如相同即隐藏当前信息的时间frame
        if ([message.time isEqualToString:preMessage.time]) {
                message.hiddemTime = YES;
        }
        [tempArray addObject:message];
//获得前信息的数据
        preMessage = [tempArray lastObject];
    }
    return tempArray;
}

@end
