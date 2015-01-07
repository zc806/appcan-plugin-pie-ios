/**
 * Copyright (c) 2011 Muh Hon Cheng
 * Created by honcheng on 28/4/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *      咋暖轻冷最相思
 *      那堪芳菲又将至
 *      心羡东风娶桃杏
 *      
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import "PCPieChart.h"
#import <QuartzCore/QuartzCore.h>
@implementation PCPieComponent
@synthesize value, title,subTitle,colour, startDeg, endDeg;

- (id)initWithTitle:(NSString*)_title subTitle:(NSString *)_subTitle value:(float)_value
{
    self = [super init];
    if (self)
    {
        self.title = _title;
        self.subTitle = _subTitle;
        self.value = _value;
        self.colour = PCColorDefault;
    }
    return self;
}

+ (id)pieComponentWithTitle:(NSString*)_title subTitle:(NSString *)_subTitle value:(float)_value
{
    return [[[super alloc] initWithTitle:_title subTitle:_subTitle value:_value] autorelease];
}

- (NSString*)description
{
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"title: %@\n", self.title];
    [text appendFormat:@"subTitle: %@\n", self.subTitle];
    [text appendFormat:@"value: %f\n", self.value];
    return text;
}
- (void)dealloc
{
    [colour release];
    [title release];
    [subTitle release];
    [super dealloc];
}

@end

@implementation PCPieChart
@synthesize  components;
@synthesize diameter;
@synthesize titleFont, percentageFont;
@synthesize showArrow, sameColorLabel,strId;
@synthesize imageViewArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
//        [self.layer setMasksToBounds:YES];
//        self.layer.cornerRadius = 10.0f;  // 设置圆角
//        // 添加阴影
//        self.layer.shadowOpacity = 0.5;    // 阴影不透明度
//        self.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
//        self.layer.shadowRadius = 5.0;    // 阴影半径
//        // shadowOffset 阴影偏移
//        self.layer.shadowOffset = CGSizeMake(0,0);
//        [self.layer setShadowOffset:CGSizeMake(1, -1)];
        
        // Rounded corners.
		self.titleFont =[UIFont systemFontOfSize:12];//[UIFont fontWithName:@"GeezaPro" size:15];
		self.percentageFont = [UIFont systemFontOfSize:12];//[UIFont fontWithName:@"HiraKakuProN-W6" size:15]
		self.showArrow = YES;
		self.sameColorLabel = NO;
        if (!self.imageViewArray) {
            self.imageViewArray = [NSMutableArray arrayWithCapacity:1];
        }
		
	}
    return self;
}
//将UIColor转换为RGB值
- (NSMutableArray *) changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return [RGBStrValueArr autorelease];
}
#define LABEL_TOP_MARGIN 15
#define ARROW_HEAD_LENGTH 6
#define ARROW_HEAD_WIDTH 4
#define LABEL_BETWEEN_MARGIN 5
#define QU_LENGTH  10
-(UIImageView *)getLocalImage:(NSString *)name Rect:(CGRect)rect{
    UIImageView *perImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)] autorelease];
    NSString *imageStr = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageStr];
    [perImageView setImage:image];
    [self addSubview:perImageView];
    return perImageView;
}
- (void)drawRect:(CGRect)rect
{
    //remve
    if (self.imageViewArray) {
        for (UIImageView *imageView in self.imageViewArray) {
            if (imageView!=nil&&[imageView isKindOfClass:[UIImageView class]]) {
                [imageView removeFromSuperview];
            }
        }
        if ([self.imageViewArray count]>0) {
            [self.imageViewArray removeAllObjects];
        }
    }
    // Drawing code
//    float margin = 15;
    if (self.diameter==0)
    {   NSString *string = [NSString stringWithFormat:@"最大五个字"];
        defaultSize = [string sizeWithFont:[UIFont systemFontOfSize:12]];
//        diameter = MIN(rect.size.width, rect.size.height) - 2*margin;
        diameter = MAX(rect.size.width, rect.size.height) - 2*defaultSize.width-10*2-15*2;
        diameter = MIN(diameter, rect.size.height);
    }
    float x = (rect.size.width - diameter)/2;
    float y = (rect.size.height - diameter)/2;
//    float gap = 0.5;
    float inner_radius = diameter/2;
    float origin_x = x + diameter/2;
    float origin_y = y + diameter/2;
    
    // label stuff
    float left_label_y =0;//;rect.size.height/5，LABEL_TOP_MARGIN
    float right_label_y =LABEL_TOP_MARGIN; //rect.size.height/5
    
    if ([components count]>0)
    {
        float total = 0;
        for (PCPieComponent *component in components)
        {
            total += component.value;
        }
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
//画圆 和阴影       
//		UIGraphicsPushContext(ctx);
////		CGContextSetRGBFillColor(ctx, 0.8f, 0.5f, 0.2f, 0.7f);  // white color
//		CGContextSetShadow(ctx, CGSizeMake(30.0f, 30.0f), 15);//阴影偏移量，透明度
//		CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diameter, diameter));  // a white filled circle with a diameter of 100 pixels, centered in (60, 60)
        
        
        
//		UIGraphicsPopContext();
//		CGContextSetShadow(ctx, CGSizeMake(0.0f,0.0f),0);
		
		float nextStartDeg = 0;
		float endDeg = 0;
		NSMutableArray *tmpComponents = [NSMutableArray array];
		int last_insert = -1;
		for (int i=0; i<[components count]; i++)
		{
			PCPieComponent *component  = [components objectAtIndex:i];
			float perc = [component value]/total;
			endDeg = nextStartDeg+perc*360;
            //画各个扇形
			CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextFillPath(ctx);
			
            //间隔线
//			CGContextSetRGBStrokeColor(ctx, 0.5, 0.8, 0.5, 1);
            CGContextSetFillColorWithColor(ctx, [[UIColor darkGrayColor] CGColor]);
			CGContextSetLineWidth(ctx, 0.1);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextStrokePath(ctx);
			
			[component setStartDeg:nextStartDeg];
			[component setEndDeg:endDeg];
			if (nextStartDeg<150)
			{
				[tmpComponents addObject:component];//0,1,2,3,4,
			}
			else
			{
				if (last_insert==-1)
				{
					last_insert = i;//i=5,6,7
					[tmpComponents addObject:component];
				}
				else
				{
					[tmpComponents insertObject:component atIndex:last_insert];
				}
			}
			
			nextStartDeg = endDeg;
		}
//		int startDeg = 0;
//        int endDege = 360;
//        CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 0.3f);
//        CGContextMoveToPoint(ctx, origin_x, origin_y);
//        //给整个半圆蒙上一层纱
//        CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 0);
////        CGContextMoveToPoint(ctx, origin_x+inner_radius-outer_circle_width, origin_y);
//        
//        startDeg = 360;
//        endDeg = 0;
//        //去掉那层
//        CGContextAddArc(ctx, origin_x, origin_y, inner_radius-10, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 1);
//        CGContextClosePath(ctx);
//        CGContextFillPath(ctx);
        
        //内层黑环
//        startDeg = 0;
//        endDeg = 360;
//        CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 0.2f);
//        CGContextMoveToPoint(ctx, origin_x, origin_y);
//        CGContextAddArc(ctx, origin_x, origin_y, inner_radius-50, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 0);
////        CGContextMoveToPoint(ctx, origin_x+inner_circle_radius-inner_circle_width, origin_y);
//        startDeg = 360;
//        endDeg = 0;
////        CGContextAddArc(ctx, origin_x, origin_y, inner_radius-60, (startDeg+180)*M_PI/180.0, (endDeg+180)*M_PI/180.0, 1);
//        CGContextClosePath(ctx);
//        CGContextFillPath(ctx);
        
//        CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
//        CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);

		nextStartDeg = 0;
		endDeg = 0;
//		float max_text_width = x -  10;
		float max_text_width = defaultSize.width;
        int count_left = 0;//左侧的总数
        int count_right = 0;//右侧的总数
        for (int i=0; i<[tmpComponents count]; i++)
		{
			PCPieComponent *component  = [tmpComponents objectAtIndex:i];
			nextStartDeg = component.startDeg;
			endDeg = component.endDeg;
			if (nextStartDeg > 150 ||  (nextStartDeg <=150 && endDeg>=270) )
			{
                count_left++;
            }else{
                count_right++;
            }
        }
		for (int i=0; i<[tmpComponents count]; i++)
		{
			PCPieComponent *component  = [tmpComponents objectAtIndex:i];
			nextStartDeg = component.startDeg;
            NSLog(@"==nextStartDeg=%f",nextStartDeg);
			endDeg = component.endDeg;
			if (nextStartDeg > 150 ||  (nextStartDeg <=150 && endDeg>=270) )
			{
				// left
                //显示提示百分比数字      数字和标题换位置
				//float text_x = x + 10;
//				NSString *percentageText = [NSString stringWithFormat:@"%.1f%%", component.value/total*100];
                NSString *titleText = [NSString stringWithFormat:@"%@", component.title];
				CGSize optimumSize = [titleText sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
                NSLog(@"optimumSize:-->:%f",optimumSize.height);

                NSString *subTitleText = [NSString stringWithFormat:@"%@", component.subTitle];
				CGSize subTitleOptimumSize = [subTitleText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(defaultSize.width,100)];
                float average_sx =(self.frame.size.height-(optimumSize.height+subTitleOptimumSize.height)*count_left);
                NSLog(@"average_sx:%f",average_sx);
                if (average_sx<0) {
                    NSLog(@"分母小于0");
                }
                left_label_y =average_sx/(count_left+1)+(average_sx/(count_left+1)+(optimumSize.height+subTitleOptimumSize.height))*(i-count_right);//old: i先画右边再画左边，从count_right开始 因此*(i-count_right),为了美观
                NSLog(@"left_label_y:%f",left_label_y);
                //不规则矩形区域
                CGRect titleFrame =CGRectMake(0, left_label_y,defaultSize.width-1,optimumSize.height);
                //                //纹理图
                UIImageView *imageView_01 = [self getLocalImage:@"uexPie/label-Mask01" Rect:CGRectMake(0, left_label_y, defaultSize.width, optimumSize.height+4+1)];
                if (self.imageViewArray) {
                    [self.imageViewArray addObject:imageView_01];
                }
                 // display percentage label
				if (self.sameColorLabel)
				{   //百分比Label的颜色
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
				}
				else
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
                //箭头线和矩形区域的颜色
                CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                CGContextSetStrokeColorWithColor(ctx, [component.colour CGColor]);
                CGPoint leftUpPointOrign = titleFrame.origin;
                CGPoint leftUpPointOrignDown = CGPointMake(titleFrame.origin.x, titleFrame.origin.y+titleFrame.size.height+4);
                
                CGPoint leftDownPoint = CGPointMake(titleFrame.origin.x+titleFrame.size.width, titleFrame.size.height+4+titleFrame.origin.y);
                CGPoint middlePoint = CGPointMake(leftDownPoint.x+10, left_label_y + (optimumSize.height+4)/2);
                
                CGPoint leftUpPoint = CGPointMake(titleFrame.origin.x+titleFrame.size.width,titleFrame.origin.y);
                CGPoint addLines[] = {leftUpPointOrign,leftUpPointOrignDown,leftDownPoint,middlePoint,leftUpPoint,leftUpPointOrign,};
                CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
                CGContextClosePath(ctx);
                CGContextFillPath(ctx);
                //title
				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 1);
                CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
                CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
                titleFrame =CGRectMake(14, left_label_y+2,defaultSize.width,optimumSize.height+4);//字的frame
				[titleText drawInRect:titleFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
                //三角纹理
                UIImageView *imageView_02 = [self getLocalImage:@"uexPie/label-Mask02" Rect:CGRectMake(leftUpPoint.x+1, leftUpPoint.y, middlePoint.x-leftUpPoint.x, leftDownPoint.y-leftUpPoint.y)];
                if (self.imageViewArray) {
                    [self.imageViewArray addObject:imageView_02];
                }
				if (self.showArrow)
				{
					// draw line to point to chart
//					CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 1);
//					CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 5);
                    //箭头的颜色
                    CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                    CGContextSetStrokeColorWithColor(ctx, [component.colour CGColor]);
					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x;
					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
					CGContextSetLineWidth(ctx, 1);
					if (left_label_y + (optimumSize.height+4)/2 < y)//(left_label_y==LABEL_TOP_MARGIN)
					{
						CGContextMoveToPoint(ctx, middlePoint.x-1, left_label_y + (optimumSize.height+4)/2);
                        if (abs(y1-middlePoint.y)>0) {
                            CGContextAddLineToPoint(ctx, x1-QU_LENGTH, left_label_y + (optimumSize.height+4)/2);
                        }else{
                            CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+4)/2);
                        }
						CGContextAddLineToPoint(ctx, x1, y1);
						CGContextStrokePath(ctx);
						
//						CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//						CGContextClosePath(ctx);
//						CGContextFillPath(ctx);
						
					}
					else
					{
						CGContextMoveToPoint(ctx, middlePoint.x-1, left_label_y + (optimumSize.height+4)/2);
						if (left_label_y + (optimumSize.height+4)/2 > y + diameter)
						{
//							CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+4)/2);
                            if (abs(y1-middlePoint.y)>0) {
                                CGContextAddLineToPoint(ctx, x1-QU_LENGTH, left_label_y + (optimumSize.height+4)/2);
                            }else{
                                CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+4)/2);
                            }
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
//							CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
						}
						else
						{
							float y_diff = y1 - (left_label_y + (optimumSize.height+4)/2);
							if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
							{
								
								// straight arrow
								y1 = left_label_y + (optimumSize.height)/2;
								
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//								CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
//								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_LENGTH, y1);
//								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
//								CGContextClosePath(ctx);
//								CGContextFillPath(ctx);
							}
							else if (left_label_y + (optimumSize.height+4)/2<y1)
							{
								// arrow point down
								
								y1 -= ARROW_HEAD_LENGTH;
//								CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+4)/2);
                                if (abs(y1-middlePoint.y)>0) {
                                    CGContextAddLineToPoint(ctx, x1-QU_LENGTH, left_label_y + (optimumSize.height+4)/2);
                                }else{
                                    CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+4)/2);
                                }
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//								CGContextClosePath(ctx);
//								CGContextFillPath(ctx);
							}
							else
							{
								// arrow point up
								
//								y1 += ARROW_HEAD_LENGTH;
//								CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+4)/2);
                                y1+=(ARROW_HEAD_LENGTH-6);
                                if (abs(y1-middlePoint.y)>0) {
                                    CGContextAddLineToPoint(ctx, x1-QU_LENGTH, left_label_y + (optimumSize.height+4)/2);
                                }else{
                                    CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+4)/2);
                                }
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//								CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
//								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//								CGContextClosePath(ctx);
//								CGContextFillPath(ctx);
							}
						}
					}
					
				}
				// display title on the left
                //左侧title的颜色
				CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
                CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);

				CGRect subTitleFrame = CGRectMake(10+4, left_label_y+titleFrame.size.height, max_text_width, subTitleOptimumSize.height);
				[subTitleText drawInRect:subTitleFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
            }
			else 
			{
                NSString *titleText = [NSString stringWithFormat:@"%@", component.title];
				CGSize optimumSize = [titleText sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
                
                NSString *subTitleText = [NSString stringWithFormat:@"%@", component.subTitle];
				CGSize subTitleOptimumSize = [subTitleText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(defaultSize.width,100)];
                float average_sx =(self.frame.size.height-(optimumSize.height+subTitleOptimumSize.height)*count_right);
                if (average_sx<0) {
                    NSLog(@"分母小于0");
                }
                right_label_y =average_sx/(count_right+1)+(average_sx/(count_right+1)+(optimumSize.height+subTitleOptimumSize.height))*(i);//i先画右边再画左边，从0开始
                float text_x = x*2 + diameter-defaultSize.width;
				CGRect titleFrame = CGRectMake(text_x, right_label_y, defaultSize.width, optimumSize.height+4);
                //纹理图
               UIImageView *imageView_03 =[self getLocalImage:@"uexPie/label-Mask01R" Rect:CGRectMake(text_x, right_label_y, defaultSize.width, optimumSize.height+4)];
                if (self.imageViewArray) {
                    [self.imageViewArray addObject:imageView_03];
                }
				// right
				// display percentage label
				if (self.sameColorLabel)
				{
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.5);
					//CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
				}
				else
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
				//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 1);
                //箭头,线和矩形的颜色
                CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                CGContextSetStrokeColorWithColor(ctx, [component.colour CGColor]);
                //右侧的三角
                CGPoint rightUpPoint = CGPointMake(titleFrame.origin.x-1,titleFrame.origin.y);
                CGPoint middlePoint = CGPointMake(text_x-11, right_label_y + (optimumSize.height+4)/2);
                CGPoint rightDownPoint = CGPointMake(titleFrame.origin.x, titleFrame.size.height+rightUpPoint.y-1);
                CGPoint rightDownPoint_yx = CGPointMake(rightDownPoint.x+defaultSize.width-1, rightDownPoint.y-1);
                CGPoint rightDownPoint_zs = CGPointMake(rightUpPoint.x+defaultSize.width-1, rightUpPoint.y);
                CGPoint addLines[] = {rightUpPoint,middlePoint,rightDownPoint,rightDownPoint_yx,rightDownPoint_zs,rightUpPoint};
                CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
                CGContextClosePath(ctx);
                CGContextFillPath(ctx);
                
                //title
				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 1);
                CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
                CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
                titleFrame = CGRectMake(text_x-10, right_label_y+1, defaultSize.width, optimumSize.height);
                [titleText drawInRect:titleFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
                //三角纹理
                UIImageView *imageView_04 = [self getLocalImage:@"uexPie/label-Mask02R" Rect:CGRectMake(middlePoint.x+1, right_label_y, rightUpPoint.x-middlePoint.x, rightDownPoint.y-rightUpPoint.y)];
                if (self.imageViewArray) {
                    [self.imageViewArray addObject:imageView_04];
                }
                //显示箭头
				if (self.showArrow)
				{
					// draw line to point to chart
//					CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 1);
//                    CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
					//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 5);
                    CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                    CGContextSetStrokeColorWithColor(ctx, [component.colour CGColor]);
					CGContextSetLineWidth(ctx, 1);
					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x; 
					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;

					if (right_label_y + (optimumSize.height+4)/2 < y)//(right_label_y==LABEL_TOP_MARGIN)
					{
						
						CGContextMoveToPoint(ctx, text_x-10, right_label_y + (optimumSize.height+2)/2);
//						CGContextAddLineToPoint(ctx, x1, right_label_y + (optimumSize.height)/2);
//                        float L = QU_LENGTH/cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0);
                        if (abs(y1-middlePoint.y)>0) {
                            CGContextAddLineToPoint(ctx, x1+QU_LENGTH, right_label_y + (optimumSize.height+2)/2);
                        }else{
                            CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+2)/2);
                        }
						CGContextAddLineToPoint(ctx, x1, y1);
						CGContextStrokePath(ctx);
						
						//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//						CGContextClosePath(ctx);
//						CGContextFillPath(ctx);
					}
					else
					{
						float y_diff = y1 - (right_label_y + (optimumSize.height)/2);
						if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
						{
							// straight arrow
							y1 = right_label_y + (optimumSize.height+2)/2;
							
							CGContextMoveToPoint(ctx, text_x-10, right_label_y + (optimumSize.height+2)/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
//							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_LENGTH, y1);
//							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
						}
						else if (right_label_y + (optimumSize.height)/2<y1)
						{
							// arrow point down
							y1 -= ARROW_HEAD_LENGTH;
							
							CGContextMoveToPoint(ctx, text_x-10, right_label_y + (optimumSize.height+2)/2);
//							CGContextAddLineToPoint(ctx, x1, right_label_y + (optimumSize.height+2)/2);
                            if (abs(y1-middlePoint.y)>0) {
                                CGContextAddLineToPoint(ctx, x1+QU_LENGTH, right_label_y + (optimumSize.height+2)/2);
                            }else{
                                CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+2)/2);
                            }
							//CGContextAddLineToPoint(ctx, x1+5, y1);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx); 
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
						}
						else //if (nextStartDeg<180 && endDeg>180)
						{
							// arrow point up
							y1 += ARROW_HEAD_LENGTH;
							
							CGContextMoveToPoint(ctx, text_x-10, right_label_y + (optimumSize.height+2)/2);
//							CGContextAddLineToPoint(ctx, x1, right_label_y + (optimumSize.height+2)/2);
                            if (abs(y1-middlePoint.y)>0) {
                                CGContextAddLineToPoint(ctx, x1+QU_LENGTH, right_label_y + (optimumSize.height+2)/2);
                            }else{
                                CGContextAddLineToPoint(ctx, x1, left_label_y + (optimumSize.height+2)/2);
                            }
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
//							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
						}
					}
				}
				// display title on the right
//				NSString *percentageText = [NSString stringWithFormat:@"%.1f%%", component.value/total*100];
                NSString *percentageText = [NSString stringWithFormat:@"%@", component.subTitle];
				CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
                CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                CGRect subTitleFrame = CGRectMake(titleFrame.origin.x, titleFrame.origin.y+optimumSize.height, titleFrame.size.width, titleFrame.size.height);
                [percentageText drawInRect:subTitleFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
			}
			nextStartDeg = endDeg;
		}
    }
    //背景
    NSString *str = [[NSBundle mainBundle] pathForResource:@"uexPie/bingtu-Mask" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:str];
    UIImage *image = [UIImage imageWithData:imageData];
//    float scale = diameter>image.size.width?diameter:image.size.width;
//    float scale_after = scale/image.size.width;
    float scale = 0.0;
    if (diameter>382) {//382是内圆直径
        scale = 382.0/diameter;
    }else if (diameter<=382){
        scale = diameter/382.0;
    }
    CGSize size = CGSizeMake(image.size.width*scale,image.size.height*scale);
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:thumbnailRect];
    UIImage *fwImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x-6, y-7, size.width, size.height)];
    [bgImageView setImage:fwImage];
    [self addSubview:bgImageView];
    [bgImageView release];
}
- (void)dealloc
{
	[self.titleFont release];
	[self.percentageFont release];
    [self.components release];
    if (strId) {
        self.strId = nil;
    }
    if (imageViewArray) {
        self.imageViewArray = nil;
    }
    [super dealloc];
}


@end
