//
//  NetWorking.m
//  FotileCSS
//
//  Created by baobao on 16/08/31.
//  Copyright (c) 2016年 baobao. All rights reserved.
//

#import "NetWorkingManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAssetExportSession.h>

/**
 * GET：获取资源，不会改动资源
 * POST：创建记录
 * PATCH：改变资源状态或更新部分属性
 * PUT：更新全部属性
 * DELETE：删除资源
 */
@implementation NetWorkingManager

static NetWorkingManager * defualt_shareMananger = nil;
+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        
        if (defualt_shareMananger == nil) {
            defualt_shareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        }
    });
    return defualt_shareMananger;
}

#pragma mark 重写
- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (self) {
        
        // 设置请求以及相应的序列化器
        //        self.requestSerializer = [AFJSONRequestSerializer serializer];
        //        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        // 设置相应的缓存策略--URL应该加载源端数据，不使用本地缓存数据,忽略缓存直接从原始地址下载。
        //        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        // 设置超时时间
        //        self.requestSerializer.timeoutInterval = 0.5;
        // 设置请求内容的类型-- 复杂的参数类型 需要使用json传值-设置请求内容的类型
        //        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // 设置请求内容的类型
        
        //注意：默认的Response为json数据
        //        AFJSONResponseSerializer *responseSerializer  = [AFJSONResponseSerializer serializer];
        // 在服务器返回json数据的时候，时常会出现null数据。json解析的时候，可能会将这个null解析成NSNull的对象，我们向这个NSNull对象发送消息的时候就会遇到crash的问题。
        //        responseSerializer.removesKeysWithNullValues = YES;
        //        self.responseSerializer = responseSerializer;
        
#pragma mark - 正常使用必须删除此处...
        /**
         *  允许使用自签名的不安全的证书...
         */
        //        self.securityPolicy.allowInvalidCertificates = YES;
        //        //也不验证域名一致性
        //        self.securityPolicy.validatesDomainName = NO;
        //        //关闭缓存避免干扰测试
        //        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        /**
         *  测试结束必须关闭此功能保证安全性...
         */
        
        // 设置apikey--类似于自己应用中的tokken---此处仅仅作为测试使用
        //        [self.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
        
        // 设置接受的类型
        //        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", @"application/json", @"text/json", @"text/javascript", @"text/html", nil]];
        
    }
    return self;
}

#pragma mark - GET 请求网络数据
/**
 *  请求网络数据
 *
 *  @param path             请求的地址
 *  @param paramters        请求的参数
 *  @param downLoadProgress 进度
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */

