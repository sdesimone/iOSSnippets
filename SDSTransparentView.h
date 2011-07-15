//
//  SDSTransparentView.h
//  maniphone
//
//  Created by sergio on 12/14/10.
//  Copyright 2011 Sergio De Simone, Freescapes Labs.
//

#import <Foundation/Foundation.h>


@protocol SDSTransparentViewProtocol

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event outsideOfView:(UIView*)view;

@end


@interface SDSTransparentView : UIView {
	UIView* _contentView;
	id<SDSTransparentViewProtocol> _delegate;
}

-(id)initWithContent:(UIView*)contentView andDelegate:(id<SDSTransparentViewProtocol>)delegate;

@end
