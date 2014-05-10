//
//  RMPieChart.h
//  RMPieChart
//
//  Created by Mahesh on 2/4/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RMPieChartDataSource <NSObject>
@required
- (NSUInteger)numberOfSlicesInChartView:(id)chartView;
- (CGFloat)percentOfTotalValueOfSliceAtIndexpath:(NSIndexPath *)indexPath chart:(id)chartView;
- (UIColor *)colorForSliceAtIndexPath:(NSIndexPath *)indexPath slice:(id)pieSlice;
@end

@protocol RMPieChartDelegate <NSObject>
@optional
- (void)didClearChartView:(id)chartView;
@end


@interface RMPieChart : UIView

@property(nonatomic, weak)id<RMPieChartDataSource>datasource;
@property(nonatomic, weak)id<RMPieChartDelegate>delegate;
@property(nonatomic, strong)UIColor *chartBackgroundColor;
@property(nonatomic, assign)CGFloat radiusPercent;

// loads the chart. without call to this there will be no chart!
- (void)loadChart;

// reloads the chart and calls the data source
- (void)reloadChart;

// reset the view (just clear out the chart)
- (void)resetChart;

@end
