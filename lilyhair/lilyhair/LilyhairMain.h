//
//  LilyhairMain.h
//  lilyhair
//
//  Created by  on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LilyhairMain : UIViewController<UIGestureRecognizerDelegate>{
    UIRotationGestureRecognizer *pgr;
    UIPinchGestureRecognizer *pgr1;
    UIPanGestureRecognizer *panGesture;
    UISwipeGestureRecognizer *swipeleft;
    UISwipeGestureRecognizer *swiperight;
    UITapGestureRecognizer *tap;
    int curStyle;
    int styleTotal;
}
@property (strong, nonatomic) IBOutlet UIImageView *base;
@property (strong, nonatomic) IBOutlet UIImageView *style;
@property (strong, nonatomic) IBOutlet UIImageView *mask;

@property (strong, nonatomic) IBOutlet UIButton *btnsave,*btnchange,*btnback,*btnnext;
@property (strong, nonatomic) IBOutlet UILabel *hint;


-(IBAction)goback:(id)sender;
-(void)changeBase:(id)image;
-(IBAction)changeup:(id)sender;
-(IBAction)changedown:(id)sender;
-(IBAction)save:(id)sender;
-(void) removeBtns;

@end
