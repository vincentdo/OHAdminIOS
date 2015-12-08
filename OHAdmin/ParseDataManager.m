//
//  ParseDataManager.m
//  Chatter
//
//  Created by Josh Pearlstein on 11/3/15.
//  Copyright © 2015 SEAS. All rights reserved.
//

#import "ParseDataManager.h"

#import <Parse/Parse.h>

@interface ParseDataManager ()
@property(atomic) NSMutableArray * queues;
@property(atomic) PFObject * currentStudent;
@property(atomic) NSMutableArray * escalatedStudents;
@end

@implementation ParseDataManager

+ (ParseDataManager *)sharedManager {
    static ParseDataManager *obj;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[ParseDataManager alloc] init];
        /// TODO: Any other setup you'd like to do.
    });
    return obj;
}

- (void) setEscalatedStudentWith:(NSString *)pennkey andCallback:(void (^)(void))callback {
    for (PFObject * s in _escalatedStudents) {
        NSString * pk = s[@"pennkey"];
        if ([pk isEqualToString:pennkey]) {
            _currentStudent = s;
            s[@"status"] = @"HELPED";
            [s saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                callback();
            }];
            return;
        }
    }
}

- (NSMutableDictionary *)parseObjectToDict:(PFObject*)message {
    NSArray * allKeys = [message allKeys];
    NSMutableDictionary * retDict = [[NSMutableDictionary alloc] init];
    
    for (NSString * key in allKeys) {
        
        [retDict setObject:[message objectForKey:key] forKey:key];
    }
    return retDict;
}

- (NSString *) getCurrentUserName {
    return [[PFUser currentUser] objectForKey:@"username"];
}

- (BOOL)isUserLoggedIn {
    return [[PFUser currentUser] isAuthenticated];
}

- (void) getOpenQueuesWithCallback: (void (^)(NSMutableArray *))callback  {
    PFQuery * query = [PFQuery queryWithClassName:@"Queue"];
    [query whereKey:@"startTime" lessThan:[NSDate date]];
    [query whereKey:@"endTime" greaterThan:[NSDate date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _queues = [objects mutableCopy];
            callback([objects mutableCopy]);
        }
    }];
}

- (void) getEscalatedStudentsWithCallback: (void (^)(void))callback {
    PFQuery * query = [PFQuery queryWithClassName:@"Student"];
    [query whereKey:@"status" equalTo:@"ESCALATED"];
    NSDate * now = [NSDate date];
    NSDate *newDate = [now dateByAddingTimeInterval:-3600*5];
    [query whereKey:@"updatedAt" greaterThan:newDate];
    [query orderByAscending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            _escalatedStudents = [objects mutableCopy];
            callback();
        }
    }];
}

- (void) getNextStudentWithCallback: (void (^)(NSMutableArray *))callback  {
    PFQuery * query = [PFQuery queryWithClassName:@"Student"];
    [query whereKey:@"status" equalTo:@"WAIT"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject * student in objects) {
                NSString * pk = student[@"pennkey"];
                for (PFObject * q in _queues) {
                    if ([q[@"staffs"] containsObject:[self getCurrentUserName]]) {
                        if ([q[@"students"] containsObject:pk]) {
                            _currentStudent = student;
                            callback([[NSMutableArray alloc] initWithObjects:student, nil]);
                            return;
                        }
                    }
                }
            }
            callback([[NSMutableArray alloc] init]);
        }
    }];
}

- (void) resolveStudentWithStatus:(NSString *)status andCallback:(void (^)(void))callback {
    [_currentStudent setObject:status forKey:@"status"];
    [_currentStudent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            for (PFObject * q in _queues) {
                NSMutableArray * students = [[NSMutableArray alloc] initWithArray: q[@"students"]];
                if ([students containsObject:_currentStudent[@"pennkey"]]) {
                    [students removeObject:_currentStudent[@"pennkey"]];
                }
                [q setObject:students forKey:@"students"];
                [q saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    _currentStudent = NULL;
                    callback();
                }];
            }
        }
    }];
}

- (void) logInOrOutQueue:(NSString *)queueName withCallback:(void (^)(void))callback {
    for (PFObject * q in _queues) {
        if ([q[@"name"] isEqualToString:queueName]) {
            NSMutableArray * staffs = [[NSMutableArray alloc] initWithArray:q[@"staffs"]];
            NSString * user = [self getCurrentUserName];
            if ([staffs containsObject:user]) {
                [staffs removeObject:[self getCurrentUserName]];
            } else {
                [staffs addObject: [self getCurrentUserName]];
            }
            [q setObject:staffs forKey:@"staffs"];
            [q saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    callback();
                }
            }];
        }
    }
}


@end
