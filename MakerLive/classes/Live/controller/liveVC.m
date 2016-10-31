//
//  liveVC.m
//  MakerLive
//
//  Created by maker on 16/10/22.
//  Copyright © 2016年 maker. All rights reserved.
//

#import "liveVC.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LiveItem.h"
#import "CreatorItem.h"
#import <UIImageView+WebCache.h>
@interface liveVC ()
@property(nonatomic,strong)UIImageView *imageView;//大图
@property(nonatomic,strong)IJKFFMoviePlayerController *player;//播放器

@end

@implementation liveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark   ==============创建 UI==============
- (void)initUI
{
    //占位图片
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = self.view.frame;
    [self.view addSubview:_imageView];
    _imageView.userInteractionEnabled = YES;
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",_live.creator.portrait]];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:0];
    backBtn.frame = CGRectMake(30, 30, 100, 40);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //拉流地址
    NSString *urlStr = self.streamUrl?self.streamUrl:_live.stream_addr;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //创建播放器
    IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    [playerVc prepareToPlay];
    _player = playerVc;
    playerVc.view.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:playerVc.view atIndex:1];
}

- (void)back
{
    [self dismissViewControllerAnimated:self completion:nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_player pause];
    [_player stop];
    [_player shutdown];
}

@end







