//
//  MoshTicketDatabase.h
//  MoshTicket
//
//  Created by evafan2003 on 12-6-27.
//  Copyright (c) 2012年 bbdtek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "MemberInfo.h"

#define DB_NAME @"eventMosh.db"
#define TABLE_TICKET @"tickets"
#define TABLE_MEMBER @"members"
#define OLD_TICKET @"ticket"

@interface MoshTicketDatabase : NSObject {

    FMDatabase *db;
    FMDatabaseQueue *dbQueue;
     
}

+ (MoshTicketDatabase *)sharedInstance;

/**
 *  删除表
 *
 *  @param tableName 表名
 */
- (void) dropTable:(NSString *)tableName;


/**
 *  从表中取出该列中唯一不同的值
 *
 *  @param columnName 列名
 *  @param tableName  表名
 */
- (NSMutableArray *) selectDistinctColumn:(NSString *)columnName fromTable:(NSString *)tableName;

//票操作-------------------------------------------------------------------------------------------

//插入数据库
-(void) insertTickets:(NSArray *)array;

//查找一条票
-(Ticket *)getOneTicket:(NSString *)t_password eid:(NSString *)eid ticketID:(NSString *)ticketID;

-(Ticket *)getOneTicket:(NSString *)t_password;

//取票数量
-(int) getAllTicketCountByEid:(NSString *)eid status:(NSString *)status ticketID:(NSString *)ticketID;

//取一个活动某些票种的所有票
-(NSMutableArray *) getAllTicketByEid:(NSString *)eid status:(NSString *)status ticketID:(NSString *)ticketID;


//取未提交服务器的所有票
-(NSMutableArray *) getAllUnpostTickets:(NSString *)tableName;
-(NSMutableArray *) getAllUnpostTicketsByEid:(NSString *)eid;

//搜票
-(NSMutableArray *) searchTicket:(NSString *)passwordOrTel eid:(NSString *)eid ticketID:(NSString *)ticketID;

//删除
-(void) deleteOneTickt:(NSString *)t_id;
-(void) deleteAllTicketWitheid:(NSString *)eid;
//大杀器！注意！
-(void) deleteAllTicket;

//所有票数量
- (int) allTicketNumber;


/*
 更改票信息
 state 票状态
 ispost 是否同步
 usedate 使用日期
 */
- (void) updateTicket:(Ticket *)ticket state:(NSString *)state;
- (void) updateTicket:(Ticket *)ticket isPost:(NSString *)ispost;
- (void) updateTicket:(Ticket *)ticket useDate:(NSString *)usedate;
//验票(0.未使用 1.待上传 2.已使用)
-(void) UpdateTikcet:(NSString *)t_id status:(NSString *)status;


//取某个票种下的所有报名人
-(NSMutableArray *) getAllMemberByEid:(NSString *)eid ticketID:(NSString *)ticketID;

//插入数据库
-(void) insertMembers:(NSArray *)array;
@end
