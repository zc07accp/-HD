//
//  MTDealCell.h
//  黑团HD
//
//  Created by apple on 14-8-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDeal, TFDeal,MTDealCell;


@protocol MTDealCellDelegate <NSObject>

@optional
-(void)dealCellCheckingStateDidChage:(MTDealCell *)cell;

@end

@interface MTDealCell : UICollectionViewCell
@property (nonatomic, strong) TFDeal *deal;

/**
 *  是否正在编辑
 */
//@property (nonatomic,assign,getter=isEditing)BOOL editing;


@property (nonatomic,weak)id <MTDealCellDelegate> delegate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com