+ (void)requestGETDataWithPath:(NSString *)path
                 withParamters:(NSDictionary *)paramters
                  withProgress:(void(^) (float progress))downLoadProgress
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure  {
    
    [[NetWorkingManager shareManager] GET:path parameters:paramters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (downloadProgress) {
            
            downLoadProgress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma mark - POST 传送网络数据
/**
 *  传送网络数据
 *
 *  @param path           请求的地址
 *  @param paramters      请求的参数
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)sendPOSTDataWithPath:(NSString *)path
               withParamters:(NSDictionary *)paramters
                withProgress:(void(^) (float progress))upLoadProgress
                     success:(void(^) (BOOL isSuccess, id responseObject))success
                     failure:(void(^) (NSError *error))failure {
    
    [[NetWorkingManager shareManager] POST:path parameters:paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (uploadProgress) {
            
            upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma mark POST 上传图片
/**
 *  上传图片
 *
 *  @param path           上传的地址---需要填写完整的url
 *  @param paramters      上传图片预留参数---视具体情况而定，可移除
 *  @param imageArray     上传的图片数组
 *  @param width          图片要被压缩到的宽度
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)sendPOSTImageWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
               withImageArray:(NSArray *)imageArray
              withtargetWidth:(CGFloat )width
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess, id responseObject))success
                      failure:(void(^) (NSError *error))failure {
    
#pragma mark - 正常使用必须删除此处...
    /**
     *  允许使用自签名的不安全的证书...
     */
    //    [NetWorkingManager shareManager].securityPolicy.allowInvalidCertificates = YES;
    //    //也不验证域名一致性
    //    [NetWorkingManager shareManager].securityPolicy.validatesDomainName = NO;
    //    //关闭缓存避免干扰测试
    //    [NetWorkingManager shareManager].requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    /**
     *  测试结束必须关闭此功能保证安全性...
     */
//    [[NetWorkingManager shareManager].requestSerializer setValue:"token"] forHTTPHeaderField:@"Authorization"];
    
    [[NetWorkingManager shareManager] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        
        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
        for (UIImage * image in imageArray) {
            
            // 压缩图片，指定宽度（注释：imageCompressed：withdefineWidth：图片压缩的category）
            UIImage *  resizedImage = [UIImage imageCompressed:image withdefineWidth:width];
            NSData * imgData = UIImageJPEGRepresentation(resizedImage, 1);
            if (imgData == nil)
            {
                imgData = UIImagePNGRepresentation(image);
            }
            
            // 拼接Data
            [formData appendPartWithFileData:imgData name:@"file" fileName:[NSString stringWithFormat:@"IMG_000%lu.png",(unsigned long)i] mimeType:@"image/jpeg/text/html/png"];// File是form表格的标签...
            i++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (uploadProgress) upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)success(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) failure(error);
    }];
}

#pragma mark POST 上传视频
/**
 *  上传视频
 *
 *  @param path           上传的地址--需要填写完整的url
 *  @param videoPath      上传的视频--本地沙盒的路径
 *  @param paramters      上传视频预留参数--根据具体需求而定，可以出
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)sendPOSTImageWithPath:(NSString *)path
                withVideoPath:(NSString *)videoPath
                withParamters:(NSDictionary *)paramters
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess, id responseObject))success
                      failure:(void(^) (NSError *error))failure {
    
    [[NetWorkingManager shareManager] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //获得沙盒中的视频内容
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoPath] name:@"upload01" fileName:@"video.mp4" mimeType:@"video/mpeg4" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (uploadProgress) {
            
            upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        if (success) {
            
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma mark DOWNLOAD 文件下载
+ (void)requestDownLoadDataWithPath:(NSString *)path
                      withParamters:(NSDictionary *)paramters
                       withSavaPath:(NSString *)savePath
                       withProgress:(void(^) (float progress))downLoadProgress
                            success:(void(^) (BOOL isSuccess, id responseObject))success
                            failure:(void(^) (NSError *error))failure {
    
    [[NetWorkingManager shareManager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (downloadProgress)downLoadProgress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return  [NSURL URLWithString:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) failure(error);
    }];
}

#pragma mark - DELETE 删除资源
+ (void)requestDELETEDataWithPath:(NSString *)path
                    withParamters:(NSDictionary *)paramters
                          success:(void (^) (BOOL isSuccess, id responseObject))success
                          failure:(void (^) (NSError *error))failure {
    
    [[NetWorkingManager  shareManager] DELETE:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma mark - PUT 更新全部属性
+ (void)sendPUTDataWithPath:(NSString *)path
              withParamters:(NSDictionary *)paramters
                    success:(void(^) (BOOL isSuccess, id responseObject))success
                    failure:(void(^) (NSError *error))failure {
    
    [[NetWorkingManager shareManager] PUT:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma  mark - PATCH 改变资源状态或更新部分属性
+ (void)sendPATCHDataWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
                      success:(void (^) (BOOL isSuccess, id responseObject))success
                      failure:(void (^) (NSError *error))failure {
    [[NetWorkingManager shareManager] PATCH:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma mark - 取消网络请求--全部请求
+ (void)cancelAllNetworkRequest {
    
    [[NetWorkingManager shareManager].operationQueue cancelAllOperations];
}

#pragma mark - 取消网络请求--指定请求
/**
 *  取消指定的url请求
 *
 *  @param type 该请求的请求类型
 *  @param path 该请求的完整url
 */
+(void)cancelHttpRequestWithType:(NSString *)type WithPath:(NSString *)path {
    
    NSError * error;
    // 根据请求的类型 以及请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话那么就取消该请求
    NSString * urlToPeCanced = [[[[NetWorkingManager shareManager].requestSerializer requestWithMethod:type URLString:path parameters:nil error:&error] URL] path];
    
    for (NSOperation * operation in [NetWorkingManager shareManager].operationQueue.operations) {
        
        // 如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            // 请求的类型匹配
            BOOL hasMatchRequestType = [type isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            // 请求的url匹配
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            // 两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                
                [operation cancel];
            }
        }
    }
}

@end
