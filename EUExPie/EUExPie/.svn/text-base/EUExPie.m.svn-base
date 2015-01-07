//
//  EUExPie.m
//  AppCan
//
//  Created by AppCan on 13-2-21.
//
//

#import "EUExPie.h"
#import "PCPieChart.h"
#import "EUtility.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
@implementation EUExPie
@synthesize pieChartArray;
//@synthesize pieChart;
- (id)initWithBrwView:(EBrowserView *)eInBrwView{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
        
    }
    return self;
}
-(void)open:(NSMutableArray *)array{
    if ([array count]>0) {
        NSString *x=[array objectAtIndex:1];
        NSString *y=[array objectAtIndex:2];
        NSString *width=[array objectAtIndex:3];
        NSString *height=[array objectAtIndex:4];
        NSString *stringId=[NSString stringWithFormat:@"%@", [array objectAtIndex:0]];
        if (!self.pieChartArray) {
            self.pieChartArray = [NSMutableArray arrayWithCapacity:1];
        }
        PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake([x floatValue],[y floatValue],[width floatValue],[height floatValue])];
        [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
//        [pieChart setDiameter:[width floatValue]/2];
        [pieChart setSameColorLabel:NO];
        pieChart.strId =stringId;
        if (![self.pieChartArray containsObject:pieChart]) {
            [self.pieChartArray addObject:pieChart];
        }
        NSString *str = nil;
        if ([width floatValue]>=[height floatValue]) {
            str = [[NSBundle mainBundle] pathForResource:@"uexPie/bg2" ofType:@"png"];
        }else{
            str = [[NSBundle mainBundle] pathForResource:@"uexPie/bg1" ofType:@"png"];
        }
        NSData *imageData = [NSData dataWithContentsOfFile:str];
        UIImage *image = [UIImage imageWithData:imageData];
//        image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:pieChart.frame];
        [bgImageView setImage:image];
        [EUtility brwView:meBrwView addSubview:bgImageView];
        [EUtility brwView:meBrwView insertSubView:bgImageView aboveSubView:pieChart];
        [bgImageView release];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            pieChart.titleFont = [UIFont systemFontOfSize:12];
            pieChart.percentageFont = [UIFont systemFontOfSize:12];
        }
        [EUtility brwView:meBrwView addSubview:pieChart];
        [pieChart release];
        NSString *jsstr = [NSString stringWithFormat:@"if(uexPie.loadData!=null){uexPie.loadData('%@')}",stringId];
        [EUtility brwView:meBrwView evaluateScript:jsstr];
        NSString *jsstrCB = [NSString stringWithFormat:@"if(uexPie.cbOpen!=null){uexPie.cbOpen('%@')}",stringId];
        [EUtility brwView:meBrwView evaluateScript:jsstrCB];
    }else{
        
    }
    //loadData(@"");
    //setJsonData(id,json);
}
//16进制颜色(html颜色值)字符串转为UIColor
-(UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
-(void)setJsonData:(NSMutableArray *)array{
    if ([array count]==0) {
        return;
    }
    NSString *string = [array objectAtIndex:0];
    NSDictionary *jsonDict = [string JSONValue];
    if (!jsonDict) {
        return;
    }
    NSString *strId = [NSString stringWithFormat:@"%@",[jsonDict objectForKey:@"id"]];
    PCPieChart *pieChart = nil;
    if (self.pieChartArray) {
        for (PCPieChart *pieChart_ in self.pieChartArray) {
            if (pieChart_!=nil&&[pieChart_ isKindOfClass:[PCPieChart class]]) {
                if ([strId isEqualToString:pieChart_.strId]) {
                    pieChart = pieChart_;
                }
            }
        }
    }
    if (pieChart&&[pieChart.strId isEqualToString:strId]) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"data"]];
        NSMutableArray *array = [NSMutableArray array];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 intValue] > [obj2 intValue]){
                return NSOrderedDescending;
            }
            if([obj1 intValue] < [obj2 intValue]){
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        NSArray *sortArray = [dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

        
        for (int i=0; i<[sortArray count]; i++) {
            if (![array containsObject:[sortArray objectAtIndex:i]]&&(i%2==0)) {
                [array addObject:[sortArray objectAtIndex:i]];
            }
        }
        int j=[sortArray count]-1;
        for (int i=0; i<[sortArray count]; i++) {
            if (![array containsObject:[sortArray objectAtIndex:j]]&&(j%2!=0)) {
                [array addObject:[sortArray objectAtIndex:j]];
            }
            j--;
        }
//        [array addObjectsFromArray:sortArray];
        NSMutableArray *components = [NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<[array count]; i++)
        {
            NSDictionary *item = [array objectAtIndex:i];
            PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item objectForKey:@"title"] subTitle:[item objectForKey:@"subTitle"] value:[[item objectForKey:@"value"] floatValue]];
            [component setColour:[self hexStringToColor:[item objectForKey:@"color"]]];
            [components addObject:component];
        }
        [pieChart setComponents:components];
        [pieChart setNeedsDisplay];
    }else{
        NSString *jsstr = [NSString stringWithFormat:@"setJsonData  pieChart:%@  init  faild!",strId];
        [super jsSuccessWithName:@"uexWidgetOne.cbError" opId:0 dataType:0 strData:jsstr];
    }
 }
-(void)close:(NSMutableArray *)array{
    if ([array count]>0) {
        NSString *IdStr = [array objectAtIndex:0];
        NSArray *IdArray = [IdStr componentsSeparatedByString:@","];
        if (self.pieChartArray) {
            for (NSString *stringId in IdArray) {
                for (UIView *subView in self.pieChartArray) {
                    if (subView!=nil&&[subView isKindOfClass:[PCPieChart class]]) {
                        PCPieChart *subViewPieChart = (PCPieChart *)subView;
                        for (UIView *subView in [subViewPieChart.superview subviews]) {
                            if (subView!=nil&&[subView isKindOfClass:[UIImageView class]]) {
                                [subView removeFromSuperview];
                            }
                        }
                        if ([subViewPieChart.strId isEqualToString:stringId]) {
                            [subViewPieChart removeFromSuperview];
                        }
                    }
                }
                
            }
        }
    }else{
        //全部移除
        if (self.pieChartArray) {
            for (UIView *subView in self.pieChartArray) {
                if (subView!=nil&&[subView isKindOfClass:[PCPieChart class]]) {
                    PCPieChart *subViewPieChart = (PCPieChart *)subView;
                    for (UIView *subView in [subViewPieChart.superview subviews]) {
                        if (subView!=nil&&[subView isKindOfClass:[UIImageView class]]) {
                            [subView removeFromSuperview];
                        }
                    }
                    [subViewPieChart removeFromSuperview];
                }
            }
        }
    }
}
-(void)clean{
    if (self.pieChartArray) {
        self.pieChartArray = nil;
    }
    [super clean];
}
-(void)dealloc{
    if (self.pieChartArray) {
        self.pieChartArray = nil;
    }
    [super dealloc];
}
@end
