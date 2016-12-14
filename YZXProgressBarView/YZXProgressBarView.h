//
//  YZXProgressBarView.h
//  YZXProgressBarView
//
//  Created by 尹星 on 2016/12/14.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger) {
    progressBar = 0,//条形
    loopProgressBar = 1,//环形
    circularProgressBar = 2,//圆形
    tankFormProgressBar = 3,//内胆型
}ProgressBarType;

@interface YZXProgressBarView : UIView

/**
 初始化progress

 @param frame 设置坐标及大小
 @param type 选择progress的类型
 @return 返回自己
 */
- (instancetype)initWithFrame:(CGRect)frame type:(ProgressBarType)type;

/**
 进度条背景颜色
 */
@property (nonatomic, strong) UIColor      *progressBarBGC;

/**
 下载进度条颜色
 */
@property (nonatomic, strong) UIColor      *fillColor;

/**
 边框颜色
 */
@property (nonatomic, strong) UIColor      *strokeColor;

/**
 下载进度
 */
@property (nonatomic, assign) CGFloat      loadingProgress;

@end
