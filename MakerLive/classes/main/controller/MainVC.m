//
//  MainVC.m
//  MakerLive
//
//  Created by maker on 16/10/22.
//  Copyright © 2016年 maker. All rights reserved.
//

#import "MainVC.h"
#import "CaputureVC.h"
#import "BroadListVC.h"
#import "liveVC.h"
#import "showTimeVC.h"

@interface MainVC ()
@property(nonatomic,strong)UITextField *urlField;//输入框
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"maker直播";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

#pragma mark   ==============UI==============
- (void)initUI
{
    //播放
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:playBtn];
    playBtn.frame = CGRectMake(screenWidth-90, 94, 80, 38);
    [playBtn setTitle:@"播放" forState:0];
    [playBtn setBackgroundColor:[UIColor grayColor]];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    //输入框
    UITextField *field = [[UITextField alloc] init];
    [self.view addSubview:field];
    field.frame = CGRectMake(playBtn.x-10-200, playBtn.y, 200, 38);
    field.placeholder = @"输入直播流";
    field.text = @"rtmp://192.168.1.233:1990/liveApp/room";
    self.urlField = field;
    
    //映客
    UIButton *yingkeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:yingkeBtn];
    yingkeBtn.frame = CGRectMake((screenWidth -120)/2, 200, 120, 30);
    [yingkeBtn setTitle:@"映客" forState:0];
    [yingkeBtn setBackgroundColor:[UIColor grayColor]];
    [yingkeBtn addTarget:self action:@selector(yingkeList) forControlEvents:UIControlEventTouchUpInside];
    
    //采集
    UIButton *captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:captureBtn];
    captureBtn.frame = CGRectMake(yingkeBtn.x, yingkeBtn.bottom +30, yingkeBtn.width, yingkeBtn.height);
    [captureBtn setTitle:@"我要直播" forState:0];
    [captureBtn setBackgroundColor:[UIColor grayColor]];
    [captureBtn addTarget:self action:@selector(capture) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark   ==============播放事件==============
//映客列表
- (void)yingkeList
{
    BroadListVC *list = [[BroadListVC alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}
//直播
- (void)capture
{
//    CaputureVC *capture = [[CaputureVC alloc]init];
//    [self.navigationController pushViewController:capture animated:YES];
    showTimeVC *show = [[showTimeVC alloc] init];
    [self presentViewController:show animated:NO completion:nil];
}
//点击播放
- (void)play
{
    liveVC *live = [[liveVC alloc] init];
    live.streamUrl = self.urlField.text;
    [self presentViewController:live animated:NO completion:nil];
}

@end






