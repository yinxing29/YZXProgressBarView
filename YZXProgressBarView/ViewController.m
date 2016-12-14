//
//  ViewController.m
//  YZXProgressBarView
//
//  Created by 尹星 on 2016/12/14.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ViewController.h"
#import "YZXProgressBarView.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer     *timer;
@property (nonatomic, assign) float       progress;

@property (nonatomic, strong) YZXProgressBarView     *firstProgressBarView;
@property (nonatomic, strong) YZXProgressBarView     *secondProgressBarView;
@property (nonatomic, strong) YZXProgressBarView     *thirdProgressBarView;
@property (nonatomic, strong) YZXProgressBarView     *fourProgressBarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 100, 50);
    button.center = CGPointMake(self.view.center.x, 50);
    [button setTitle:@"重置" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _progress = 0;
    //条形进度条
    [self theProgressBar];
    //环形进度条
    [self loopProgressBar];
    //环形进度条
    [self circularProgressBar];
    //内胆形进度条
    [self theTankFormTheProgressBar];
    
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            weak_self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadingWithProgressBar) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] run];
        });
        
    });
}

- (void)buttonPressed
{
    _progress = 0;
    _firstProgressBarView.loadingProgress = _progress;
    _secondProgressBarView.loadingProgress = _progress;
    _thirdProgressBarView.loadingProgress = _progress;
    _fourProgressBarView.loadingProgress = _progress;
    
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weak_self.timer.fireDate = [NSDate date];
    });
}

//条形进度条
- (void)theProgressBar
{
    _firstProgressBarView = [[YZXProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 200, 2) type:progressBar];
    _firstProgressBarView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 8);
    _firstProgressBarView.progressBarBGC = [UIColor blueColor];
    _firstProgressBarView.fillColor = [UIColor redColor];
    [self.view addSubview:_firstProgressBarView];
}

//环形进度条
- (void)loopProgressBar
{
    _secondProgressBarView = [[YZXProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) type:loopProgressBar];
    _secondProgressBarView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 8 * 3);
    _secondProgressBarView.progressBarBGC = [UIColor blueColor];
    _secondProgressBarView.strokeColor = [UIColor redColor];
    [self.view addSubview:_secondProgressBarView];
}

//圆形进度条
- (void)circularProgressBar
{
    _thirdProgressBarView = [[YZXProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) type:circularProgressBar];
    _thirdProgressBarView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 8 * 5);
    _thirdProgressBarView.progressBarBGC = [UIColor blueColor];
    _thirdProgressBarView.fillColor = [UIColor redColor];
    [self.view addSubview:_thirdProgressBarView];
}

//内胆形进度条
- (void)theTankFormTheProgressBar
{
    _fourProgressBarView = [[YZXProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) type:tankFormProgressBar];
    _fourProgressBarView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 8 * 7);
    _fourProgressBarView.progressBarBGC = [UIColor yellowColor];
    _fourProgressBarView.fillColor = [UIColor blueColor];
    _fourProgressBarView.strokeColor = [UIColor redColor];
    [self.view addSubview:_fourProgressBarView];
}

- (void)loadingWithProgressBar
{
    _progress += 0.2;
    if (_progress <= 1.0) {
        _firstProgressBarView.loadingProgress = _progress;
        _secondProgressBarView.loadingProgress = _progress;
        _thirdProgressBarView.loadingProgress = _progress;
        _fourProgressBarView.loadingProgress = _progress;
    }else {
        //暂停
        _timer.fireDate = [NSDate distantFuture];
    }
}


@end
