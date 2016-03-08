//
//  DetailViewController.h
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/8.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

