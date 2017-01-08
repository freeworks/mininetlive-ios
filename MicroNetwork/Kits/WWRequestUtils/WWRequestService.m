//
//  WWRequestService.m
//  MicroNetwork
//
//  Created by Lucas on 16/5/29.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWRequestService.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import "AFNetworking.h"
#import "NSUserDefaults+Signin.h"
#import "SVProgressHUD.h"


NSString *const kHttpMethodPOST = @"POST";
NSString *const kHttpMethodGET = @"GET";
NSString *const kMsg = @"msg";
NSString *const kRet = @"ret";



#define EXCEPTION_NAME @"Needs Overriding"
#define EXCEPTION_MSG @"Method %s must be overrided to provide concrete implementaion."

@implementation WWRequestService

#pragma mark - class methods
+ (NSString *)baseURL {
    [NSException raise:EXCEPTION_NAME format:EXCEPTION_MSG, __func__];
    return nil;
}

+ (NSString*)defaultHTTPMethod {
    return kHttpMethodPOST;
}

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        config.HTTPMaximumConnectionsPerHost = 1;
//        sharedManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        sharedManager = [AFHTTPSessionManager manager];
        sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        sharedManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        sharedManager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
        sharedManager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
        sharedManager.securityPolicy.validatesDomainName = NO;//是否验证域名
        [sharedManager.requestSerializer setValue:[NSUserDefaults standardUserDefaults].uid forHTTPHeaderField:@"uid"];
        [sharedManager.requestSerializer setValue:[NSUserDefaults standardUserDefaults].userToken forHTTPHeaderField:@"token"];
        [sharedManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        [sharedManager.requestSerializer setValue:[infoDictionary objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"verisonCode"];
        NSLog(@"头:%@",[infoDictionary objectForKey:@"CFBundleVersion"]);
        [sharedManager.requestSerializer setValue:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"CFBundleShortVersionString"];
        [sharedManager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"deviceId"];
        [sharedManager.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"os"];
        [sharedManager.requestSerializer setValue:[[UIDevice currentDevice] model] forHTTPHeaderField:@"model"];
        [sharedManager setSessionDidReceiveAuthenticationChallengeBlock:[self.class sessionDidReceiveAuthenticationChallengeBlock]];
        [sharedManager setTaskWillPerformHTTPRedirectionBlock:[self.class taskWillPerformHTTPRedirectionBlock]];
        [sharedManager setTaskDidReceiveAuthenticationChallengeBlock:[self.class taskDidReceiveAuthenticationChallengeBlock]];
    });
    return sharedManager;
}

+ (id)sessionDidReceiveAuthenticationChallengeBlock {
    id block = nil;
    return block;
}

+ (id)taskWillPerformHTTPRedirectionBlock {
    id block = nil;
    return block;
}

+ (id)taskDidReceiveAuthenticationChallengeBlock {
    id block = nil;
    return block;
}

+ (void)startDataTaskWithParameters:(NSDictionary *)parameters
                            apiPath:(NSString *)apiPath
                    completionBlock:(ServiceResponseBlock)block {
    [self.class requestWithParameters:parameters
                              apiPath:apiPath
                           HTTPMethod:[self defaultHTTPMethod]
                 serviceResponseBlock:block];
}

+ (void)startDataTaskWithParameters:(NSDictionary *)parameters
                            apiPath:(NSString *)apiPath
                         HTTPMethod:(NSString *)method
                    completionBlock:(ServiceResponseBlock)block {
    [self.class requestWithParameters:parameters
                              apiPath:apiPath
                           HTTPMethod:method
                 serviceResponseBlock:block];
}

+ (void)requestWithParameters:(NSDictionary *)parameters
                      apiPath:(NSString *)apiPath
                   HTTPMethod:(NSString *)method
         serviceResponseBlock:(ServiceResponseBlock)block {
    
    AFHTTPSessionManager *sharedManager = [self.class sharedManager];
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@/%@",[self.class baseURL], apiPath];
    
    if (block) {
        if ([method isEqualToString:kHttpMethodPOST]) {
            [self POSTRequestWithParameters:parameters URLString:URLString sharedManager:sharedManager ResponseBlock:block];
        } else  {
            [self GETRequestWithParameters:parameters URLString:URLString sharedManager:sharedManager ResponseBlock:block];
        }
    }
}

+ (void)POSTRequestWithParameters:(NSDictionary *)parameters URLString:(NSString *)URLString sharedManager:(AFHTTPSessionManager *)sharedManager ResponseBlock:(ServiceResponseBlock)block {
    
    [sharedManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self checkServerResponse:responseObject]) {
            return ;
        }
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (void)GETRequestWithParameters:(NSDictionary *)parameters URLString:(NSString *)URLString sharedManager:(AFHTTPSessionManager *)sharedManager ResponseBlock:(ServiceResponseBlock)block {
    [sharedManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self checkServerResponse:responseObject]) {
            return ;
        }
        block(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (void)uploadImage:(UIImage *)image
            apiPath:(NSString *)apiPath
serviceResponseBlock:(ServiceResponseBlock)block {
    AFHTTPSessionManager *sharedManager = [self.class sharedManager];
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@",[self.class baseURL], apiPath];
    if (block) {
        [self uploadImageWith:image URLString:URLString sharedManager:sharedManager ResponseBlock:block];
    }
}

+ (void)uploadImageWith:(UIImage *)image URLString:(NSString *)URLString sharedManager:(AFHTTPSessionManager *)sharedManager ResponseBlock:(ServiceResponseBlock)block {
    [sharedManager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"file/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+ (BOOL)checkServerResponse:(NSDictionary *)responseObject {
    NSDictionary *dic = responseObject;
    NSInteger ret = [dic[@"ret"] integerValue];
    if (ret == 1300) {
        [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        return YES;
    } else {
        return NO;
    }
}

@end

