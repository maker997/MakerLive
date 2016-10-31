//
//  CaputureVC.m
//  MakerLive
//
//  Created by maker on 16/10/22.
//  Copyright © 2016年 maker. All rights reserved.
//

#import "CaputureVC.h"
#import <AVFoundation/AVFoundation.h>

@interface CaputureVC ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
@property(nonatomic,strong)AVCaptureSession *captureSession;//会话
@property(nonatomic,strong)AVCaptureDeviceInput *currentVideoInput;//当前视频输入设备
@property(nonatomic,weak)UIImageView *focusImageView;//聚焦视图
@property(nonatomic,weak)AVCaptureVideoPreviewLayer *preLayer;// 预览图层
@property(nonatomic,weak)AVCaptureConnection *connection;// 连接

@end

@implementation CaputureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开直播喽";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCaputureVideo];
    
    //添加一个切换摄像头的按钮
    [self addChangeBtn];
}

//懒加载光标视图
- (UIImageView *)focusImageView
{
    if (_focusImageView == nil)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus"]];
        _focusImageView = img;
        [self.view addSubview:_focusImageView];
    }
    return _focusImageView;

}

- (void)addChangeBtn{
    UIButton *changeBtn = [[UIButton alloc] init];
    [self.view addSubview:changeBtn];
    [changeBtn setTitle:@"切换摄像头" forState:0];
    changeBtn.frame = CGRectMake(screenWidth -120, 64, 120, 30);
    [changeBtn addTarget:self action:@selector(changeCammer) forControlEvents:UIControlEventTouchUpInside];
}



//捕获音视频
- (void)setupCaputureVideo
{
    //1.创建会话,并强引用
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    _captureSession = session;
    
    //2.获取摄像头设备,默认是后置摄像头
   AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];
    
    //3.获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    //4.创建视频输入对象
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    _currentVideoInput = videoInput;
    
    //5.创建音频输入对象(音频输入设备没有强引用)
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    
    //6.将输入添加到会话中(先判断是否可添加)
    if ([session canAddInput:videoInput]) {
        [session addInput:videoInput];
    }
    if ([session canAddInput:audioInput]) {
        [session addInput:audioInput];
    }
    
    //7.创建视频输出,并设置代理
    //注意:必须是串行队列,否则不能捕获数据,而且不能为空
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Caputure Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    if ([session canAddOutput:videoOutput]) {
        [session addOutput:videoOutput];
    }
    
    //8.创建音频输出,并设置代理
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Caputure Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([session canAddOutput:audioOutput]) {
        [session addOutput:audioOutput];
    }
    
    //9.创建一个连接:调用视频输出的一个方法.连接的作用是用于分辨音视频数据
   _connection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //10.创建预览图层
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:preLayer atIndex:0];
    _preLayer = preLayer;
    
    //11.启动会话
    [session startRunning];
    
}
#pragma mark   ==============视频输出代理==============
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (_connection == connection) {
        NSLog(@"采集到视频数据");
    }else{
        NSLog(@"采集到音频数据");
    }
}

#pragma mark   ==============自定义方法==============
//1.根据方向获取摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

//2.设置聚焦光标的位置
- (void)setFocusWithPoint:(CGPoint)point
{
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusImageView.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        //设置还原
        self.focusImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusImageView.alpha = 0;//隐藏掉
    }];
}
//点击屏幕出现聚焦的视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1.获取手指的位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    //2.把当前位置设置为摄像头上的位置
    CGPoint cameraPoint = [_preLayer captureDevicePointOfInterestForPoint:point];
    
    //3.设置聚焦光标的位置
    [self setFocusWithPoint:point];
    
    //4.设置聚焦
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

//设置聚焦
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    AVCaptureDevice *caputureDevice = _currentVideoInput.device;
    
    //1.锁定配置
    [caputureDevice lockForConfiguration:nil];
    
    //2.设置聚焦
    //2.1判断是否支持自动聚焦
    if ([caputureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [caputureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    //2.2判断是否支持聚焦位置
    if ([caputureDevice isFocusPointOfInterestSupported]) {
        [caputureDevice setFocusPointOfInterest:point];
    }
    
    //3.设置曝光
    if ([caputureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [caputureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    if ([caputureDevice isExposurePointOfInterestSupported]) {
        [caputureDevice setExposurePointOfInterest:point];
    }
    
    //4.解锁配置
    [caputureDevice unlockForConfiguration];
    
}
#pragma mark   ==============点击事件==============
- (void)changeCammer
{
    //获取当前设置的方向
    AVCaptureDevicePosition curPosition = _currentVideoInput.device.position;
    
    //获取需要改变的方向
    AVCaptureDevicePosition togglePosition = curPosition == AVCaptureDevicePositionFront?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
    
    //获取要改变的摄像头设备
    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
    
    //获取要改变的输入设备
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
    
    //移除之前的摄像头设备
    [_captureSession removeInput:_currentVideoInput];
    
    //添加新的摄像头
    [_captureSession addInput:toggleDeviceInput];
    
    //记录当前设备
    _currentVideoInput = toggleDeviceInput;
    
}
@end








