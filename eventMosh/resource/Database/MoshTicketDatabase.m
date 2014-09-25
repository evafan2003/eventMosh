////
////  MoshTicketDatabase.m
////  MoshTicket
////
////  Created by evafan2003 on 12-6-27.
////  Copyright (c) 2012年 bbdtek. All rights reserved.
////
//
//#import "MoshTicketDatabase.h"
//#import "FMDatabaseAdditions.h"
//#import "Ticket.h"
//#import "GlobalConfig.h"
//#import "NSString+Encrypt.h"
//
//static MoshTicketDatabase *moshTicketDatabase = nil;
//
//@implementation MoshTicketDatabase
//
//+(MoshTicketDatabase *) sharedInstance {
//    
//    if (!moshTicketDatabase) {
//        
//        moshTicketDatabase = [[MoshTicketDatabase alloc] init];
//    }
//    return moshTicketDatabase;
//}
//
//-(id) init {
//    
//    if (self = [super init]) {
//        db = [FMDatabase databaseWithPath:[self getFilePath]];
//        dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self getFilePath]];
//        
//        if (![db open]) {
//			NSLog(@"Could not open db.");
//			return nil;
//		}
//        
//        [self createTable];
//        
//		if ([db hadError]) {
//			NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
//			return nil;
//		}
//    }
//    
//    return self;
//}
//
//
//-(void) createTable {
//    
//    [db setShouldCacheStatements:YES];
//    
//    //票表
//    [self createTicketsTable];
//    //创建报名表列表
//    [self createMembersTable];
//    
//}
//
//
//- (NSString *) getFilePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
//    
//    MOSHLog(@"databaseAddress:%@",filePath);
//    return filePath;
//}
//
//- (void) createTicketsTable
//{
//    //    t_state 票状态 对应1未使用，2已使用，3已过期，4已退票,5删除票
//    //    ispost 是否同步服务器 0未同步 1已同步
//    NSString *createTickets = [NSString stringWithFormat:@"create table  if not exists %@ (id  INTEGER PRIMARY KEY ASC,eid integer, ticket_id integer, t_id integer, t_password text, t_state integer, tel text, use_date integer, ispost integer, ticket_name text,email text, name text,idcard text,t_price text)",TABLE_TICKET];
//    [db executeUpdate:createTickets];
//    
//    //用票密码和活动名称创建唯一索引
//    [db executeUpdate:[NSString stringWithFormat:@"create unique index if not exists t_status on %@ (eid,t_password)",TABLE_TICKET]];
//    
//    [db executeUpdate:[NSString stringWithFormat:@"create index if not exists password on %@ (t_password)",TABLE_TICKET]];
//    
//    [db executeUpdate:[NSString stringWithFormat:@"create index if not exists phone_number on %@ (tel)",TABLE_TICKET]];
//
//}
//
//- (void) createMembersTable
//{
//    NSString *createMembers = [NSString stringWithFormat:@"create table  if not exists %@ (id  INTEGER PRIMARY KEY ASC,eid integer, tid integer, name text, tel integer, email text, isentry text, typeid text, desc text)",TABLE_MEMBER];
//    
//    [db executeUpdate:createMembers];
//    
//    //创建唯一索引
//    [db executeUpdate:@"create unique index if not exists memberinfo on members (eid,tid)"];
//}
//
//- (void) dropTable:(NSString *)tableName
//{
//    [db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@",tableName]];
//}
//
////从表中取出该列中唯一不同的值
//- (NSMutableArray *) selectDistinctColumn:(NSString *)columnName fromTable:(NSString *)tableName
//{
//    NSString *sql =[ NSString stringWithFormat:@"select distinct %@ from %@",columnName,tableName];
//    FMResultSet *resultSet = [db executeQuery:sql];
//    NSMutableArray *array = [NSMutableArray new];
//    while ([resultSet next]) {
//        [array addObject:[NSString stringWithFormat:@"%d",[resultSet intForColumnIndex:0]]];
//    }
//    return array;
//    
//}
//
//
//#pragma mark - tickets -
//
////插入数据库
//-(void) insertTickets:(NSArray *)array {
//    
//    [dbQueue inDatabase:^(FMDatabase *database) {
//        NSMutableString *value = [[NSMutableString alloc] init];
//        for (Ticket *ticket in array) {
//            
//            [value appendString:[NSString stringWithFormat:@"(%d,'%@','%@',%d,'%@','%@',%d,'%@',%d,'%@',%d,%d,'%@'),",[ticket.eid integerValue],[ticket.email encrypt],[ticket.name encrypt],[ticket.t_id integerValue],[ticket.t_password encrypt],ticket.t_price,[ticket.t_state integerValue],[ticket.tel encrypt],[ticket.ticket_id integerValue],ticket.ticket_name,[ticket.use_date integerValue],[ticket.ispost integerValue],[ticket.idCard encrypt]]];
//            
//            if ([array indexOfObject:ticket] %400 == 0 && [array indexOfObject:ticket] != 0) {
//                [value deleteCharactersInRange:NSMakeRange(value.length - 1, 1)];
//                //没有 插之
//                NSString *sql = [NSString stringWithFormat:@"replace into %@(`eid`,`email`, `name`, `t_id`, `t_password`, `t_price`, `t_state`, `tel`, `ticket_id`, `ticket_name`, `use_date`, `ispost`,`idcard`) values%@",TABLE_TICKET,value];
//                
//                BOOL success = [database executeUpdate:sql];
//                if (success) {
//                    MOSHLog(@"插入成功");
//                }
//                else {
//                    MOSHLog(@"插入失败");
//                }
//                value = [[NSMutableString alloc] init];
//            }
//            
//        }
//        if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:value]) {
//            [value deleteCharactersInRange:NSMakeRange(value.length - 1, 1)];
//            //没有 插之
//            NSString *sql = [NSString stringWithFormat:@"replace into %@(`eid`,`email`, `name`, `t_id`, `t_password`, `t_price`, `t_state`, `tel`, `ticket_id`, `ticket_name`, `use_date`, `ispost`,`idcard`) values%@",TABLE_TICKET,value];
//            
//            BOOL success = [database executeUpdate:sql];
//            if (success) {
//                MOSHLog(@"插入成功");
//            }
//            else {
//                MOSHLog(@"插入失败");
//            }
//            value = [[NSMutableString alloc] init];
//        }
//    }];
//}
//
//
//
//-(Ticket *)getOneTicket:(NSString *)t_password eid:(NSString *)eid ticketID:(NSString *)ticketID{
//    
//    Ticket *ticket = nil;
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where eid = %@",TABLE_TICKET,eid];
//    
//     [sql appendFormat:@" and t_password = '%@'",[t_password encrypt]];
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:ticketID]) {
//        [sql appendFormat:@" and ticket_id in (%@)",ticketID];
//    }
//    
//    FMResultSet *resultSet = [db executeQuery:sql];
//    while ([resultSet next]) {
//        ticket = [self ticketOfResultSet:resultSet];
//    }
//    [resultSet close];
//    return ticket;
//}
//
//-(Ticket *)getOneTicket:(NSString *)t_password{
//    
//    Ticket *ticket = nil;
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where t_password = '%@'",TABLE_TICKET,[t_password encrypt]];
//    
//    FMResultSet *resultSet = [db executeQuery:sql];
//    while ([resultSet next]) {
//        ticket = [self ticketOfResultSet:resultSet];
//    }
//    [resultSet close];
//    return ticket;
//}
//
//
//-(NSMutableArray *) searchTicket:(NSString *)passwordOrTel eid:(NSString *)eid ticketID:(NSString *)ticketID{
//    
//    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
//    
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where  eid = %@",TABLE_TICKET,eid];
//    
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:ticketID]) {
//        [sql appendFormat:@" and ticket_id in (%@)",ticketID];
//    }
//    
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:passwordOrTel]) {
//        [sql appendFormat:@" and (t_password = '%@' or tel = '%@')",[passwordOrTel encrypt],[passwordOrTel encrypt]];
//
//    }
//
//    [sql appendString:@" and t_state in (1,2) order by use_date desc"];
//    
//    FMResultSet *resultSet = [db executeQuery:sql];
//    while ([resultSet next]) {
//        Ticket *ticket = [self ticketOfResultSet:resultSet];
//        [resultArray addObject:ticket];
//        
//    }
//    [resultSet close];
//    return resultArray;
//    
//}
//
////取一个活动所有票数量
//-(int) getAllTicketCountByEid:(NSString *)eid status:(NSString *)status ticketID:(NSString *)ticketID
//{
//    
//    int totalCount = 0;
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"select count(*) from %@ where eid = %@",TABLE_TICKET,eid];
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:ticketID]) {
//        [sql appendFormat:@" and ticket_id in (%@)",ticketID];
//    }
//
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:status]) {
//        [sql appendFormat:@" and t_state in (%@)",status];
//    }
//    else {
//        [sql appendFormat:@" and t_state in (1,2)"];
//    }
//    
//    
//    FMResultSet *resultSet = [db executeQuery:sql];
//    while ([resultSet next]) {
//        totalCount = [resultSet intForColumnIndex:0];
//    }
//    [resultSet close];
//    return totalCount;
//}
//
//
////取某个状态的所有票
//-(NSMutableArray *) getAllTicketByEid:(NSString *)eid status:(NSString *)status ticketID:(NSString *)ticketID{
//    
//    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
//    
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where eid = %@",TABLE_TICKET,eid];
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:ticketID]) {
//        [sql appendFormat:@" and ticket_id in (%@)",ticketID];
//    }
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:status]) {
//        [sql appendFormat:@" and t_state in (%@)",status];
//    }
//    else {
//        [sql appendFormat:@" and t_state in (1,2)"];
//    }
//   
//    [sql appendString:@"order by use_date desc"];
//    
//    FMResultSet *resultSet = [db executeQuery:sql];
//    
//    while ([resultSet next]) {
//        Ticket *ticket = [self ticketOfResultSet:resultSet];
//        [resultArray addObject:ticket];
//    }
//    [resultSet close];
//    return resultArray;
//    
//}
//
////取未提交服务器的所有票
//-(NSMutableArray *) getAllUnpostTicketsByEid:(NSString *)eid {
//    
//    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
//    
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where eid = %@ and ispost = %@", TABLE_TICKET,eid,ticketUpdte_no];
//    FMResultSet *resultSet = [db executeQuery:sql];
//    
//    while ([resultSet next]) {
//        Ticket *ticket = [self ticketOfResultSet:resultSet];
//        [resultArray addObject:ticket];
//    }
//    [resultSet close];
//    return resultArray;
//    
//}
//
////取未提交服务器的所有票
//-(NSMutableArray *) getAllUnpostTickets:(NSString *)tableName {
//    
//    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
//    
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where ispost = %@",tableName,ticketUpdte_no];
//    FMResultSet *resultSet = [db executeQuery:sql];
//    
//    while ([resultSet next]) {
//        Ticket *ticket = [self ticketOfResultSet:resultSet];
//        [resultArray addObject:ticket];
//    }
//    [resultSet close];
//    return resultArray;
//    
//}
//
//
//
//
////删除
//-(void) deleteOneTickt:(NSString *)t_id {
//
//    [dbQueue inDatabase:^(FMDatabase *database) {
//        NSString *sql = [NSString stringWithFormat:@"delete from %@ where t_id =%@",TABLE_TICKET, t_id];
//        [db executeUpdate:sql];
//    }];
//}
//
////全部删除
//-(void) deleteAllTicketWitheid:(NSString *)eid {
//    
//    [dbQueue inDatabase:^(FMDatabase *database) {
//      NSString *sql = [NSString stringWithFormat:@"delete from %@ where eid = %@", TABLE_TICKET,eid];
//        [db executeUpdate:sql];
//    }];
//   
//    
//}
//
////大杀器！注意！
//-(void) deleteAllTicket {
//    
//    [dbQueue inDatabase:^(FMDatabase *database) {
//        NSString *sql = [NSString stringWithFormat:@"delete from %@ ",TABLE_TICKET];
//         [db executeUpdate:sql];
//    }];
//}
//
//- (int) allTicketNumber
//{
//    int totalCount = 0;
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"select count(*) from %@",TABLE_TICKET];
//    
//    FMResultSet *resultSet = [db executeQuery:sql];
//    while ([resultSet next]) {
//        totalCount = [resultSet intForColumnIndex:0];
//    }
//    [resultSet close];
//    return totalCount;
//
//}
//
//- (Ticket *) ticketOfResultSet:(FMResultSet *)resultSet
//{
//    Ticket *ticket = [[Ticket alloc] init];
//    ticket.eid = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"eid"]];
//     ticket.t_id = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"t_id"]];
//     ticket.t_state = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"t_state"]];
//    ticket.ticket_id = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"ticket_id"]];
//    ticket.use_date = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"use_date"]];
//     ticket.ispost = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"ispost"]];
//    
//    ticket.t_price = [GlobalConfig convertToString:[resultSet stringForColumn:@"t_price"]];
//    ticket.ticket_name = [GlobalConfig convertToString:[resultSet stringForColumn:@"ticket_name"]];
//    
//    ticket.name = [[GlobalConfig convertToString:[resultSet stringForColumn:@"name"]] decrypt];
//    ticket.t_password = [[GlobalConfig convertToString:[resultSet stringForColumn:@"t_password"]] decrypt];
//    ticket.tel = [[GlobalConfig convertToString:[resultSet stringForColumn:@"tel"]] decrypt];
//    ticket.idCard = [[GlobalConfig convertToString:[resultSet stringForColumn:@"idcard"]] decrypt];
//    ticket.email = [[GlobalConfig convertToString:[resultSet stringForColumn:@"email"]] decrypt];
//    
//    return ticket;
//}
////
//////----------------------------------------------------------------------------------------------------
//
////验票(0.错误 1.未使用 2.已使用)
//-(void) UpdateTikcet:(NSString *)t_id status:(NSString *)status {
//    
//    [dbQueue inDatabase:^(FMDatabase *database) {
//        NSString *time = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
//        if ([status intValue] == 1) {
//            time = @"0";
//        }
//        
//        NSString *sql = [NSString stringWithFormat:@"update %@ set t_state = %@,use_date = %@ where t_id = %@", TABLE_TICKET,status,time, t_id];
//         [db executeUpdate:sql];
//    }];
//}
//
//- (void) updateTicket:(Ticket *)ticket state:(NSString *)state
//{
//    [dbQueue inDatabase:^(FMDatabase *database) {
//        NSString *sql = [NSString stringWithFormat:@"update %@ set t_state = %@ where eid  = %@ and t_password = '%@'", TABLE_TICKET,state, ticket.eid,[ticket.t_password encrypt]];
//        [db executeUpdate:sql];
//    }];
//}
//
//- (void) updateTicket:(Ticket *)ticket isPost:(NSString *)ispost
//{
//     [dbQueue inDatabase:^(FMDatabase *database) {
//         NSString *sql = [NSString stringWithFormat:@"update %@ set ispost = %@ where eid  = %@ and  t_password = '%@'", TABLE_TICKET,ispost, ticket.eid,[ticket.t_password encrypt]];
//         [db executeUpdate:sql];
//     }];
//}
//
//- (void) updateTicket:(Ticket *)ticket useDate:(NSString *)usedate
//{
//     [dbQueue inDatabase:^(FMDatabase *database) {
//         NSString *sql = [NSString stringWithFormat:@"update %@ set use_date = %@ where eid  = %@ and t_password = '%@'", TABLE_TICKET,usedate, ticket.eid,[ticket.t_password encrypt]];
//             [db executeUpdate:sql];
//     }];
//}
//
//
//#pragma mark - members -
//
////插入数据库
//-(void) insertMembers:(NSArray *)array {
//    
////    [dbQueue inDatabase:^(FMDatabase *database) {
//        NSMutableString *value = [[NSMutableString alloc] init];
//        for (MemberInfo *info in array) {
//            
//            [value appendString:[NSString stringWithFormat:@"(%d,%d,'%@','%@','%@','%@','%@','%@'),",[info.eid integerValue],[info.tid integerValue],[info.name encrypt],[info.phoneNumber encrypt],[info.email encrypt],info.isentry,info.tTypeID,[info.desc encrypt]]];
//            
//            if ([array indexOfObject:info] %400 == 0 && [array indexOfObject:info] != 0) {
//                [value deleteCharactersInRange:NSMakeRange(value.length - 1, 1)];
//                //没有 插之
//                NSString *sql = [NSString stringWithFormat:@"replace into members (`eid`,`tid`, `name`, `tel`, `email`, `isentry`, `typeid`,`desc`) values%@",value];
//                
//                BOOL success = [db executeUpdate:sql];
//                if (success) {
//                    MOSHLog(@"插入成功");
//                }
//                else {
//                    MOSHLog(@"插入失败");
//                }
//                value = [[NSMutableString alloc] init];
//            }
//            
//        }
//        if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:value]) {
//            [value deleteCharactersInRange:NSMakeRange(value.length - 1, 1)];
//            //没有 插之
//            NSString *sql = [NSString stringWithFormat:@"replace into members (`eid`,`tid`, `name`, `tel`, `email`, `isentry`, `typeid`, `desc`) values%@",value];
//            
//            BOOL success = [db executeUpdate:sql];
//            if (success) {
//                MOSHLog(@"插入成功");
//            }
//            else {
//                MOSHLog(@"插入失败");
//            }
//            value = [[NSMutableString alloc] init];
//        }
////    }];
//}
//
//
////取某个票种下的所有报名人
//-(NSMutableArray *) getAllMemberByEid:(NSString *)eid ticketID:(NSString *)ticketID
//{
//    
//    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
//    
//    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from members where eid = %@",eid];
//    
//    if ([GlobalConfig isKindOfNSStringClassAndLenthGreaterThanZero:ticketID]) {
//        [sql appendFormat:@" and (typeid like '%%%@%%')",ticketID];
//    }
//    
//    FMResultSet *resultSet = [db executeQuery:sql];
//    
//    while ([resultSet next]) {
//        MemberInfo *info = [self memberOfResultSet:resultSet];
//        [resultArray addObject:info];
//    }
//    [resultSet close];
//    return resultArray;
//}
//
//- (MemberInfo *) memberOfResultSet:(FMResultSet *)resultSet
//{
//    MemberInfo *info = [[MemberInfo alloc] init];
//    info.eid = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"eid"]];
//    info.tid = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"tid"]];
//
//    info.isentry = [resultSet stringForColumn:@"isentry"];
//    info.desc = [[resultSet stringForColumn:@"desc"] decrypt];
//    info.email = [[resultSet stringForColumn:@"email"] decrypt];
//    info.name = [[resultSet stringForColumn:@"name"] decrypt];
//    info.phoneNumber = [[resultSet stringForColumn:@"tel"] decrypt];
//    
//    [info memberDescConvertToInfo];
//    
//    return info;
//}
//
//- (void) dealloc
//{
//    [db close];
//}
//
//////获取字符串的下一个比它大的字符串
////- (NSString*)nextStringAfterString:(NSString*)text
////{
////    NSString *nextString = nil;
////    int length = text.length;
////    NSString *prefixString = [text substringToIndex:length - 1];
////    NSString *lastString = [text substringFromIndex:length - 1];
////    const char* lastChar = [lastString UTF8String];
////    int lastLength = strlen(lastChar);
////    if (lastLength == 1) {//ASCII
////        char newChar1[2];
////        newChar1[0] = lastChar[0] + 1;
////        newChar1[1] = 0;
////        NSString *newString1 = [NSString stringWithUTF8String:newChar1];
////        nextString = [prefixString stringByAppendingString:newString1];
////    }
////    else if (lastLength == 3) {//中文
////        char newChar2[4];
////        newChar2[0] = lastChar[0];
////        newChar2[1] = lastChar[1];
////        newChar2[2] = lastChar[2] + 1;
////        newChar2[3] = 0;
////        NSString *newString2 = [NSString stringWithUTF8String:newChar2];
////        nextString = [prefixString stringByAppendingString:newString2]; 
////    } 
////    return nextString; 
////}
//
//@end
