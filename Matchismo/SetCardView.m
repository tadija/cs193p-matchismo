//
//  SetCardView.m
//  SuperCard
//
//  Created by Marko Tadić on 7/25/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark Properties

- (void)setNumber:(NSUInteger)number
{
    _number = [[SetCard validNumbers] containsObject:@(number)] ? number : 0;
    [self setNeedsDisplay];
}

- (void)setSymbol:(SetCardSymbol)symbol
{
    _symbol = [[SetCard validSymbols] containsObject:@(symbol)] ? symbol : 0;
    [self setNeedsDisplay];
}

- (void)setShading:(SetCardShading)shading
{
    _shading = [[SetCard validShadings] containsObject:@(shading)] ? shading : 0;
    [self setNeedsDisplay];
}

- (void)setColor:(SetCardColor)color
{
    _color = [[SetCard validColors] containsObject:@(color)] ? color : 0;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_RADIUS 7
#define LINE_WIDTH 2.0
#define COLOR_PERCENT 0.93
#define SYMBOL_WIDTH_PERCENTAGE .7
#define SYMBOL_HEIGHT_PERCENTAGE .6
#define STRIPE_OFFSET 5

- (void)drawRect:(CGRect)rect
{
    // draw blank card
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    [roundedRect setLineWidth:LINE_WIDTH];    
    [roundedRect addClip];
    
    // set blank card fill and stroke color
    UIColor *lightBlueColor = [UIColor colorWithRed:COLOR_PERCENT green:COLOR_PERCENT blue:1 alpha:1];
    UIColor *lightRedColor = [UIColor colorWithRed:1 green:COLOR_PERCENT blue:COLOR_PERCENT alpha:1];
    UIColor *lightGreenColor = [UIColor colorWithRed:COLOR_PERCENT green:1 blue:COLOR_PERCENT alpha:1];
    
    UIColor *cardStrokeColor = (self.isFaceUp) ? ((self.isPenalty) ? [UIColor redColor] : (self.isUnplayable) ? [UIColor greenColor] : [UIColor blueColor]) : [UIColor grayColor];
    UIColor *cardFillColor = (self.isFaceUp) ? ((self.isPenalty) ? lightRedColor : (self.isUnplayable) ? lightGreenColor : lightBlueColor) : [UIColor whiteColor];
    
    [cardFillColor setFill];
    UIRectFill(self.bounds);
    [cardStrokeColor setStroke];
    [roundedRect stroke];
    
    // draw symbols on card
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path setLineWidth:LINE_WIDTH];
    [self drawSymbolsOnPath:path];
    
    // set symbols color
    NSDictionary *colors = @{ @(SetCardColorRed) : [UIColor redColor], @(SetCardColorGreen) : [UIColor greenColor], @(SetCardColorPurple) : [UIColor purpleColor] };
    UIColor *strokeColor = [colors objectForKey:@(self.color)];
    UIColor *fillColor = (self.shading == SetCardShadingSolid) ? strokeColor : [UIColor clearColor];
    
    [fillColor setFill];
    [strokeColor setStroke];
    
    [path fill];
    [path stroke];
    
    // draw stripes
    if (self.shading == SetCardShadingStriped) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self drawStripesOnPath:path withColor:strokeColor inContext:context];
    }
}

- (void)drawSymbolsOnPath:(UIBezierPath *)path
{
    CGSize symbolSize = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_PERCENTAGE, (self.bounds.size.height / 3) * SYMBOL_HEIGHT_PERCENTAGE);
    CGFloat horizontalCenter = self.bounds.size.width / 2;
    
    for (int i = 1; i <= self.number; i++) {
        CGFloat verticalStartingPoint = (self.bounds.size.height / (self.number + 1)) * i;
        CGPoint origin = CGPointMake(horizontalCenter, verticalStartingPoint);
        
        switch (self.symbol) {
            case SetCardSymbolDiamond:
                [self drawDiamondOnPath:path fromPoint:origin withSize:symbolSize];
                break;
                
            case SetCardSymbolSquiggle:
                [self drawSquiggleOnPath:path fromPoint:origin withSize:symbolSize];
                break;
                
            case SetCardSymbolOval:
                [self drawOvalOnPath:path fromPoint:origin withSize:symbolSize];
                break;
                
            default:
                break;
        }
    }
}

