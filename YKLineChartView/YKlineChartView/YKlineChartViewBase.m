//
//  YKlineChartViewBase.m
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//

#import "YKlineChartViewBase.h"

#import "YKLineEntity.h"
@interface YKlineChartViewBase()




@end
@implementation YKlineChartViewBase
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        
    }
    return self;
}

- (void)commonInit {
    
    [super commonInit];
 
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect;
{
    
    CGContextSetFillColorWithColor(context, self.gridBackgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    //画边框
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, self.contentTop, self.contentWidth, (self.uperChartHeightScale * self.contentHeight)));
    
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht, self.contentWidth, (self.contentBottom - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)));
    
    //画中间的线
    [self drawline:context startPoint:CGPointMake(self.contentLeft,(self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop) stopPoint:CGPointMake(self.contentRight, (self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop) color:self.borderColor lineWidth:self.borderWidth/2.0];
    
}

- (void)drawLabelPrice:(CGContextRef)context
{
    NSMutableDictionary * drawAttributes = [@{} mutableCopy];
    drawAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    NSString * maxPriceStr = [self handleStrWithPrice:self.maxPrice];
    NSMutableAttributedString * maxPriceAttStr = [[NSMutableAttributedString alloc]initWithString:maxPriceStr attributes:drawAttributes];
    CGSize sizeMaxPriceAttStr = [maxPriceAttStr size];
    [self drawLabel:context attributesText:maxPriceAttStr rect:CGRectMake(self.contentLeft - sizeMaxPriceAttStr.width, self.contentTop, sizeMaxPriceAttStr.width, sizeMaxPriceAttStr.height)];
    
    NSString * midPriceStr = [self handleStrWithPrice:(self.maxPrice+self.minPrice)/2];
    NSMutableAttributedString * midPriceAttStr = [[NSMutableAttributedString alloc]initWithString:midPriceStr attributes:drawAttributes];
    CGSize sizeMidPriceAttStr = [midPriceAttStr size];
    [self drawLabel:context attributesText:midPriceAttStr rect:CGRectMake(self.contentLeft - sizeMidPriceAttStr.width, ((self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop)-sizeMidPriceAttStr.height/2.0, sizeMidPriceAttStr.width, sizeMidPriceAttStr.height)];
    
    NSString * minPriceStr = [self handleStrWithPrice:self.minPrice];
    NSMutableAttributedString * minPriceAttStr = [[NSMutableAttributedString alloc]initWithString:minPriceStr attributes:drawAttributes];
    CGSize sizeMinPriceAttStr = [minPriceAttStr size];
    [self drawLabel:context attributesText:minPriceAttStr rect:CGRectMake(self.contentLeft - sizeMinPriceAttStr.width, ((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMinPriceAttStr.height ), sizeMinPriceAttStr.width, sizeMinPriceAttStr.height)];
    
    NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[self handleShowWithVolume:self.maxVolume] attributes:drawAttributes];
    CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
    [self drawLabel:context attributesText:zeroVolumeAttStr rect:CGRectMake(self.contentLeft - zeroVolumeAttStrSize.width, self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height)];
    
    NSString * maxVolumeStr = [self handleShowNumWithVolume:self.maxVolume];
    NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
    CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
    [self drawLabel:context attributesText:maxVolumeAttStr rect:CGRectMake(self.contentLeft - maxVolumeAttStrSize.width, (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height)];
    
    
}


- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
                   idex:(NSInteger)idex
                  value:(id)value
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth
{
    
    NSString * leftMarkerStr;
    NSString * bottomMarkerStr;
    
    
    if ([value isKindOfClass:[YKTimeLineEntity class]]) {
        YKTimeLineEntity * entity = value;
        leftMarkerStr = [self handleStrWithPrice:entity.lastPirce];
        
        bottomMarkerStr = entity.currtTime;
        
    }else if([value isKindOfClass:[YKLineEntity class]]){
        YKLineEntity * entity = value;
        leftMarkerStr = [self handleStrWithPrice:entity.close];
        bottomMarkerStr = entity.date;
    }else{
        return;
    }
    
    if (nil == leftMarkerStr || nil == bottomMarkerStr) {
        return;
    }
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point.x, self.contentTop);
    CGContextAddLineToPoint(context, point.x, self.contentBottom);
    CGContextStrokePath(context);
    
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.contentLeft, point.y);
    CGContextAddLineToPoint(context, self.contentRight, point.y);
    CGContextStrokePath(context);
    
    CGFloat radius = 3.0;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(point.x-(radius/2.0), point.y-(radius/2.0), radius, radius));
    
    
    NSMutableDictionary * drawAttributes = [@{} mutableCopy];
    drawAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    drawAttributes[NSBackgroundColorAttributeName] = [UIColor whiteColor];
    
    
    NSMutableAttributedString * leftMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:leftMarkerStr attributes:drawAttributes];
    
    CGSize leftMarkerStrAttSize = [leftMarkerStrAtt size];
    [self drawLabel:context attributesText:leftMarkerStrAtt rect:CGRectMake(self.contentLeft - leftMarkerStrAttSize.width,point.y - leftMarkerStrAttSize.height/2.0, leftMarkerStrAttSize.width, leftMarkerStrAttSize.height)];
    
    
    NSMutableAttributedString * bottomMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:bottomMarkerStr attributes:drawAttributes];
    
    CGSize bottomMarkerStrAttSize = [bottomMarkerStrAtt size];
    [self drawLabel:context attributesText:bottomMarkerStrAtt rect:CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0,  ((self.uperChartHeightScale * self.contentHeight) + self.contentTop), bottomMarkerStrAttSize.width, bottomMarkerStrAttSize.height)];
    
    
    
}

- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect
{
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    [attributesText drawInRect:rect];
}

- (void)drawRect:(CGContextRef)context
            rect:(CGRect)rect
           color:(UIColor*)color
{
    if ((rect.origin.x + rect.size.width) > self.contentRight) {
        return;
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}

- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth
{
    if (startPoint.x < self.contentLeft ||stopPoint.x >self.contentRight || startPoint.y <self.contentTop || stopPoint.y < self.contentTop) {
        return;
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}


- (NSString *)handleStrWithPrice:(CGFloat)price
{
    return [NSString stringWithFormat:@"%.2f ",price];
}
- (NSString *)handleShowWithVolume:(CGFloat)volume
{
    volume = volume/100.0;
    
    if (volume < 10000.0) {
        return @"手 ";
    }else if (volume > 10000.0 && volume < 100000000.0){
        return @"万手 ";
    }else{
        return @"亿手 ";
    }
}
- (NSString *)handleShowNumWithVolume:(CGFloat)volume
{
    volume = volume/100.0;
    if (volume < 10000.0) {
        return [NSString stringWithFormat:@"%.0f ",volume];
    }else if (volume > 10000.0 && volume < 100000000.0){
        return [NSString stringWithFormat:@"%.0f ",volume/10000.0];
    }else{
        return [NSString stringWithFormat:@"%.0f ",volume/100000000.0];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
