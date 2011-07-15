//
//  UINavigationControllerSDSTTAdditions.m
//  maniphone
//
//  Created by sergio on 1/15/11.
//  Copyright 2011 Sergio De Simone, Freescapes Labs.
//

#import "TTNavigatorViewController+SDSCategory.h"
#import "Three20/Three20.h"

@implementation TTNavigatorViewController (SDSCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)goBackHome {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertWithDescription:(NSString*)description andReason:(NSString*)reason{
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: description
							   message: nil
							   delegate:nil
							   cancelButtonTitle:NSLocalizedString(@"Understood!", @"")
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)goBackHomeWithErrorDescription:(NSString*)description andReason:(NSString*)reason {
	[self alertWithDescription:description andReason:reason];
	[self performSelector:@selector(goBackHome) withObject:nil afterDelay:1];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)buttonWithImageUri:(NSString*)image andAction:(SEL)action {
	UIImage *buttonImage = TTIMAGE(image);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:buttonImage forState:UIControlStateNormal];
	backButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
	[backButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return backButton;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setNavigationLabel:(TTStyledText*)title {
	TTStyledTextLabel* textLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(200, 10, 180, 50)] autorelease];
//	textLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	textLabel.text = title;
	[textLabel sizeToFit];
	self.navigationItem.titleView = textLabel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHTMLTitle:(NSString*)htmlTitle {
	[self setNavigationLabel:[TTStyledText textFromXHTML:htmlTitle lineBreaks:YES URLs:NO]];
}

@end
