# CalendarDemo

这是一个我自己小项目里需要用的日历轻组件,作为轮子我就放到这里，大概效果可以看下面这张图： 



用法简介
===
用法比较无脑，因为毕竟轻。

1.初始化
---
	self.calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0.0f, 80.0f, self.view.frame.size.width, 0)];
    _calendarView.delegate = self;
    _calendarView.dataSource = self; 
    [self.view addSubview:self.calendarView];

2.完成delegate里方法和dataSource里方法 
---
代理里主要是日期选中事件的回调 
	
	- (void)calendarView:(CalendarView *)calendarView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column; 

dataSource主要是定制日期格，类似于UITableView的定制cell的dataSoruce方法

	- (CalendarTileView *)calendarView:(CalendarView *)gridView tileViewForRow:(NSUInteger)row column:(NSUInteger)column; 

3.reloadData 
---
类似于UITableView的reloadData方法，放出来两种reloadData方法：

以当前日期为load数据：
	
	-(void)reloadDataWithCurrentDate; 

以参数日期为load数据,一般用于要到某个日期的月份的时候用这个： 

	-(void)reloadCalendarWithDate:(NSDate *)date;

根据实际情况自己选择用。

PS:效果图上的上一页下一页按钮和title的日期显示控件并没有封到CalendarView里，毕竟考虑别人运用的实际场景，这些控件的位置和样式等变数较大，请自行添加。Demo里这些写在了CalendarViewController里。至于点击Title显示的CalendatDatePickerView也稍微封了下，详细看代码吧。

文件介绍
===

CalendarView  			//日历本体 
CalendarTileView		//日历日期单元格,类似于UITableViewCell的角色，定制时请务必继承此类 
CalendarModel			//描述日期单元格的model 
NSDate+CalendarHelper	//计算日期和日历关系的NSDate的类别，有需要自行往进加方法
CalendatDatePickerView	//时间选择器

CalendarViewController	//控制器，换成你自己的

感谢
===
[思路来源这个博客](http://blog.csdn.net/jasonblog/article/details/21977481)
一部分代码也是看完后直接拿过来的，我把一部分逻辑直接封装到组件里了，他的又有一个类专门控制逻辑。

