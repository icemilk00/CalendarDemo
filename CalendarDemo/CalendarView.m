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

@property (nonatomic, strong) NSMutableArray *tiles;

@property (nonatomic, strong) NSDate *selectDate;

//@property (nonatomic, readwrite) BOOL isCollapsed;
//
@property (nonatomic, readwrite) NSInteger selectedRow;
@property (nonatomic, readwrite) NSInteger selectedColumn;
@property (nonatomic, strong) CalendarTileView *selectedTileView;
//
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation CalendarView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rowHeight = _columnWidth = frame.size.width/7;
        self.tiles = [[NSMutableArray alloc] init];
        self.selectDate = [NSDate date];
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
    
    for (int i = 0; i < self.rows; i ++) {
        CGFloat y = i * _rowHeight;
        for (int j = 0; j < 7; j ++) {
            CGFloat x = j * self.columnWidth;
            
            CalendarTileView *tileView = [self.dataSource calendarView:self tileViewForRow:i column:j];
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
    
    if (self.autoResize) {
        CGRect frame = self.frame;
        frame.size.height = _rowHeight * _rows;
        self.frame = frame;
    }
    
    if (self.tapGesture == nil) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileViewDidTap:)];
        [self addGestureRecognizer:self.tapGesture];
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
    int row = point.y / self.rowHeight;
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
-(NSUInteger)rows
{
    return [_selectDate numberOfDaysInCurrentMonth];
}

@end
