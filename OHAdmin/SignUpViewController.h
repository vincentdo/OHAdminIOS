//
//  SignupViewController.h
//  Chatter
//
//  Created by Josh Pearlstein on 11/3/15.
//  Copyright © 2015 SEAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface SignupViewController : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
