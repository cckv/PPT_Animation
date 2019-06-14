//
//  KVPieView.m
//  PieAnimation
//
//  Created by bairuitech on 2019/6/14.
//  Copyright © 2019年 Mr.Wendao. All rights reserved.
//

#import "KVPieView.h"

@interface KVPieView()<CAAnimationDelegate>

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIView *circleView;
@property (nonatomic,strong)UILabel *textLabel;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)UIColor *defaultColor;
@property (nonatomic,assign)NSInteger defaultTime;

//@property (nonatomic,assign)BOOL isPlaying;
@property (nonatomic,assign)BOOL isStop;
@property (nonatomic,assign)BOOL isPause;

@end

@implementation KVPieView

/**
 *  Pie
 *
 *  @param frame      frame
 *  @param dataItems  标题数据源
 *  @param timeArray  时间数据源
 *  @param colorItems 对应数据的pie的颜色
 *
 */
- (id)initWithFrame:(CGRect)frame
          textItems:(NSArray *)textArray
          timeItems:(NSArray *)timeArray
         colorItems:(NSArray *)colorArray
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.textArray = textArray;
        self.timeArray = timeArray;
        self.colorArray = colorArray;
        
        [self setDefaultData];
        
        self.currentIndex = 0;
        
        CGFloat centerWidth = frame.size.width * 0.5f;

        self.layer.cornerRadius = centerWidth;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];

        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:bgView];
        bgView.layer.cornerRadius = centerWidth;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.65;
        self.bgView = bgView;
        
        self.circleView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.circleView];
        
        self.circleView.layer.cornerRadius = centerWidth;
        self.circleView.alpha = 0.65;

        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        self.textLabel.textColor = [UIColor colorWithRed:((arc4random()%255)/255.0) green:((arc4random()%255)/255.0) blue:((arc4random()%255)/255.0) alpha:1];
        self.textLabel.text = @"开始";

    }
    return self;
}

#pragma mark - 设置默认值
- (void)setDefaultData
{
    self.defaultTime = 3;
    self.defaultColor = [UIColor colorWithRed:((arc4random()%255)/255.0) green:((arc4random()%255)/255.0) blue:((arc4random()%255)/255.0) alpha:1];
    
    if (self.timeArray.count==0) {
        
        NSMutableArray *tempTimeArray = [NSMutableArray arrayWithCapacity:self.textArray.count];
        for (int i = 0; i<self.textArray.count; i++) {
            [tempTimeArray addObject:@(self.defaultTime)];
        }
        self.timeArray = [tempTimeArray copy];
        
    }else{
        
        NSInteger differenceValue1 = self.textArray.count - self.timeArray.count;
        if (differenceValue1>0) {
            NSMutableArray *tempTimeArray = [self.timeArray mutableCopy];
            id data = self.timeArray.lastObject;
            for (int i = 0; i<differenceValue1; i++) {
                [tempTimeArray addObject:data];
            }
            self.timeArray = [tempTimeArray copy];
        }
    }
    
    if (self.colorArray.count<=0) {
        NSMutableArray *tempColorArray = [NSMutableArray arrayWithCapacity:self.textArray.count];
        for (int i = 0; i<self.textArray.count; i++) {
            [tempColorArray addObject:self.defaultColor];
        }
        self.colorArray = [tempColorArray copy];
    }else{
        NSInteger differenceValue2 = self.textArray.count - self.colorArray.count;
        if (differenceValue2>0) {
            NSMutableArray *tempTimeArray = [self.timeArray mutableCopy];
            id data = self.timeArray.lastObject;
            for (int i = 0; i<differenceValue2; i++) {
                [tempTimeArray addObject:data];
            }
            self.timeArray = [tempTimeArray copy];
        }
    }

}

#pragma mark - Action
/**
 开始动画
 */
- (void)startPlay
{
    if (self.isPlaying) {
        return;
    }
    self.currentIndex = 0;
    self.circleView.layer.mask = [self addAnimationWith:self.frame];
}

/**
 @brief 播放资源
 @return 播放操作状态返回信息
 */
- (NSInteger) play{
    
    self.circleView.layer.mask = [self addAnimationWith:self.frame];
    
    return self.currentIndex;
}

