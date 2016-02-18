//
//  ViewController.m
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "ViewController.h"
#import "CalendarTileView.h"
#import "CalendarModel.h"

@interface ViewController ()

@property (nonatomic, strong) CalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.calendarView];
    [_calendarView reloadDataWithCurrentDate];
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
    
}

#pragma setter and getter
-(CalendarView *)calendarView
{
    if (_calendarView == nil) {
        self.calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0)];
        _calendarView.delegate = self;
        _calendarView.dataSource = self;
    }

    return _calendarView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
