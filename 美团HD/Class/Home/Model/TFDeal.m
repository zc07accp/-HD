//
//  TFDeal.m
//  美团HD
//
//  Created by Tengfei on 16/1/13.
//  Copyright © 2016年 tengfei. All rights reserved.
//

#import "TFDeal.h"
#import "MJExtension.h"

@implementation TFDeal
MJCodingImplementation
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}


- (BOOL)isEqual:(TFDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com