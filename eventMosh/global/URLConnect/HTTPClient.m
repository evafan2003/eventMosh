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
#import "Draft.h"
#import "Faq.h"
#import "Order.h"

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

- (NSDictionary *) dicAnalyze:(id) jsonData arrayKey:(NSString *)key
{
    //json格式正确
    if ([GlobalConfig isKindOfNSDictionaryClassAndCountGreaterThanZero:jsonData]) {
        
        //成功
        NSNumber *number = [GlobalConfig convertToNumber:jsonData[JSONKEY_SUCCESS]];
        if ([number boolValue] == YES) {
            NSDictionary *dic = [GlobalConfig convertToDictionary:jsonData[key]];
            return dic;
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

/*
 活动列表
 page 加载的页数
 */
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

/*
 审核管理
 page 加载的页数
 eid,title,uid,username,startDate,endDate,status,class_id
 */
- (void) draftWithPage:(int)page
                search:(NSString *)search
               success:(void (^)(NSMutableArray *array))success {
    
    [_request beginRequestWithUrl:[self makeUrl:URL_DRAFT page:page addon:search] isAppendHost:YES isEncrypt:NO success:^(id jsondata){
        
        NSArray *array = [self listAnalyze:jsondata arrayKey:JSONKEY_RES];
        NSMutableArray *dataArray = [NSMutableArray new];
        for (NSDictionary *dic in array) {
            Draft *act = [[Draft alloc] initWithDictionary:dic];
            [dataArray addObject:act];
        }
        success(dataArray);
        
    } fail:^{
        success(nil);
        [GlobalConfig showAlertViewWithMessage:ERROR_LOADFAIL superView:nil];
    }];
}

/*
 审核详情
 eid 活动id
 */
- (void) eventWithId:(NSString *)eid
             success:(void (^)(NSDictionary *dic))success {
    
}

/*
 保存活动修改信息
 eid 活动id
 post方式
 */
- (void) manageEvent:(NSString *)eid
                 dic:(NSDictionary *)dic
             success:(void (^)(NSDictionary *dic))success
                fail:(void (^)(void))fail
{
    [_request postRequestWithUrl:[self makeUrl:URL_MANAGE page:0 addon:nil] dic:dic isAppendHost:YES isEncrypt:NO success:success fail:fail];

}
/*
 删除活动修改信息
 eid 活动id
 */
- (void) deleteEvent:(NSString *)eid
             success:(void (^)(NSDictionary *dic))success
                fail:(void (^)(void))fail
{
    [_request beginRequestWithUrl:[self makeUrl:URL_EVENTDEL page:0 addon:[NSString stringWithFormat:@"&eid=%@",eid]] isAppendHost:YES isEncrypt:NO success:success fail:fail];
    
}

/*
 咨询列表 page
 (搜索条件)class,state,uid,username,email
 */
- (void) faqWithPage:(int)page
              search:(NSString *)search
             success:(void (^)(NSMutableArray *array))success {
    [_request beginRequestWithUrl:[self makeUrl:URL_SUGGEST page:page addon:search] isAppendHost:YES isEncrypt:NO success:^(id jsondata){
        
        NSArray *array = [self listAnalyze:jsondata arrayKey:JSONKEY_RES];
        NSMutableArray *dataArray = [NSMutableArray new];
        for (NSDictionary *dic in array) {
            Faq *act = [[Faq alloc] initWithDictionary:dic];
            [dataArray addObject:act];
        }
        success(dataArray);
        
    } fail:^{
        success(nil);
        [GlobalConfig showAlertViewWithMessage:ERROR_LOADFAIL superView:nil];
    }];
}

/*
 咨询详情
 sid 咨询id
 */
- (void) faqWithId:(NSString *)sid
           success:(void (^)(NSDictionary *dic))success {
    [_request beginRequestWithUrl:[self makeUrl:URL_SUGGESTSHOW page:0 addon:[NSString stringWithFormat:@"&sid=%@",sid]] isAppendHost:YES isEncrypt:NO success:^(id jsondata){
        NSDictionary *dic = [self dicAnalyze:jsondata arrayKey:JSONKEY_RES];
        success(dic);
    } fail:^{
        success(nil);
        [GlobalConfig showAlertViewWithMessage:ERROR_LOADFAIL superView:nil];
    }];
}

/*
 咨询回复
 sid,reply_content,is_email,is_notice,reply_email
 */
- (void) replyFaq:(NSString *)eid
              dic:(NSDictionary *)dic
           sucess:(void (^)(NSString *str))success
             fail:(void (^)(void))fail {
    
    [_request postRequestWithUrl:[self makeUrl:URL_SUGGESTREPLY page:0 addon:nil] dic:dic isAppendHost:YES isEncrypt:NO success:success fail:fail];
}


/*
 订单管理
 page 加载的页数
 od,title,eid,name,startdate,enddate,status,class_id,uid,tel,is_mobile,order_from
 */
- (void) orderWithPage:(int)page
                search:(NSString *)search
               success:(void (^)(NSMutableArray *array))success {

    [_request beginRequestWithUrl:[self makeUrl:URL_ORDER page:page addon:search] isAppendHost:YES isEncrypt:NO success:^(id jsondata){
        
        NSArray *array = [self listAnalyze:jsondata arrayKey:JSONKEY_RES];
        NSMutableArray *dataArray = [NSMutableArray new];
        for (NSDictionary *dic in array) {
            Order *act = [[Order alloc] initWithDictionary:dic];
            [dataArray addObject:act];
        }
        success(dataArray);
        
    } fail:^{
        success(nil);
        [GlobalConfig showAlertViewWithMessage:ERROR_LOADFAIL superView:nil];
    }];
    
}

/*
 订单详情
 eid 活动id
 */
- (void) orderWithId:(NSString *)eid
             success:(void (^)(NSDictionary *dic))success {
    
}

/*
 订单编辑post
 oid,exit_explain
 */
- (void) replyOrder:(NSString *)oid
                dic:(NSDictionary *)dic
             sucess:(void (^)(NSString *str))success
               fail:(void (^)(void))fail {
    
}

/*
 票种管理
 page 加载的页数
 ticket_id,eid,tikcet_name,event_name,page
 */
- (void) ticketWithPage:(int)page
                 search:(NSString *)search
                success:(void (^)(NSMutableArray *array))success {
    
}

/*
 票详情
 eid 活动id
 */
- (void) ticketWithId:(NSString *)tid
              success:(void (^)(NSDictionary *dic))success {
    
}

/*
 票种编辑post
 oid,exit_explain
 */
- (void) replyTicket:(NSString *)oid
                 dic:(NSDictionary *)dic
              sucess:(void (^)(NSString *str))sucess {
    
}

/*
 活动排名
 selyear,selmonth,selweek,selday,type
 */
- (void) posEvent:(NSString *)eid
          success:(void (^)(NSDictionary *dic))success {
    
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
