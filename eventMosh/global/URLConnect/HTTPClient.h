//
//  HTTPClient.h
//  moshTickets
//
//  Created by 魔时网 on 13-11-14.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"   
#import "CacheHanding.h"
#import "UIImageView+AFNetworking.h"
#import "URLDefine.h"
#import "UserInfo.h"
#import "ActivityStatistical.h"

typedef void (^Success)(id jsonData);

@interface HTTPClient : NSObject

@property (nonatomic, strong) ServerRequest *request;


/*
 单例
 */
+ (HTTPClient *) shareHTTPClient;

/*
 登录
 name 用化名
 password 密码
 */
- (void) loginWithUserName:(NSString *)userName
                  password:(NSString *)password
                 phoneCode:(NSString *)phoneCode
                   success:(void (^)(id jsonData))success
                      fail:(void (^)(void))fail;

/*
 登录
 name 用化名
 password 密码
 */
- (void) sendPhoneCodeWithUserName:(NSString *)userName
                                       password:(NSString *)password
                                        success:(void (^)(id jsonData))success
                         fail:(void (^)(void))fail;

/*
 活动列表
 page 加载的页数
 */
- (void) eventListWithPage:(int)page
                    search:(NSString *)search
                   success:(void (^)(NSMutableArray *array))success;
/*
 审核管理
 page 加载的页数
 搜索条件 eid,title,uid,username,startDate,endDate,status,class_id
 */
- (void) draftWithPage:(int)page
                search:(NSString *)search
                   success:(void (^)(NSMutableArray *array))success;


/*
 审核详情
 eid 活动id
 */
- (void) eventWithId:(NSString *)eid
                      success:(void (^)(NSDictionary *dic))success;

/*
 保存活动修改信息
 eid 活动id
 post方式
 */
- (void) manageEvent:(NSString *)eid
                 dic:(NSDictionary *)dic
             success:(void (^)(NSDictionary *dic))success
                fail:(void (^)(void))fail;

/*
 删除活动修改信息
 eid 活动id
 */
- (void) deleteEvent:(NSString *)eid
             success:(void (^)(NSDictionary *dic))success
                fail:(void (^)(void))fail;

/*
 咨询列表 page
 (搜索条件)class,state,uid,username,email
 */
- (void) faqWithPage:(int)page
              search:(NSString *)search
             success:(void (^)(NSMutableArray *array))success;

/*
 咨询详情
 sid 咨询id
 */
- (void) faqWithId:(NSString *)sid
             success:(void (^)(NSDictionary *dic))success;

/*
 咨询回复
 sid,reply_content,is_email,is_notice,reply_email
 */
- (void) replyFaq:(NSString *)eid
              dic:(NSDictionary *)dic
           sucess:(void (^)(NSString *str))success
             fail:(void (^)(void))fail;


/*
 订单管理
 page 加载的页数
 od,title,eid,name,startdate,enddate,status,class_id,uid,tel,is_mobile,order_from
 */
- (void) orderWithPage:(int)page
             search:(NSString *)search
               success:(void (^)(NSMutableArray *array))success;

/*
 订单详情
 eid 活动id
 */
- (void) orderWithId:(NSString *)eid
             success:(void (^)(NSDictionary *dic))success;


/*
 订单编辑post
 oid,exit_explain
 */
- (void) replyOrder:(NSString *)oid
                dic:(NSDictionary *)dic
             sucess:(void (^)(NSString *str))success
               fail:(void (^)(void))fail;

/*
 票种管理
 page 加载的页数
 ticket_id,eid,tikcet_name,event_name,page
 */
- (void) ticketWithPage:(int)page
             search:(NSString *)search
               success:(void (^)(NSMutableArray *array))success;

- (void) searchTicketWithPage:(int)page
                 search:(NSString *)search
                success:(void (^)(NSMutableArray *array))success;

/*
 票详情
 eid 活动id
 */
- (void) ticketWithId:(NSString *)tid
             success:(void (^)(NSDictionary *dic))success;


/*
 票种编辑post
 oid,exit_explain
 */
- (void) replyTicket:(NSString *)tid
                dic:(NSDictionary *)dic
              sucess:(void (^)(NSString *str))success
                fail:(void (^)(void))fail;


/*
 活动排名
 selyear,selmonth,selweek,selday,type
 */
- (void) posEvent:(NSString *)search
          success:(void (^)(NSDictionary *dic))success;

/*
 统计结果
 */
- (void) statisticalResultWithEid:(NSString *)eid
                              uid:(NSString *)uid
                          success:(void (^)(ActivityStatistical *sta))success;



////得到最后一次加载时间
//- (NSNumber *) getLastDownloadDateWithKey:(NSString *)key;
//
////保存最后一次加载时间
//- (void) saveLastDownloadDate:(NSNumber *)time key:(NSString *)key;
@end