- (void)drawDiamondOnPath:(UIBezierPath *)path fromPoint:(CGPoint)origin withSize:(CGSize)size
{
    [path moveToPoint:CGPointMake(origin.x, origin.y - size.height / 2)];
    [path addLineToPoint:CGPointMake(origin.x - size.width / 2, origin.y)];
    [path addLineToPoint:CGPointMake(origin.x, origin.y + size.height / 2)];
    [path addLineToPoint:CGPointMake(origin.x + size.width / 2, origin.y)];
    [path closePath];
}

- (void)drawSquiggleOnPath:(UIBezierPath *)path fromPoint:(CGPoint)origin withSize:(CGSize)size
{
    [path moveToPoint:CGPointMake(origin.x + size.width / 2 - size.width / 4, origin.y - size.height / 2)];
    [path addCurveToPoint:CGPointMake(origin.x - size.width / 2 + size.width / 8, origin.y - size.height / 16)
            controlPoint1:CGPointMake(origin.x, origin.y + size.height / 12)
            controlPoint2:CGPointMake(origin.x - size.width / 8, origin.y - size.height / 1.4)];
    [path addQuadCurveToPoint:CGPointMake(origin.x - size.width / 2 + size.width / 4, origin.y + size.height / 2)
                 controlPoint:CGPointMake(origin.x - size.width / 2, origin.y + size.height / 1.4)];
    [path addCurveToPoint:CGPointMake(origin.x + size.width / 2 - size.width / 8, origin.y + size.height / 16)
            controlPoint1:CGPointMake(origin.x, origin.y - size.height / 12)
            controlPoint2:CGPointMake(origin.x + size.width / 8, origin.y + size.height / 1.4)];
    [path addQuadCurveToPoint:CGPointMake(origin.x + size.width / 2 - size.width / 4, origin.y - size.height / 2)
                 controlPoint:CGPointMake(origin.x + size.width / 2, origin.y - size.height / 1.4)];
    [path closePath];
}

- (void)drawOvalOnPath:(UIBezierPath *)path fromPoint:(CGPoint)origin withSize:(CGSize)size
{
    [path moveToPoint:CGPointMake(origin.x - size.width / 4, origin.y - size.height / 2)];
    [path addArcWithCenter:CGPointMake(origin.x - size.width / 4, origin.y) radius:size.height / 2 startAngle:3 * M_PI / 2 endAngle:M_PI / 2 clockwise:NO];
    [path addLineToPoint:CGPointMake(origin.x + size.width / 4, origin.y + size.height / 2)];
    [path addArcWithCenter:CGPointMake(origin.x + size.width / 4, origin.y) radius:size.height / 2 startAngle:M_PI / 2 endAngle:3 * M_PI / 2 clockwise:NO];
    [path closePath];
}

- (void)drawStripesOnPath:(UIBezierPath *)path withColor:(UIColor *)color inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    [path addClip];
    
    UIBezierPath *stripes = [[UIBezierPath alloc] init];
    stripes.lineWidth = LINE_WIDTH / 3;
    
    for (int i = STRIPE_OFFSET; i < path.bounds.size.width; i += STRIPE_OFFSET) {
        [stripes moveToPoint:CGPointMake(path.bounds.origin.x + i, 0)];
        [stripes addLineToPoint:CGPointMake(path.bounds.origin.x + i, self.bounds.size.height)];
    }
    
    [color setStroke];
    [stripes stroke];
    
    UIGraphicsPopContext();
}

@end
