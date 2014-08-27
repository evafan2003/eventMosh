//
//  HTTPClient.m
//  moshTickets
//
//  Created by 魔时网 on 13-11-14.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import "HTTPClient.h"
#import "GlobalConfig.h"
#import "Activity.h"

#define errorMessage = {@"-4":@"用户不存在",@"1":@"登录超时，请重新登录",,@"2":@"用户账号或密码错误",,@"":@"",,@"":@"",,@"":@"",,@"":@"",}

@implementation HTTPClient

+ (HTTPClient *) shareHTTPClient
{
    static HTTPClient *instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[HTTPClient alloc] init];
    });
    return instace;
}

- (id) init
{
    if (self = [super init]) {
        self.request = [ServerRequest serverRequest];
    }
    return self;
}

- (NSArray *) listAnalyze:(id) jsonData arrayKey:(NSString *)key
{
    //json格式正确
    if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:jsonData]) {
        
        //成功
        NSNumber *number = [GlobalConfig convertToNumber:jsonData[JSONKEY_SUCCESS]];
        if ([number boolValue] == YES) {
            NSArray *array = [GlobalConfig convertToArray:jsonData[key]];
            return array;
        }
        else {
            
        }
    }
    else {
        [GlobalConfig showAlertViewWithMessage:ERROR_LOADFAIL superView:nil];
    }
    return nil;

}

- (void) testWithUserName:(NSString *)userName
                  password:(NSString *)password
                   success:(void (^)(id jsonData))success
                      fail:(void (^)(void))fail
{
    [_request beginRequestWithUrl:[NSString stringWithFormat:URL_LOGIN,userName,password]
                     isAppendHost:YES
                        isEncrypt:YES
                          success:success
                             fail:fail];
}

-(void)loginWithUserName:(NSString *)userName
                password:(NSString *)password
                 success:(void (^)(id))success
                    fail:(void (^)(void))fail {
    
    [_request beginRequestWithUrl:[NSString stringWithFormat:URL_LOGIN,userName,password] isAppendHost:YES isEncrypt:NO success:success fail:fail];
}

- (void) eventListWithPage:(int)page
                   success:(void (^)(NSMutableArray *array))success
{
    [_request beginRequestWithUrl:[self makeUrl:URL_EVENTLIST page:page addon:nil] isAppendHost:YES isEncrypt:NO success:^(id jsondata){
    
         NSArray *array = [self listAnalyze:jsondata arrayKey:JSONKEY_RES];
        NSMutableArray *dataArray = [NSMutableArray new];
        for (NSDictionary *dic in array) {
            Activity *act = [[Activity alloc] initWithDictionary:dic];
            [dataArray addObject:act];
        }
        success(dataArray);
    
    } fail:^{
        success(nil);
        [GlobalConfig showAlertViewWithMessage:ERROR_LOADFAIL superView:nil];
    }];
}

//组合
-(NSString *) makeUrl:(NSString *)str page:(int)page addon:(NSString *)addon {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   str = [str stringByAppendingString:[NSString stringWithFormat:URL_USER,[defaults objectForKey:USER_USERNAME],[defaults objectForKey:USER_PASSWORD]]];
    if (page!=0) {
      str  =  [str stringByAppendingString:[NSString stringWithFormat:URL_PAGE,page]];
    }
    if (addon.length>1) {
       str = [str stringByAppendingString:addon];
    }
    return str;
}

@end
