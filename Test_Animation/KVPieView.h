//
//  KVPieView.h
//  PieAnimation
//
//  Created by bairuitech on 2019/6/14.
//  Copyright © 2019年 Mr.Wendao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KVPieView;

NS_ASSUME_NONNULL_BEGIN

@protocol KVPieViewDelegate <NSObject>

- (void)KVPieView:(KVPieView*)pieView didCircleAroundWithIndex:(NSInteger)index;

- (void)KVPieView:(KVPieView*)pieView didStartAroundWithIndex:(NSInteger)index;
- (void)KVPieView:(KVPieView*)pieView didPauseAroundWithIndex:(NSInteger)index;
- (void)KVPieView:(KVPieView*)pieView didResumeAroundWithIndex:(NSInteger)index;
- (void)KVPieView:(KVPieView*)pieView didStopAroundWithIndex:(NSInteger)index;

@end

@interface KVPieView : UIView

#pragma mark - 播放资源操作方法

@property (nonatomic,strong) NSArray *textArray;
@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSArray *colorArray;

@property (nonatomic,weak) id<KVPieViewDelegate> delegate;

@property (nonatomic,assign) NSInteger time;

@property (nonatomic,assign)BOOL isPlaying;

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
         colorItems:(NSArray *)colorArray;

/**
 开始动画
 */
- (void)startPlay;

/**
 @brief 暂停资源播放
 @return 暂停操作状态返回信息
 */
- (NSInteger) pause;


/**
 @brief 恢复资源播放
 @return 恢复操作状态返回信息
 */
- (NSInteger) resume;

/**
 @brief 停止资源播放
 @return 停止操作状态返回信息
 */
- (NSInteger) stop;

@end

NS_ASSUME_NONNULL_END
