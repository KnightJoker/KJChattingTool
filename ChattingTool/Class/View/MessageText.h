//
//  MessageText.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageTextDelegate <NSObject>


@end

@interface MessageText : UIView

@property(nonatomic,assign)id <MessageTextDelegate> delegate;

@end
