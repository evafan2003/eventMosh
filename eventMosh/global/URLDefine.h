//
//  URLDefine.h
//  modelTest
//
//  Created by mosh on 13-10-29.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JSONKEY_RES     @"res"
#define JSONFEEDBACK    @"feedback"
#define Encrypt      YES
#define JSONLIST    @"list"

#define JSONKEY_DATA    @"data"
#define JSONKEY_SUCCESS    @"status"
#define JSONKEY_ERROR    @"errCode"
#define JSONKEY_TOKEN    @"token"

#define JSONSUCCESS     @"1"
#define JSONFAIL        @"0"
/*
 网址
 */

#define DESKEY                      @"98b515fb61daadb8"//加密用key

#define MOSHHOST        @"http://apie.mosh.cn/eventmosh/" //host
//#define MOSHHOST        @"http://api.inner.mosh.cn:30218/eventmosh/" //host
#define URL_USER        @"user=%@&pass=%@"
#define URL_PAGE                @"&page=%d"

#define URL_LOGIN               @"login?user=%@&pass=%@&code=%@"             //登录
#define URL_SENDPHONE               @"sendphone?user=%@&pass=%@"             //登录
#define URL_EVENTLIST           @"eventmanage?"                                 //活动列表 page
#define URL_DRAFT               @"draft?"                            //审核    page
#define URL_EVENTVIEW           @"eventview?"                        //详情eid(搜索)
#define URL_MANAGE              @"manage?"                           //活动修改eid post
#define URL_EVENTDEL              @"eventdel?"                           //活动删除 eid
#define URL_SUGGEST             @"suggest?"                          //咨询建议
#define URL_SUGGESTSHOW         @"suggestshow?"                      //咨询建议详情sid
#define URL_SUGGESTREPLY        @"suggestreply?"                      //回复建议sid
#define URL_ORDER               @"order?"                            //订单信息
#define URL_ORDERVIEW           @"orderview?"                      //订单详情eid
#define URL_ORDEREDIT           @"orderedit?"                      //咨询编辑eid
#define URL_TICKET              @"ticket?"                      //咨询建议详情eid
#define URL_GETTICKETLIST       @"getticketlist?"                      //查询票列表 page
#define URL_GETTICKET           @"getticketbyid?"                      //票详情
#define URL_SAVEMOD             @"savemod?"                      //修改票种信息
#define URL_POS                 @"pos?"                      //活动排名

#define URL_STATISTICALRESULT   @"http://e.mosh.cn/eapiiphone/eventcoutn?eid=%@&uid=%@"  //统计结果
//创建新的分销任务 如果任务名为空 则不添加只返回所有的分销任务
#define URL_ADDNEWPRATTASK              @"http://e.mosh.cn/eapiiphone/tasklist?eid=%@&task_name=%@&uid=%@"


@interface URLDefine : NSObject

@end
