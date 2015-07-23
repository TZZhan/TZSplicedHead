//
//  TZSplicedHead.m
//  SplicedHead
//
//  Created by Tzhan on 15/7/23.
//  Copyright (c) 2015年 XiaoJian. All rights reserved.
//

#import "TZSplicedHead.h"

#define TZHeadHW 80

@interface TZSplicedHead ()


@end

@implementation TZSplicedHead

static dispatch_queue_t downloadImage_queue() {
    static dispatch_queue_t af_url_session_manager_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_url_session_manager_processing_queue = dispatch_queue_create("com.xiaojian.downloadImage", DISPATCH_QUEUE_SERIAL);
    });
    
    return af_url_session_manager_processing_queue;
}

- (void)spliceHeadWithImageArr:(NSArray *)imageArr
{
    dispatch_queue_t queue = downloadImage_queue();
    __weak __typeof(&*self)weakSelf = self;
    __block NSInteger totalCount = (imageArr.count > 9 ? 9 : imageArr.count);
    if (imageArr.count > 9) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 9; i++) {
            [arrM addObject:imageArr[i]];
        }
    }
    if (totalCount == 1) {
        return;
    }
    // 异步下载图片
    dispatch_async(queue, ^{
        // 创建一个组
        dispatch_group_t group = dispatch_group_create();
        // 关联一个任务到group
        __block NSMutableArray *imagesArrM = [NSMutableArray array];
        for (NSInteger i = 0; i < totalCount; i++) {
            dispatch_group_async(group, queue, ^{
                // 下载图片
                UIImage *image = [weakSelf imageWithURLString:imageArr[i]];
                if (image) {
                    [imagesArrM addObject:image];
                }
            });
        }
        // 等待组中的任务执行完毕,回到主线程执行block回调
        dispatch_group_notify(group, queue, ^{
            totalCount = imagesArrM.count;
            CGSize mainSize = CGSizeMake(TZHeadHW, TZHeadHW);
            NSMutableArray *pointArrM = [NSMutableArray array];
            CGFloat margin = 2;
            CGFloat width = (mainSize.width - 4 * 2) / 3;
            if (totalCount >= 7) {
                for (NSInteger i = 0; i < totalCount; i++) {
                    CGFloat x = i % 3 * (width + margin) + margin;
                    CGFloat y = i / 3 * (width + margin) + margin;
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", x]];
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", y]];
                }
            }
            if (totalCount == 6) {
                for (NSInteger i = 0; i < totalCount; i++) {
                    CGFloat x = i % 3 * (width + margin) + margin;
                    CGFloat y = i / 3 * (width + margin) + (mainSize.height - (margin + 2 * width)) / 2;
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", x]];
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", y]];
                }
            }
            if (totalCount == 5) {
                for (NSInteger i = 0; i < totalCount; i++) {
                    CGFloat x = 0.0;
                    CGFloat y = 0.0;
                    if (i == 0) {
                        x = (mainSize.width - (margin + 2 * width)) / 2;
                        y = (mainSize.width - (margin + 2 * width)) / 2;
                    }
                    if (i == 1) {
                        x = (mainSize.width - (margin + 2 * width)) / 2 + (margin + width);
                        y = (mainSize.width - (margin + 2 * width)) / 2;
                    }
                    if (i >= 2) {
                        x = (i + 1) % 3 * (width + margin) + margin;
                        y = (mainSize.width - (margin + 2 * width)) / 2 + (width + margin);
                    }
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", x]];
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", y]];
                }
            }
            if (totalCount == 4) {
                CGFloat width = (mainSize.width - 3 * margin) / 2;
                for (NSInteger i = 0; i < 4; i++) {
                    CGFloat x = i % 2 * (width + margin) + margin;
                    CGFloat y = i / 2 * (width + margin) + margin;
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", x]];
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", y]];
                }
            }
            if (totalCount == 3) {
                CGFloat width = (mainSize.width - 3 * margin) / 2;
                CGFloat x = 0.0;
                CGFloat y = 0.0;
                for (NSInteger i = 0; i < 3; i++) {
                    if (i == 0) {
                        x = (mainSize.width - width) / 2;
                        y = (mainSize.width - (margin + 2 * width)) / 2;
                    }
                    if (i >= 1) {
                        x = (i + 1) % 2 * (width + margin) + margin;
                        y = (i + 1) / 2 * (width + margin) + (mainSize.width - (margin + 2 * width)) / 2;
                    }
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", x]];
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", y]];
                }
            }
            if (totalCount == 2) {
                CGFloat width = (mainSize.width - 3 * margin) / 2;
                CGFloat x = 0.0;
                CGFloat y = 0.0;
                for (NSInteger i = 0; i < 3; i++) {
                    if (i == 0) {
                        x = margin;
                        y = (mainSize.width - width) / 2;
                    }
                    if (i == 1) {
                        x = width + 2 * margin;
                        y = (mainSize.width - width) / 2;
                    }
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", x]];
                    [pointArrM addObject:[NSString stringWithFormat:@"%f", y]];
                }
            }
            [weakSelf mergedImageOnMainImage:[UIImage imageNamed:@"headBg"] WithImageArray:[imagesArrM copy] AndImagePointArray:[pointArrM copy]];
        });
    });
}

// 根据url获取UIImage
- (UIImage *)imageWithURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    // 这里并没有自动释放UIImage对象
    return [[UIImage alloc] initWithData:data];
}

- (BOOL)mergedImageOnMainImage:(UIImage *)mainImg WithImageArray:(NSArray *)imgArray AndImagePointArray:(NSArray *)imgPointArray
{
    UIGraphicsBeginImageContext(CGSizeMake(TZHeadHW, TZHeadHW));
    [mainImg drawInRect:CGRectMake(0, 0, TZHeadHW, TZHeadHW)];
    int i = 0;
    for (UIImage *img in imgArray) {
        CGFloat width = 0.0;
        if (imgArray.count > 4) {
            width = (TZHeadHW - 4 * 2) / 3;
        } else {
            width = (TZHeadHW - 3 * 2) / 2;
        }
        [img drawInRect:CGRectMake([[imgPointArray objectAtIndex:i] floatValue],
                                   [[imgPointArray objectAtIndex:i+1] floatValue],
                                   width,
                                   width)];
        
        i+=2;
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([self.delegate respondsToSelector:@selector(splicedHead:headImage:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate splicedHead:self headImage:resultImage];
        });
    }
    
    return YES;
}

@end
