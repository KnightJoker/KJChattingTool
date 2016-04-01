//
//  MainView.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/4/1.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainView;

@protocol MainViewDelegate <NSObject>

@required

- (void)mainView:(MainView *)view messageBtnDidClick:(id)sender;

@end

@interface MainView : UIView

@property(nonatomic,assign)id <MainViewDelegate> delegate;


@end
