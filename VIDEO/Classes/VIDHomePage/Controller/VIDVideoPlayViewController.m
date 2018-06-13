//
//  VIDVideoPlayViewController.m
//  VIDEO
//
//  Created by 崔一鸣 on 2018/6/12.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "VIDVideoPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VIDVideoPlayView.h"

typedef void(^propertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface VIDVideoPlayViewController () <AVCaptureFileOutputRecordingDelegate>
// UI 控件
@property (nonatomic, strong) VIDVideoPlayView *contentView;

// 负责输入和输出设备之间的数据传输
@property (nonatomic, strong) AVCaptureSession *captureSession;

// 负责从 AVCaptureDevice 中获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;

// 视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;

// 相机拍摄浏览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation VIDVideoPlayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView = [[VIDVideoPlayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_contentView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setContentViewButtonClickAction];
    
    [self initCamera];
    
    [self.captureSession startRunning];
}

#pragma mark - 初始化 UI

- (void)setContentViewButtonClickAction {
    [self.contentView.cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.exchangeButton addTarget:self action:@selector(clickExchangeButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 摄像头初始化

- (void)initCamera {
    _captureSession = [[AVCaptureSession alloc] init];
    // 设置分辨率
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    // 获得输入设备
    AVCaptureDevice *captureDevice = [self getCamerDeviceWithPosition:AVCaptureDevicePositionFront];
    if (!captureDevice) {
        NSLog(@"获取前置摄像头时出错");
        return;
    }
    NSError *error = nil;
    // 设置一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"获取设备输入对象时出错，出错原因：%@", error.localizedDescription);
        return;
    }
    
    // 设置输出设备
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    // 根据输入设备初始化输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因:%@", error.localizedDescription);
        return;
    }
    // 将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        // 设置录制模式
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            // 设置视频防抖模式为自动模式
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    // 将设备的输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    // 创建视频预览层，用于实施展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    CALayer *layer = self.contentView.layer;
    layer.masksToBounds = YES;
    _captureVideoPreviewLayer.frame = layer.bounds;
    // 填充模式
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 将视频预览层添加到界面上
    [layer insertSublayer:_captureVideoPreviewLayer below:self.contentView.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"录制完成");
    // 这里看需求 写保存视频
}

#pragma mark - 摄像头相关

// 给输入设备添加通知
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    // 注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    // 捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotification {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    // 会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureSession];
}

// 属性改变操作
- (void)changeDeviceProperty:(propertyChangeBlock)propertyChange {
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error = nil;
    // 注意改变设备属性之前一定要首先调用lockForConfiguration: 调用完之后使用unlockForConfiguration 方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息:%@", error.localizedDescription);
    }
}

// 获取指定位置的摄像头
- (AVCaptureDevice *)getCamerDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        return camera;
    }
    return nil;
}

// 设置聚焦模式
- (void)setFocusMode:(AVCaptureFocusMode)focusMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

// 设置曝光模式
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

// 设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

// 添加点击手势 点击时对焦
- (void)addGenstureRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.contentView addGestureRecognizer:tapGestureRecognizer];
}

- (void)setFocusCursorWithPoint:(CGPoint)point {
    self.contentView.focusCursor.center = point;
    self.contentView.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.contentView.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.contentView.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.contentView.focusCursor.alpha = 0;
    }];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 *
 */
- (void)deviceConnected:(NSNotification *)notification {
    NSLog(@"设备连接成功");
}

/**
 *  设备断开连接
 *
 *  @param notification 通知对象
 */
- (void)deviceDisConnected:(NSNotification *)notification {
    NSLog(@"设备断开连接");
}

/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
- (void)arreaChange:(NSNotification *)notification {
    NSLog(@"捕获区域改变");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
- (void)sessionRuntimeError:(NSNotification *)notification {
    NSLog(@"会话出错");
}

#pragma mark - 点击方法

- (void)tapScreen:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self.contentView];
    // 将 UI 坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    point.y += 124;
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeLocked exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

- (void)clickExchangeButton:(UIButton *)sender {
    AVCaptureDevice *currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCamerDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    
    // 获得要调整到设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    // 改变会话到配置 之前 一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    // 移除原有的输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    // 添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    
    // 提交新的输入对象
    [self.captureSession commitConfiguration];
}

- (void)clickPlayButton:(UIButton *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
