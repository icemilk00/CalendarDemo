//
//  CalendarView.m
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarTileView.h"

@interface CalendarView ()

@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat columnWidth;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *tiles;

@property (nonatomic, strong) NSDate *selectDate;

@property (nonatomic, readwrite) NSInteger selectedRow;
@property (nonatomic, readwrite) NSInteger selectedColumn;
@property (nonatomic, strong) CalendarTileView *selectedTileView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIImageView *calendarHeadView;

@end

@implementation CalendarView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rowHeight = _columnWidth = frame.size.width/7;
        self.tiles = [[NSMutableArray alloc] init];
        self.dataSourceArray = [[NSMutableArray alloc] init];
        self.selectDate = [NSDate date];
        self.autoResize = YES;
        self.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.calendarHeadView];
    }
    return self;
}

-(void)reloadData
{
    if (self.dataSource == nil) return;
    
    _rowHeight = _columnWidth = self.frame.size.width/7;
    
    if ([self.dataSource respondsToSelector:@selector(heightForRowInGridView:)]) {
        self.rowHeight = [self.dataSource heightForRowInGridView:self];
    }

    for (CalendarTileView *tile in _tiles) {
        [tile removeFromSuperview];
    }
    
    [_tiles removeAllObjects];
    
    if (self.autoResize) {
        CGRect frame = self.frame;
        frame.size.height = _rowHeight * self.rows;
        self.frame = frame;
    }
    
    for (int i = 0; i < self.rows; i ++) {
        CGFloat y = i * _rowHeight + _calendarHeadView.frame.size.height;
        for (int j = 0; j < 7; j ++) {
            CGFloat x = j * self.columnWidth;
            
            CalendarTileView *tileView = [self.dataSource calendarView:self tileViewForRow:i column:j];
            NSUInteger index = i*7 + j;
            
            if (self.dataSourceArray.count > index) {
                [tileView configTileViewWithModel:self.dataSourceArray[i * 7 + j]];
            }
            
            tileView.frame = CGRectMake(x, y, _columnWidth, _rowHeight);
            [self addSubview:tileView];
            [self.tiles addObject:tileView];
            
            if (tileView.selected) {
                self.selectedRow = i;
                self.selectedColumn = j;
                self.selectedTileView = tileView;
            }
        }
    }

    if (self.tapGesture == nil) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileViewDidTap:)];
        [self addGestureRecognizer:self.tapGesture];
    }
    
}

- (void)reloadCalendarDataWithDate:(NSDate *)date
{
    self.selectDate = date;
    
//    NSDateComponents *c = [date YMDComponents];
//    self.selectedCalendarDay = [WQCalendarDay calendarDayWithYear:c.year month:c.month day:c.day];
    
    [self.dataSourceArray removeAllObjects];
    
    [self calculateDaysInPreviousMonthWithDate:date];
    [self calculateDaysInCurrentMonthWithDate:date];
    [self calculateDaysInFollowingMonthWithDate:date];
}

-(void)reloadCalendarWithDate:(NSDate *)date
{
    [self reloadCalendarDataWithDate:date];
    [self reloadData];
}

-(void)reloadDataWithCurrentDate
{
    [self reloadCalendarWithDate:[NSDate date]];
}

#pragma mark - method to calculate days in previous, current and the following month.

- (void)calculateDaysInPreviousMonthWithDate:(NSDate *)date
{
    NSUInteger weeklyOrdinality = [[date firstDayInCurrentMonth] weeklyOrdinality];
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];
    
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];
    NSUInteger partialDaysCount = weeklyOrdinality - 1;
    
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];

    for (NSUInteger i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        CalendarModel *model = [CalendarModel calendarModuleWithYear:components.year month:components.month day:i];
        [self.dataSourceArray addObject:model];
    }
}

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date
{
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];
    NSDateComponents *components = [date YMDComponents];
    

    for (int i = 1; i < daysCount + 1; ++i) {
        CalendarModel *model = [CalendarModel calendarModuleWithYear:components.year month:components.month day:i];
        [self.dataSourceArray addObject:model];
    }
}

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        CalendarModel *model = [CalendarModel calendarModuleWithYear:components.year month:components.month day:i];
        [self.dataSourceArray addObject:model];
    }
}

- (CalendarTileView *)tileForRow:(NSUInteger)row column:(NSUInteger)column
{
    NSUInteger index = row * 7 + column;
    if (index > self.tiles.count) return nil;
    return self.tiles[index];
}

- (NSUInteger)numberOfRows
{
    return self.rows;
}

- (void)tileViewDidTap:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self];
    int row = (point.y-_calendarHeadView.frame.size.height) / self.rowHeight;
    int column = point.x / self.columnWidth;
    
    CalendarTileView *selectedTileView = [self tileForRow:row column:column];
    if (selectedTileView == nil) return ;
    
    self.selectedTileView.selected = NO;
    self.selectedTileView = selectedTileView;
    self.selectedTileView.selected = YES;
    
    self.selectedRow = row;
    self.selectedColumn = column;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectAtRow:column:)]) {
        [self.delegate calendarView:self didSelectAtRow:row column:column];
    }
}


#pragma setter and getter
-(UIImageView *)calendarHeadView
{
    if (_calendarHeadView == nil) {
        self.calendarHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 32.0f)];
        _calendarHeadView.image = [UIImage imageNamed:@"weeklyTitle"];
    }
    return _calendarHeadView;
}

-(NSUInteger)rows
{
    return [_selectDate numberOfWeeksInCurrentMonth];
}

@end
