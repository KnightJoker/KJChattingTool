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

@interface ChattingViewController () <MessageCellDelegate,MessageTextDelegate>{
    NSInteger _temp;
}

@property (strong, nonatomic) UITextField *messageTextView;
@property (strong, nonatomic) UITableView *tableView;

//录音器
@property (strong, nonatomic) AVAudioRecorder *recorder;
//播放器
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSDictionary *recorderSettingsDict;

//定时器
@property (strong, nonatomic) NSTimer *timer;
//录音名字
@property (strong, nonatomic) NSString *playName;
//Message数据源
@property (nonatomic,strong) NSMutableArray <Message *> *messageList;


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
    [self initPlayer];
    
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

- (void)initPlayer{

    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _playName = [NSString stringWithFormat:@"%@/play.aac",docDir];
    //录音设置
    _recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                           [NSNumber numberWithInt:1000.0],AVSampleRateKey,
                           [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
}

#pragma mark - 键盘弹出或隐藏
- (void)handleKeyboardDidShow:(NSNotification *)notification {
    
    CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    
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
#pragma mark - MessageCell delegate
- (void)voicePlayer{
    NSError *playerError;
    
    //播放
    _player = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_playName] error:&playerError];
    
    if (_player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }else{
        [_player play];
    }
    NSLog(@"DHOSDHA");
}


#pragma mark - TextViewBtn delegate
- (void)speakBtnDidClick{
    NSLog(@"语音聊天");
    //按下录音
    if ([self canRecord]) {
        
        NSError *error = nil;
 
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_playName] settings:_recorderSettingsDict error:&error];
        
        if (_recorder) {
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
            [_recorder record];
            
            //启动定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            
        } else
        {
            NSInteger errorCode = CFSwapInt32HostToBig ((uint32_t)[error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }
}
- (void)speakBtnUnpressClick{
    NSLog(@"我要松手了！");
    //松开 结束录音
    
    //录音停止
    [_recorder stop];
    _recorder = nil;
    //结束定时器
    [_timer invalidate];
    _timer = nil;
    
    Message *msg = [[Message alloc] init];
    msg.type = MessageTypeSelf;
    msg.text = nil;
    
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
}
- (void)emotionBtnDidClick{
    NSLog(@"表情聊天");
    
    NSError *playerError;
    
    //播放
    _player = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_playName] error:&playerError];
    
    if (_player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }else{
        [_player play];
    }
    
}
- (void)moreBtnDidClick{
    NSLog(@"更多功能");
//    [self viewDidAppear:YES];
    
}
#pragma mark - Private
- (CGFloat)cbearxl_estimatedRowHeightForMessage:(Message *)message {
    MessageFrame *frame = [[MessageFrame alloc] init];
    frame.message = message;
    return frame.rowHeight;
}

-(void)levelTimer:(NSTimer*)timer_
{
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [_recorder updateMeters];
    
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[[UIAlertView alloc] initWithTitle:nil
//                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"关闭"
//                                          otherButtonTitles:nil] show];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"设置成功" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}
@end
