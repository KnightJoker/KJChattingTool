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

@interface ChattingViewController ()

@property (strong, nonatomic) UITextField* messageTextView;
//@property (strong, nonatomic) UILabel* dialogLable;
@property (strong, nonatomic) UITableView* tableView;

@property (nonatomic,strong) NSMutableArray *messageFrame;

@end

@implementation ChattingViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

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

- (void)initView{
    
    [self initData];
    [self initTableView];
    [self initTextView];
    
}

- (void)initData {
    _messageFrame = [NSMutableArray array];
}

- (void)initTextView{
    _messageTextView = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 380, SCREEN_HEIGHT - 60, 350, 40)];
    _messageTextView.backgroundColor = [UIColor yellowColor];
    _messageTextView.keyboardType = UIKeyboardTypeDefault;
    _messageTextView.returnKeyType = UIReturnKeySend;
    _messageTextView.delegate = self;
    
    [self.view addSubview:_messageTextView];
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

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_messageTextView resignFirstResponder];
}

#pragma mark - UITableViewDataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.messageFrame.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrame.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.messageFrame = self.messageFrame[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrame *frame = self.messageFrame[indexPath.row];
    return frame.rowHeight;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
}

 #pragma mark - UITextFieldDelegate方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"结束编辑");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"%@",_messageTextView.text);
//    //    NSInteger temp = 80;
//    if ((temp >= 80) && (temp < (_messageTextView.frame.origin.y - 260))) {
//        _dialogLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - _messageTextView.text.length - 70, temp, _messageTextView.text.length + 50, 40)];
//        _dialogLable.backgroundColor = [UIColor yellowColor];
//        _dialogLable.text = _messageTextView.text;
//        [_messageTextView setText:@""];
//        [self.view addSubview:_dialogLable];
//        temp += 60;
//    }
//    
//    return YES;
    Message *msg = [[Message alloc] init];
    msg.type = MessageTypeSelf;
    msg.text = textField.text;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    msg.time = [formatter stringFromDate:date];
    
    //判断前一条信息和当前信息的时间是否相同
    Message *preMessage = (Message *)[[self.messageFrame lastObject] message];
    if ([preMessage.time isEqualToString:msg.time]) {
        msg.hiddemTime = YES;
    }
    
    MessageFrame *frame = [[MessageFrame alloc] init];
    frame.message = msg;
    [self.messageFrame addObject:frame];
    
    //重新加载数据
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageFrame.count - 1 inSection:0];
    //滚动显示最后一条数据
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return YES;
}
@end
