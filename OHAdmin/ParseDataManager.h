//
//  ParseDataManager.h
//  Chatter
//
//  Created by Josh Pearlstein on 11/3/15.
//  Copyright © 2015 SEAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <Parse/Parse.h>

@interface ParseDataManager : NSObject

+ (ParseDataManager *)sharedManager;
- (PFObject *) currentStudent;
- (NSMutableArray *) escalatedStudents;

- (BOOL)isUserLoggedIn;

- (NSString *) getCurrentUserName;

- (void) getOpenQueuesWithCallback: (void (^)(NSMutableArray *))callback;
// TODO: Handle posting messages with Longitude and Latitude

// TODO: Handle User signup

- (NSMutableDictionary *)parseObjectToDict:(PFObject *)message;

- (void) logInOrOutQueue:(NSString *)queueName withCallback:(void (^)(void))callback;

- (void) getNextStudentWithCallback: (void (^)(NSMutableArray *))callback;

- (void) resolveStudentWithStatus:(NSString *)status andCallback:(void (^)(void))callback;

- (void) getEscalatedStudentsWithCallback: (void (^)(void))callback;

- (void) setEscalatedStudentWith:(NSString *)pennkey andCallback:(void (^)(void))callback;

@end
