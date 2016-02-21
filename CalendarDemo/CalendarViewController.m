//
//  CalendarViewController.m
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarTileView.h"
#import "CalendarModel.h"


@interface CalendarViewController ()

@property (nonatomic, strong) CalendarView *calendarView;

@property (nonatomic, strong) UIButton *prevMonthButton;
@property (nonatomic, strong) UIButton *nextMonthButton;
@property (nonatomic, strong) UILabel *dateShowLabel;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.prevMonthButton];
    [self.view addSubview:self.nextMonthButton];
    [self.view addSubview:self.dateShowLabel];
    
    [self.view addSubview:self.calendarView];
    [_calendarView reloadDataWithCurrentDate];
    
    [self setDateShowLabelTextWithDate:[NSDate date]];
    
}

-(void)setDateShowLabelTextWithDate:(NSDate *)date
{
    NSDateComponents *c = [date YMDComponents];
    _dateShowLabel.text = [NSString stringWithFormat:@"%ld 年 %ld 月",(long)c.year, (long)c.month];
}

- (CalendarTileView *)calendarView:(CalendarView *)gridView tileViewForRow:(NSUInteger)row column:(NSUInteger)column
{
    CalendarTileView *tileView = nil;
    if (tileView == nil) {
        tileView = [[[NSBundle mainBundle] loadNibNamed:@"CalendarTileView" owner:self options:nil] lastObject];
    }

    return tileView;
}

- (void)calendarView:(CalendarView *)calendarView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column
{
    NSLog(@"%@",[calendarView.selectDate chineseCalendar]);
}

-(void)goPrevMonth:(UIButton *)sender
{
    NSDate *prevDate = [_calendarView.selectDate dayInThePreviousMonth];
    [_calendarView reloadCalendarWithDate:prevDate];
    [self setDateShowLabelTextWithDate:prevDate];
}

-(void)goNextMonth:(UIButton *)sender
{
    NSDate *nextDate = [_calendarView.selectDate dayInTheFollowingMonth];
    [_calendarView reloadCalendarWithDate:nextDate];
    [self setDateShowLabelTextWithDate:nextDate];
}

-(void)dateChangeTap:(UITapGestureRecognizer *)tap
{
    CalendarDatePickerView *pickerView = [[CalendarDatePickerView alloc] initWithDelegate:self];
    [pickerView show];
}

-(void)dateChangedWithDate:(NSDate *)date
{
    [_calendarView reloadCalendarWithDate:date];
    [self setDateShowLabelTextWithDate:date];
}

#pragma setter and getter
-(CalendarView *)calendarView
{
    if (_calendarView == nil) {
        self.calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0.0f, 80.0f, self.view.frame.size.width, 0)];
        _calendarView.delegate = self;
        _calendarView.dataSource = self;
    }

    return _calendarView;
}

-(UIButton *)prevMonthButton
{
    if (_prevMonthButton == nil) {
        self.prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 80.0f, 40.0f)];
        [_prevMonthButton setTitle:@"上个月" forState:UIControlStateNormal];
        [_prevMonthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_prevMonthButton addTarget:self action:@selector(goPrevMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _prevMonthButton;
}

-(UIButton *)nextMonthButton
{
    if (_nextMonthButton == nil) {
        self.nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80.0f, 30.0f, 100.0f, 40.0f)];
        [_nextMonthButton setTitle:@"下个月" forState:UIControlStateNormal];
        [_nextMonthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextMonthButton addTarget:self action:@selector(goNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextMonthButton;
}

-(UILabel *)dateShowLabel
{
    if (_dateShowLabel == nil) {
        self.dateShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80.0f, 30.0f, 160.0f, 40.0f)];
        _dateShowLabel.textAlignment = NSTextAlignmentCenter;
        _dateShowLabel.text = @"xx年xx月";
        
        _dateShowLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateChangeTap:)];
        [_dateShowLabel addGestureRecognizer:tap];
    }
    
    return _dateShowLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
