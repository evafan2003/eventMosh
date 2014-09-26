//
//  HTTPClient+PartTask.h
//  moshTickets
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (PartTask)

- (void) addNewTaskWithTaskName:(NSString *)name
                            eid:(NSString *)eid
                            uid:(NSString *)uid
                        success:(void (^)(id json))success;

@end
