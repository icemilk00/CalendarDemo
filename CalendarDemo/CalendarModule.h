//
//  CalendarModule.h
//  CalendarDemo
//
//  Created by hp on 16/2/18.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarModule : NSObject

@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, assign) NSUInteger month;
@property (nonatomic, assign) NSUInteger year;

+ (CalendarModule *)calendarModuleWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

- (BOOL)isEqualTo:(CalendarModule *)day;

- (NSDate *)date;

@end
