//
//  MTDealTool.h
//  美团HD
//
//  Created by apple on 14/11/27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFDeal;

@interface MTDealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(TFDeal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(TFDeal *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(TFDeal *)deal;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com