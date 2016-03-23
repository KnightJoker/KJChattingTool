//
//  MessageFrame.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/14.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "MessageFrame.h"
#import "Message.h"
#import "PublicDefine.h"
#import "NSString+Ext.h"
#import "PublicDefine.h"

@implementation MessageFrame

/*
 重写set方法，设置fram
 */
- (void)setMessage:(Message *)message {
    _message = message;
    
//    //屏幕宽度
//    UIScreen *screen = [UIScreen mainScreen];
//    CGFloat screenW = screen.bounds.size.width;
    //间距
    CGFloat margin = 10;
    
    //时间frame
    if (!message.hiddemTime) {//如果时间不相同时，才设置时间的frame
        _timeFrame = CGRectMake(0, 10, SCREEN_WIDTH, 40);
    }
    
    //头像frame
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    CGFloat iconX;
    CGFloat iconY = CGRectGetMaxY(_timeFrame);
    if (message.type == MessageTypeSelf) {
        //自己的头像在右边，所以是屏幕的宽度减去间距，再减去头像的宽度
        iconX = SCREEN_WIDTH - margin - iconW;
    }else {
        iconX = margin;
    }
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //内容frame
    //取得内容的大小
    CGSize textSize = [message.text setTextSize:CGSizeMake(200, MAXFLOAT) andFontSize:TEXTFONT];
//    CGSize textSize = CGSizeMake(200, MAXFLOAT);
    //取得内容按钮的大小
    CGSize btnSize = CGSizeMake(textSize.width + 40, textSize.height + 40);
    CGFloat textX;
    //内容的Y值和头像的Y值是一样的
    CGFloat textY = iconY;
    if (message.type == MessageTypeSelf) {
        //自己的内容在右边，所以是头像的X值减去按钮的宽度，再减去间距
        textX = iconX - btnSize.width - margin;
    }else {
        //对方的内容在左边，所以是头像的宽度加上间距
        textX = iconW + margin;
    }
    _textFrame = CGRectMake(textX, textY, btnSize.width, btnSize.height);
    
    //行高
    //取得内容的最大Y值
    CGFloat textMax = CGRectGetMaxY(_textFrame);
    //取得头像的最大Y值
    CGFloat iconMax = CGRectGetMaxY(_iconFrame);
    //行高的多少是根据内容多少来判断的，内容少时是头像的最大Y值，内容过多时，就是内容的最大Y值了,所以用了一个MAX函数，取最大值
    _rowHeight = MAX(textMax, iconMax) + margin;
    
}
+ (NSMutableArray *)messageFrameList {
    NSArray *message = [Message messageList];
    NSMutableArray *tem = [NSMutableArray array];
    for (Message *msg in message) {
        MessageFrame *frame = [[MessageFrame alloc] init];
        frame.message = msg;
        [tem addObject:frame];
    }
    return tem;
}

@end
