//
//  UIImage+Ext.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/21.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "UIImage+Ext.h"

@implementation UIImage (Ext)
//平铺图片，改变图片的大小
+ (UIImage *)setImage:(NSString *)name {
    UIImage *imageName = [UIImage imageNamed:name];
    return [imageName stretchableImageWithLeftCapWidth:imageName.size.width * 0.5 topCapHeight:imageName.size.height * 0.5];
}
@end
