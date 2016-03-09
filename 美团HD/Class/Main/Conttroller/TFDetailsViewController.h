//
//  TFDetailsViewController.h
//  美团HD
//
//  Created by Tengfei on 16/1/17.
//  Copyright © 2016年 tengfei. All rights reserved.
//


/**
 *  团购列表的积累
 */
#import <UIKit/UIKit.h>

@interface TFDetailsViewController : UICollectionViewController

/**
 *  设置请求参数:交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com