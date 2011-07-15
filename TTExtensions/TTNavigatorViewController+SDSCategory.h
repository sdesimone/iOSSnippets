//
//  UINavigationControllerSDSTTAdditions.h
//  maniphone
//
//  Created by sergio on 1/15/11.
//  Copyright 2011 Sergio De Simone, Freescapes Labs.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Three20UINavigator/TTNavigatorViewController.h>
#import <Three20Style/TTStyledText.h>

@interface TTNavigatorViewController (SDSCategory)

- (void)goBackHome;
- (void)goBackHomeWithErrorDescription:(NSString*)description andReason:(NSString*)reason;
- (UIButton*)buttonWithImageUri:(NSString*)image andAction:(SEL)action;
- (void)setNavigationLabel:(TTStyledText*)title;
- (void)setHTMLTitle:(NSString*)htmlTitle;
	
@end
