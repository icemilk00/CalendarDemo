//
//  CalendarTileView.h
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarModel.h"

@interface CalendarTileView : UIView

@property (nonatomic, assign) BOOL selected;

@property (strong, nonatomic) IBOutlet UILabel *showDayLabel;
@property (strong, nonatomic) IBOutlet UIImageView *recordFlagImageView;

-(void)configTileViewWithModel:(CalendarModel *)model;
@end
