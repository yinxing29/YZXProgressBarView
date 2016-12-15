//
//  YZXProgressBarView.m
//  YZXProgressBarView
//
//  Created by 尹星 on 2016/12/14.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "YZXProgressBarView.h"

#define center CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
#define center_X self.bounds.size.width / 2.0
#define center_Y self.bounds.size.height / 2.0

@interface YZXProgressBarView ()

/**
 记录type
 */
@property (nonatomic, assign) ProgressBarType     type;

/**
 layer（当type不是progressBar时，当为progressBar时是唯一的layer）
 */
@property (nonatomic, strong) CAShapeLayer        *progressBarLayer;

/**
 记录之前下载的进度
 */
@property (nonatomic, assign) CGFloat             beforeProgerss;

/**
 外环的layer（当type为loopProgressBar时是唯一的layer，当type为circularProgressBar时不显示，当type为tankFormProgressBar时和progressBarLayer一起显示）
 */
@property (nonatomic, strong) CAShapeLayer        *outerRingLayer;

@end

@implementation YZXProgressBarView

- (instancetype)initWithFrame:(CGRect)frame type:(ProgressBarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface
{
    if (self.type == progressBar) {//条形进度条
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.progressBarLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
        self.progressBarLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        [self.layer addSublayer:self.progressBarLayer];
    }else {
        self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
        self.progressBarLayer.frame = self.bounds;
        //初始化外环layer的path
        UIBezierPath *loopPath = [UIBezierPath bezierPathWithArcCenter:center radius:MIN(self.bounds.size.width, self.bounds.size.height) / 2.0 startAngle:-M_PI_2 endAngle:M_PI * 3.0 / 2.0 clockwise:YES];
        self.outerRingLayer.path = loopPath.CGPath;
        self.outerRingLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
        self.outerRingLayer.lineWidth = 2.0;
        self.outerRingLayer.strokeStart = 0;
        self.outerRingLayer.strokeEnd = 0;
        self.outerRingLayer.fillColor = [UIColor clearColor].CGColor;
        
        if (self.type == loopProgressBar) {//环形进度条
            [self.layer addSublayer:self.outerRingLayer];
        }
        
        //初始化圆形以及内胆形进度条的path
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (self.type == circularProgressBar) {
            [path addArcWithCenter:center radius:MIN(self.bounds.size.width, self.bounds.size.height) / 2.0 startAngle:-M_PI_2 endAngle:-M_PI_2 clockwise:YES];
            [self.layer addSublayer:self.progressBarLayer];
        }else if (self.type == tankFormProgressBar) {
            [path addArcWithCenter:center radius:MIN(self.bounds.size.width, self.bounds.size.height) / 2.0 startAngle:-M_PI_2 endAngle:-M_PI_2 clockwise:YES];
            self.outerRingLayer.strokeEnd = 1;
            self.outerRingLayer.backgroundColor = [UIColor clearColor].CGColor;
            [self.progressBarLayer addSublayer:self.outerRingLayer];
            [self.layer addSublayer:self.progressBarLayer];
        }
        self.progressBarLayer.path = path.CGPath;
        self.progressBarLayer.cornerRadius = MIN(self.progressBarLayer.bounds.size.width, self.progressBarLayer.bounds.size.height) / 2.0;
        self.progressBarLayer.fillColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    }
}

- (NSArray *)fillTheProgressBar:(CGFloat)proportion
{
    NSUInteger times = ceil(proportion * 60);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:times + 1];
    for (int number = 0; number <= times; number ++) {
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = (M_PI * 2 * _beforeProgerss - M_PI_2) + ((M_PI * 2 * (_loadingProgress - _beforeProgerss)) * number) / times;
        if (_type == circularProgressBar) {
            [array addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle radius:MIN(self.bounds.size.width, self.bounds.size.height)/2].CGPath)];
        }else {
            [array addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle radius:MIN(self.bounds.size.width, self.bounds.size.height)/2-5].CGPath)];
        }
    }
    return [NSArray arrayWithArray:array];
}

- (UIBezierPath *)pathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius
{
    BOOL clockwise = startAngle < endAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    [path closePath];
    return path;
}

#pragma mark - setter
- (void)setProgressBarBGC:(UIColor *)progressBarBGC
{
    if (_progressBarBGC != progressBarBGC) {
        _progressBarBGC = progressBarBGC;
    }
    if (self.type == progressBar) {
        self.backgroundColor = _progressBarBGC;
    }else if (self.type == loopProgressBar) {
        self.backgroundColor = _progressBarBGC;
    }else if (self.type == circularProgressBar) {
        self.backgroundColor = _progressBarBGC;
    }else if (self.type == tankFormProgressBar){
        self.backgroundColor = _progressBarBGC;
    }
}

- (void)setFillColor:(UIColor *)fillColor
{
    if (_fillColor != fillColor) {
        _fillColor = fillColor;
    }
    if (self.type == progressBar) {
        self.progressBarLayer.backgroundColor = _fillColor.CGColor;
    }else {
        _progressBarLayer.fillColor = _fillColor.CGColor;
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    if (_strokeColor != strokeColor) {
        _strokeColor = strokeColor;
    }
    if (self.type == loopProgressBar || self.type == tankFormProgressBar) {
        _outerRingLayer.strokeColor = _strokeColor.CGColor;
    }
}

- (void)setLoadingProgress:(CGFloat)loadingProgress
{
    if (_loadingProgress != loadingProgress) {
        _beforeProgerss = _loadingProgress;
        _loadingProgress = loadingProgress;
    }
    if (self.type == circularProgressBar || self.type == tankFormProgressBar) {
        NSMutableArray *paths = [NSMutableArray array];
        [paths addObjectsFromArray:[self fillTheProgressBar:0.5]];
        _progressBarLayer.path = (__bridge CGPathRef)((id)paths[(paths.count - 1)]);
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        [pathAnimation setValues:paths];
        [pathAnimation setDuration:0.5];
        [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [pathAnimation setRemovedOnCompletion:YES];
        [_progressBarLayer addAnimation:pathAnimation forKey:@"path"];
    }else {
        if (self.type == progressBar) {
            _progressBarLayer.frame = CGRectMake(0, 0, self.bounds.size.width * _loadingProgress, self.bounds.size.height);
        }
        _progressBarLayer.strokeEnd = _loadingProgress;
        _outerRingLayer.strokeEnd = _loadingProgress;
    }
}

#pragma mark - 初始化
- (CAShapeLayer *)progressBarLayer
{
    if (!_progressBarLayer) {
        _progressBarLayer = [CAShapeLayer layer];
    }
    return _progressBarLayer;
}

- (CAShapeLayer *)outerRingLayer
{
    if (!_outerRingLayer) {
        _outerRingLayer = [CAShapeLayer layer];
        _outerRingLayer.frame = self.bounds;
        _outerRingLayer.cornerRadius = MIN(self.outerRingLayer.bounds.size.width, self.outerRingLayer.bounds.size.height) / 2.0;
    }
    return _outerRingLayer;
}

@end
