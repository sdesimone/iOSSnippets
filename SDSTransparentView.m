//
//  SDSTransparentView.m
//  maniphone
//
//  Created by sergio on 12/14/10.
//  Copyright 2011  Sergio De Simone, Freescapes Labs
//

#import "SDSTransparentView.h"
#import "Three20/Three20.h"

@implementation SDSTransparentView

-(id)initWithContent:(UIView*)contentView andDelegate:(id<SDSTransparentViewProtocol>)delegate {    
    if (self = [super initWithFrame:TTScreenBounds()]) {
		_contentView = contentView;
		_delegate = delegate;
		[self addSubview:contentView];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	[_delegate touchesBegan:touches withEvent:event outsideOfView:_contentView];
}

#pragma mark -

@end

