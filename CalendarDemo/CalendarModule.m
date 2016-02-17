//
//  CalendarModule.m
//  CalendarDemo
//
//  Created by hp on 16/2/18.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarModule.h"

@implementation CalendarModule


+ (CalendarModule *)calendarModuleWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    CalendarModule *calendarModule = [[CalendarModule alloc] init];
    calendarModule.year = year;
    calendarModule.month = month;
    calendarModule.day = day;
    return calendarModule;
}

- (BOOL)isEqualTo:(CalendarModule *)day
{
    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
    return isEqual;
}

- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}


@end
