//
//  TestViewController.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/28.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "TestViewController.h"
#import "FMDB.h"

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //测试数据库连接读写
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"AppConfig.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    FMResultSet *rs = [db executeQuery:@"select * from MemberInfo"];
    while ([rs next]) {
        NSLog(@"%@",[rs stringForColumn:@"memberName"]);
    }
    [db close];
    
    
}

@end
