//
//  ServerRequest.m
//  modelTest
//
//  Created by mosh on 13-10-22.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "ServerRequest.h"
#import "GlobalConfig.h"
//#import "AFURLRequestSerialization.h"

@implementation ServerRequest

/*
 单例 暂不使用
 */
//+ (ServerRequest *) shareServerRequest
//{
//    static ServerRequest *_instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[ServerRequest alloc] init];
//    });
//    
//    return _instance;
//}


+ (ServerRequest *) serverRequest
{
    return [[ServerRequest alloc] init];
}


-(void)beginRequestWithUrl:(NSString *)urlStr
              isAppendHost:(BOOL)isAppendHost
                 isEncrypt:(BOOL)encrypt
                   success:(void (^)(id jsonData))success
                    fail:(void (^)(void))fail{
    
    //初始化
    self.jsonData = nil;
    self.requestSuccess = NO;
    
    //中文转码
    NSString *requestUrl = [GlobalConfig convertToString:urlStr];
    
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //加密
    if (encrypt) {
//        requestUrl = [self urlEncrypt:requestUrl];
//        requestUrl = [self appendingLoginHost:requestUrl];
    }
    
    //加服务器
    if (isAppendHost) {
       requestUrl = [self appendingMoshHost:requestUrl];
    }
    
    
    MOSHLog(@"%@",requestUrl);
    //加载
    [self serverRequestWithUrl:requestUrl success:success fail:fail];
}


//发送
-(void)postRequestWithUrl:(NSString *)urlStr
                      dic:(NSDictionary *)dic
              isAppendHost:(BOOL)isAppendHost
                 isEncrypt:(BOOL)encrypt
                   success:(void (^)(id jsonData))success
                      fail:(void (^)(void))fail{
    
    //初始化
    self.jsonData = nil;
    self.requestSuccess = NO;
    
    //中文转码
    NSString *requestUrl = [GlobalConfig convertToString:urlStr];
    
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //加密
    if (encrypt) {
//        requestUrl = [self urlEncrypt:requestUrl];
//        requestUrl = [self appendingLoginHost:requestUrl];
    }
    
    //加服务器
    if (isAppendHost) {
        requestUrl = [self appendingMoshHost:requestUrl];
    }
    
    
    MOSHLog(@"post: %@",requestUrl);
    //加载
    [self serverRequestWithUrl:requestUrl dic:dic success:success fail:fail];
    
}


//afnetworking加载

- (void) serverRequestWithUrl:(NSString *)str
                      success:(void (^)(id jsonData))success
                        fail:(void (^)(void))fail
{
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //成功
        self.jsonData = JSON;
        self.requestSuccess = YES;
        success(JSON);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,NSError *error, id JSON){
        //失败
        self.requestSuccess = NO;
        self.jsonData = nil;
        fail();
    }];
    [operation start];

}


//通过post方式提交数据
- (void) serverRequestWithUrl:(NSString *)str
                          dic:(NSDictionary *)dic
                      success:(void (^)(id jsonData))success
                         fail:(void (^)(void))fail
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];//这里要将url设置为空
    
//    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    httpClient.parameterEncoding = AFJSONParameterEncoding;
//    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
//    httpClient.stringEncoding = NSASCIIStringEncoding;
    
    [httpClient postPath:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        self.requestSuccess = YES;
        success(responseStr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.requestSuccess = NO;
        fail();
    }];
    
//    NSError *error = nil;

//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/json"]];
//    NSMutableURLRequest* request = [httpClient requestWithMethod:@"PUT" path:str parameters:dic];
//    
////    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
////    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dic options:0 error:&error]];
////    [request setHTTPMethod:@"PUT"];
//    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        success(response);
//
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        fail();
//    }];
//    
//    [operation start];

}


- (NSString *) appendingMoshHost:(NSString *)url
{
    return [MOSHHOST stringByAppendingString:url];
}


@end
