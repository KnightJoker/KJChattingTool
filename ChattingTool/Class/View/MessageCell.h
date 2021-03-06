//
//  MessageCell.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/14.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;

@protocol MessageCellDelegate <NSObject>

- (void)voicePlayer;

@end

@interface MessageCell : UITableViewCell

@property (nonatomic,strong) Message *message;

@property (nonatomic,assign)id <MessageCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

