//
//  ChattingViewController.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/9.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "ChattingViewController.h"
#import "PublicDefine.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
#import "FMDB.h"
#import "MessageTextView.h"

@interface ChattingViewController () <MessageTextDelegate>

@property (strong, nonatomic) UITextField *messageTextView;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <Message *> *messageList;   //Message数据源

@end

@implementation ChattingViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

#pragma mark - 键盘消息注册
- (void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification
                                                  object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - 各种初始化

- (void)initDataBase{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"AppConfig.sqlite"];
    FMDatabaseQueue* queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
    //    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    [queue inDatabase:^(FMDatabase *db){
        if ([db open]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ChatRecord(record text)"];
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            NSString *text = _messageTextView.text;
            BOOL insert = [db executeUpdate:@"insert into ChatRecord (record) values(?)",text];
            if (insert) {
                NSLog(@"插入数据成功");
                FMResultSet *rs = [db executeQuery:@"select * from ChatRecord"];
                while ([rs next]) {
                    NSLog(@"%@",[rs stringForColumn:@"record"]);
                }
            }else{
                NSLog(@"插入数据失败");
            }
            [db close];
        }
    }];
    
    
}

- (void)initView{
    
    [self initData];
    [self initTableView];
    [self initTextView];
    
}

- (void)initData {
    _messageList = [NSMutableArray array];
}

- (void)initTextView{
    
    MessageTextView *msgText = [[MessageTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    msgText.delegate = self;
    [self.view addSubview:msgText];
}
- (void)initTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 88) style:UITableViewStylePlain];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.allowsSelection = NO;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
}

#pragma mark - 键盘弹出或隐藏
- (void)handleKeyboardDidShow:(NSNotification *)notification {
    
    CGRect keyBoardRect=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
    
    NSLog(@"1111");
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - UITableViewDataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//控制一个section中有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}
//控制cell中的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.message = self.messageList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cbearxl_estimatedRowHeightForMessage:[self.messageList objectAtIndex:indexPath.row]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
}

#pragma mark - TextView delegate
- (void)textView:(MessageTextView *)messageText textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textView:(MessageTextView *)messageText textFieldDidEndEditing:(UITextField *)textField {

}

- (void)textViewTextFieldDidPressedReturnButton:(UITextField *)textField {

    Message *msg = [[Message alloc] init];
    msg.type = MessageTypeSelf;
    msg.text = textField.text;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    msg.time = [formatter stringFromDate:date];
    
    //判断前一条信息和当前信息的时间是否相同
    Message *preMessage = [self.messageList lastObject];
    if ([preMessage.time isEqualToString:msg.time]) {
        msg.hiddemTime = YES;
    }
    
    //消息数据源，只装消息，不装任何Frame相关内容
    [self.messageList addObject:msg];
    
    //重新加载数据
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0];
    //滚动显示最后一条数据
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    [self initDataBase];
}
#pragma mark - TextViewBtn delegate
- (void)speakBtnDidClick{
    NSLog(@"语音聊天");
}
- (void)speakBtnUnpressClick{
    NSLog(@"我要松手了！");
}
- (void)emotionBtnDidClick{
    NSLog(@"表情聊天");
}
- (void)moreBtnDidClick{
    NSLog(@"更多功能");
}
#pragma mark - Private
- (CGFloat)cbearxl_estimatedRowHeightForMessage:(Message *)message {
    MessageFrame *frame = [[MessageFrame alloc] init];
    frame.message = message;
    return frame.rowHeight;
}
@end
