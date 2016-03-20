//
//  TestViewController.m
//  ChattingTool
//
//  Created by 来自遥远星系的核心巡洋舰 on 16/3/20.
//  Copyright © 2016年 KnightJoker. All rights reserved.
//

#import "TestViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"

@interface TestViewController()

<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *messageFrame;

@end

@implementation TestViewController
#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - 懒加载
- (NSMutableArray *)messageFrame {
    if (!_messageFrame) {
        _messageFrame = [MessageFrame messageFrameList];
    }
    return _messageFrame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //订阅键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickTableView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)initView {
    UITableView *myTableView_=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    myTableView_.delegate=self;
    myTableView_.dataSource=self;
    myTableView_.backgroundColor = [UIColor yellowColor];
    //改变换行线颜色lyttzx.com
    myTableView_.separatorColor = [UIColor blueColor];
    //设定Header的高度，
    myTableView_.sectionHeaderHeight=50;
    //设定footer的高度，
    myTableView_.sectionFooterHeight=100;
    //设定行高
    myTableView_.rowHeight=100;
    //设定cell分行线的样式，默认为UITableViewCellSeparatorStyleSingleLine
    [myTableView_ setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //设定cell分行线颜色
    [myTableView_ setSeparatorColor:[UIColor redColor]];
    //编辑tableView
    myTableView_.editing=NO;
    
    [self.view addSubview:myTableView_];

    
}
//键盘frame发生改变时，view也跟着改变
- (void)clickTableView:(NSNotification *)noti {
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offX = frame.origin.y - self.view.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, offX);
    }];
}
//销毁订阅键盘通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UITableViewDataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageFrame.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.messageFrame = self.messageFrame[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate方法
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFrame *frame = self.messageFrame[indexPath.row];
    return frame.rowHeight;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
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

