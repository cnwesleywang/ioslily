//
//  LilyhairMain.m
//  lilyhair
//
//  Created by  on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LilyhairMain.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation LilyhairMain
@synthesize base,style,btnback,btnsave,btnchange,hint,mask,btnnext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

SystemSoundID bell;  
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    curStyle=1;
    styleTotal=26;
    
    pgr = [[UIRotationGestureRecognizer alloc] 
                                     initWithTarget:self action:@selector(handleRotationFrom:)];
    pgr.delegate = self;
    [base addGestureRecognizer:pgr];
    
    pgr1=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pgr1.delegate = self;
    [base addGestureRecognizer:pgr1];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [base addGestureRecognizer:panGesture];
    
    base.layer.masksToBounds=YES;
    base.layer.cornerRadius=10.0;
    base.layer.borderWidth=1.0;
    base.layer.borderColor=[[UIColor grayColor] CGColor];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"kacha" ofType:@"wav"]], &bell);  
    
}

-(void) removeBtns{
    [btnsave removeFromSuperview];
    [btnback removeFromSuperview];
    [btnchange removeFromSuperview];
    [btnnext removeFromSuperview];
}

-(void) showBtns{
    [self.view addSubview:btnsave];
    [self.view addSubview:btnback];
    [self.view addSubview:btnchange];
    [self.view addSubview:btnnext];
}

-(void) changeBase:(id)image{
    [self.base setImage:image];
    self.base.transform = CGAffineTransformMakeScale(1, 1);
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        base.transform = CGAffineTransformScale([base transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = base;
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

-(IBAction)changeup:(id)sender{
    curStyle+=1;
    if (curStyle>styleTotal){
        curStyle=styleTotal;
    }
    else{
        self.mask.alpha=1;
        [style setImage: [UIImage imageNamed:[NSString stringWithFormat:@"h%02d.png",curStyle]]];
        AudioServicesPlaySystemSound (bell);                
        [UIView animateWithDuration:0.65 animations:^{
            mask.alpha = 0;
        }];
    }
}

-(IBAction)changedown:(id)sender{
    curStyle-=1;
    if (curStyle<1){
        curStyle=1;
    }
    else{
        self.mask.alpha=1;
        [style setImage: [UIImage imageNamed:[NSString stringWithFormat:@"h%02d.png",curStyle]]];
        AudioServicesPlaySystemSound (bell);                
        [UIView animateWithDuration:0.65 animations:^{
            mask.alpha = 0;
        }];
    }
}

-(IBAction)goback:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender{
    [self removeBtns];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(dosave:) userInfo:nil repeats:NO];
    
}

-(void)dosave:(NSTimer*)timer{
    UIWindow *theScreen = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIGraphicsBeginImageContext(theScreen.frame.size);
    [[theScreen layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Message", nil)   
                                                   message:NSLocalizedString(@"Saved",nil)   
                                                  delegate:self   
                                         cancelButtonTitle:NSLocalizedString(@"OK",nil)   
                                         otherButtonTitles:nil];
    [alert show];
    [self showBtns];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)handleRotationFrom:(UIRotationGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        base.transform = CGAffineTransformRotate([base transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }}


@end