/**
 @brief 暂停资源播放
 @return 暂停操作状态返回信息
 */
- (NSInteger) pause{
    
    // 当前时间（暂停时的时间）
    // CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）,但它和系统的uptime有关,系统重启后CACurrentMediaTime()会被重置
    CFTimeInterval pauseTime = [self.circleView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 停止动画
    self.circleView.layer.speed = 0;
    // 动画的位置（动画进行到当前时间所在的位置，如timeOffset=1表示动画进行1秒时的位置）
    self.circleView.layer.timeOffset = pauseTime;
    
    self.isPlaying = NO;
    
    return self.currentIndex;
}


/**
 @brief 恢复资源播放
 @return 恢复操作状态返回信息
 */
- (NSInteger) resume{

    // 动画的暂停时间
    CFTimeInterval pausedTime = self.circleView.layer.timeOffset;
    // 动画初始化
    self.circleView.layer.speed = 1;
    self.circleView.layer.timeOffset = 0;
    self.circleView.layer.beginTime = 0;
    // 程序到这里，动画就能继续进行了，但不是连贯的，而是动画在背后默默“偷跑”的位置，如果超过一个动画周期，则是初始位置
    // 当前时间（恢复时的时间）
    CFTimeInterval continueTime = [self.circleView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 暂停到恢复之间的空档
    CFTimeInterval timePause = continueTime - pausedTime;
    // 动画从timePause的位置从动画头开始
    self.circleView.layer.beginTime = timePause;
    
    self.isPlaying = YES;

    return self.currentIndex;
}

/**
 @brief 停止资源播放
 @return 停止操作状态返回信息
 */
- (NSInteger) stop{
    self.isStop = YES;
    self.circleView.layer.mask = nil;
    self.circleView.backgroundColor = [UIColor clearColor];
    return self.currentIndex;
}

#pragma mark - CAAnimation
/**
 @brief
 @return
 */
- (CAShapeLayer*)addAnimationWith:(CGRect)frame
{
    //1.pieView中心点
    CGFloat centerWidth = frame.size.width * 0.5f;
    CGFloat centerHeight = frame.size.height * 0.5f;
    CGFloat centerX = centerWidth;
    CGFloat centerY = centerHeight;
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    
    CGFloat bgRadius = centerWidth;
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                          radius:bgRadius
                                                      startAngle:-M_PI_2
                                                        endAngle:M_PI_2 * 3
                                                       clockwise:YES];
    
    CAShapeLayer *_bgCircleLayer  = [CAShapeLayer layer];
    _bgCircleLayer.fillColor      = [UIColor clearColor].CGColor;
    _bgCircleLayer.strokeColor    = [UIColor lightGrayColor].CGColor;
    _bgCircleLayer.strokeStart    = 0.0f;
    _bgCircleLayer.strokeEnd      = 1.0f;
    _bgCircleLayer.zPosition      = 1;
    _bgCircleLayer.lineWidth      = bgRadius * 2.0f;
    _bgCircleLayer.path           = bgPath.CGPath;
    
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration            = [self.timeArray[self.currentIndex]integerValue];
    animation.fromValue           = @0.0f;
    animation.toValue             = @1.0f;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];// 动画速度类型
    animation.removedOnCompletion = YES;
    animation.delegate            = self;
    [_bgCircleLayer addAnimation:animation forKey:@"circleAnimation"];
    return _bgCircleLayer;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    self.isPlaying = YES;
    self.circleView.backgroundColor = self.colorArray[self.currentIndex];
    self.textLabel.text = self.textArray[self.currentIndex];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    // 设置底图的背景颜色
    self.bgView.backgroundColor = self.colorArray[self.currentIndex];
    
    if (self.isStop) {
        return;
    }
    
    self.currentIndex += 1;
    
    if (self.currentIndex < self.textArray.count) {
        [self play];
    }
    
    if (flag) { // 完成一个周期
        
        self.isPlaying = NO;
        
        if ([self.delegate respondsToSelector:@selector(KVPieView:didCircleAroundWithIndex:)]) {
            [self.delegate KVPieView:self didCircleAroundWithIndex:self.currentIndex];
        }
    }
    
}

@end
