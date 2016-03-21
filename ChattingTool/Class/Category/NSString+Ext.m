//
//  NSString+Ext.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/21.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString (Ext)
//取得字体的大小
- (CGSize)setTextSize:(CGSize)maxSize andFontSize:(CGFloat)fontSize {
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}
@end
