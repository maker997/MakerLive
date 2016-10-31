//
//  showTimeVC.m
//  MakerLive
//
//  Created by maker on 16/10/25.
//  Copyright © 2016年 maker. All rights reserved.
//

#import "showTimeVC.h"
#import <LFLiveKit.h>

@interface showTimeVC ()<LFLiveSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *beautifulBtn;
@property (nonatomic,copy)NSString *rtmpUrl;/*推流的 URL*/
@property(nonatomic,strong)LFLiveSession *session;//推流会话
@property(nonatomic,strong)UIView *livingPreView;//预览图
@end

@implementation showTimeVC

//懒加载会话
- (LFLiveSession *)session
{
    if(!_session){
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
        _session.captureDevicePosition = AVCaptureDevicePositionBack;
    }
    return _session;
}

//懒加载预览视图
- (UIView *)livingPreView
{
    if (!_livingPreView) {
        UIView *livingPreView = [[UIView alloc] initWithFrame:self.view.bounds];
        livingPreView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:livingPreView atIndex:0];
        _livingPreView = livingPreView;
    }
    return _livingPreView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLive];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.session stopLive];
}

//开始直播
- (void)startLive
{
    LFLiveStreamInfo *stream = [[LFLiveStreamInfo alloc] init];
    stream.url = @"rtmp://192.168.1.233:1990/liveApp/room";
    self.rtmpUrl = stream.url;
    [self.session startLive:stream];
}

#pragma mark   ==============点击事件==============
//美颜
- (IBAction)beautifulClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.session.beautyFace = !self.session.beautyFace;
}

//切换摄像头
- (IBAction)changeCarmer:(UIButton *)sender {
    AVCaptureDevicePosition position = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (position == AVCaptureDevicePositionBack)?AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;
    NSLog(@"切换摄像头了");
}

//退出
- (IBAction)cancel:(UIButton *)sender {
    [self.session stopLive];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
