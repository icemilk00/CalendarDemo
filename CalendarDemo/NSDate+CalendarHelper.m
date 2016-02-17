//
//  NSDate+CalendarHelper.m
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "NSDate+CalendarHelper.h"

@implementation NSDate (CalendarHelper)

/*
 *  获取日期所在月有多少天
 */
- (NSUInteger)numberOfDaysInCurrentMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}


/*
 *  获取日期所在月的第一天
 */
-(NSDate *)firstDayInCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:nil forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

/*
 *  获取日期所在月的最后一天
 */
- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

/*
 *  获取日期在所在月是周几
 */
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

/*
 *  获取日期在所在月是几号
 */
- (NSUInteger)monthlyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
}

/*
 *  获取日期所在月有几周
 */
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayInCurrentMonth] weeklyOrdinality];
    
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

/*
 *  获取日期所在月的上一个月有几天
 */
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/*
 *  获取日期所在月的下一个月有几天
 */
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

/*
 *  获取日期在所在月的哪一个周内
 */
- (NSUInteger)weekNumberInCurrentMonth
{
    NSUInteger firstDay = [[self firstDayInCurrentMonth] weeklyOrdinality];
    NSUInteger weeksCount = [self numberOfWeeksInCurrentMonth];
    NSUInteger weekNumber = 0;
    
    NSDateComponents *c = [self YMDComponents];
    NSUInteger startIndex = [[self firstDayInCurrentMonth] monthlyOrdinality];
    NSUInteger endIndex = startIndex + (7 - firstDay);
    for (int i = 0; i < weeksCount; ++i) {
        if (c.day >= startIndex && c.day <= endIndex) {
            weekNumber = i;
            break;
        }
        startIndex = endIndex + 1;
        endIndex = startIndex + 6;
    }
    
    return weekNumber;
}



@end
