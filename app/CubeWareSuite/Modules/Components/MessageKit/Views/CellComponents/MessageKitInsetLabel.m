//
//  MessageInsetLabel.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitInsetLabel.h"

@implementation MessageKitInsetLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setTextInsets:(UIEdgeInsets)textInsets{
    _textInsets = textInsets;
    [self setNeedsDisplay];
}

-(void)drawTextInRect:(CGRect)rect{
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, self.textInsets);
    [super drawTextInRect:insetRect];
}

@end
