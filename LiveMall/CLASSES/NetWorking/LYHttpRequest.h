//
//  LYHttpRequest.h
//  FotileCSS
//
//  Created by baobao on 16/08/31.
//  Copyright (c) 2016年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
//包含了post方式上传的实例方法
#import "AFHTTPSessionManager.h"

@protocol  LYHttpRequestDelegate <NSObject>

// NSURLConnectionDelegate的协议
@optional

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end

//AFNetWorking 请求成功Block
typedef void(^AFFinishedBlock)(NSURLSessionDataTask *oper, id responseObj);

//AFNetWorking 请求失败Block
typedef void(^AFFailedBlock)(NSURLSessionDataTask *oper, NSError *error);

@interface LYHttpRequest : NSObject
{
    NSURLConnection *_connection;
    
    //如果用post方式，就得用NSMutableURLRequest 请求
    NSMutableURLRequest *_mutRequest;
}

//属性
@property(strong,nonatomic)id<LYHttpRequestDelegate> delegate;

+ (void)requestWithUrlString:(NSString *)urlString parm:(id)dic finished:(AFFinishedBlock)finshedBlock failed:(AFFailedBlock)failedBlock;

@end
