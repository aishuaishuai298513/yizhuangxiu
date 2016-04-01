//
//  PlaceholdertextView.m
//  zhaiyi
//
//  Created by ass on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlaceholdertextView.h"

@implementation PlaceholdertextView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

-(void)textChanged:(NSNotification *)notification
{
    if ([[self placeholder]length] == 0) {
        return;
    }
    if ([[self text]length]== 0) {
        [[self viewWithTag:999]setAlpha:0.5];
    }
    
    else{
        [[self viewWithTag:999]setAlpha:0];
    }
}

-(void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        [self.placeHolderLabel removeFromSuperview];
        self.placeHolderLabel = nil;
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([[self placeholder]length]>0) {
        
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.bounds.size.width -16, 0)];
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];

    }
    if ([[self text]length] == 0 && [[self placeholder]length]>0) {
        [[self viewWithTag:999]setAlpha:0.5];
    }
    
}

@end
