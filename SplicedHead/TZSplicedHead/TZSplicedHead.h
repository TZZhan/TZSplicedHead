//
//  TZSplicedHead.h
//  SplicedHead
//
//  Created by Tzhan on 15/7/23.
//  Copyright (c) 2015年 XiaoJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TZSplicedHead;
@protocol TZSplicedHeadDelegate <NSObject>

- (void)splicedHead:(TZSplicedHead *)splicedHead headImage:(UIImage *)headImage;

@end

@interface TZSplicedHead : NSObject

@property (nonatomic, assign) id<TZSplicedHeadDelegate> delegate;

/**
 *  单例构造方法
 *
 *  @return TZSplicedHead实例
 */
+ (instancetype)sharedManager;

/**
 *  拼接头像
 *
 *  @param imageArr 头像url
 */
- (void)spliceHeadWithImageArr:(NSArray *)imageArr;

@end
