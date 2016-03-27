//
//  MessageCell.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/14.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "MessageCell.h"
#import "PublicDefine.h"
#import "Message.h"
#import "MessageFrame.h"
#import "UIImage+Ext.h"

@interface MessageCell ()

@property (weak, nonatomic)UILabel* timeLabel;
@property (weak, nonatomic)UIButton* textBtn;
@property (weak, nonatomic)UIImageView* iconView;

@end
@implementation MessageCell


//创建可重用的cell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
//创建缓存池标识
    static NSString *resue = @"msg";
//当缓存池有空闲的cell时，可重用
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:resue];
//当缓存池内暂时没有空闲的cell时，自动创建
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resue];
        }
        return cell;
    }

//重写
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//清除背景颜色
        self.backgroundColor = [UIColor clearColor];
//初始化时间子控件
        UILabel *time = [[UILabel alloc] init];
        [self.contentView addSubview:time];
        self.timeLabel = time;
//把时间居中显示
        time.textAlignment = NSTextAlignmentCenter;
//初始化头像子控件
        UIImageView *img = [[UIImageView alloc] init];
        [self.contentView addSubview:img];
        self.iconView = img;
//设置头像的圆角
        img.layer.cornerRadius = 25;
//设置是否剪裁多余的部分
        img.layer.masksToBounds = YES;
//初始化内容子控件
        UIButton *text = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:text];
        self.textBtn = text;
        [text setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        text.titleLabel.numberOfLines = 0;
//设置内容的间距
        text.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
//设置内容的字体大小
        text.titleLabel.font = [UIFont systemFontOfSize:TEXTFONT];

        }
    return self;
}

- (void)setMessageList:(MessageFrame *)messageList{
    _messageList = messageList;
    [self setSubviewsContent];
    [self setSubviewsFrame];
}

- (void)setSubviewsContent {
    Message *msg = self.messageList.message;
    //给时间子控件赋值
    self.timeLabel.text = msg.time;
    
    //给头像子控件赋值
    self.iconView.image = [UIImage imageNamed:msg.type == MessageTypeSelf ? @"icon_me.jpg" :@"icon_me.jpg"];
    //给内容子控件赋值
    [self.textBtn setTitle:msg.text forState:UIControlStateNormal];
    //设置内容子控件的背景图片
    if (msg.type == MessageTypeSelf) {
        [self.textBtn setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
//        _textBtn.backgroundColor = [UIColor yellowColor];
        [self.textBtn setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateHighlighted];
    }else {
        [self.textBtn setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
        [self.textBtn setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateHighlighted];
    }
}
- (void)setSubviewsFrame {
    self.timeLabel.frame = self.messageList.timeFrame;
    self.iconView.frame = self.messageList.iconFrame;
    self.textBtn.frame = self.messageList.textFrame;
}

@end
