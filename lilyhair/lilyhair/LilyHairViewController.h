//
//  LilyHairViewController.h
//  lilyhair
//
//  Created by  on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LilyhairMain.h"

@interface LilyHairViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) LilyhairMain *nextview;

-(IBAction) changeview:(id)sender;
-(IBAction)takephoto:(id)sender;

@end
