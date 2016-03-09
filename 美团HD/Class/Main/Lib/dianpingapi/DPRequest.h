//
//  DPRequest.h
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DPAPI;
@protocol DPRequestDelegate;

@interface DPRequest : NSObject

#warning 增加2个请求的block
@property (nonatomic, copy) void (^success)(id json);
@property (nonatomic, copy) void (^failure)(NSError *error);

@property (nonatomic, unsafe_unretained) DPAPI *dpapi;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, unsafe_unretained) id<DPRequestDelegate> delegate;

+ (DPRequest *)requestWithURL:(NSString *)url
					   params:(NSDictionary *)params
					 delegate:(id<DPRequestDelegate>)delegate;

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

- (void)connect;

- (void)disconnect;

@end


@protocol DPRequestDelegate <NSObject>
@optional
- (void)request:(DPRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(DPRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error;
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com