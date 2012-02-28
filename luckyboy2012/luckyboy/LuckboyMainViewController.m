//
//  LuckboyMainViewController.m
//  luckyboy
//
//  Created by Wang Qiang on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LuckboyMainViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "MyTapGR.h"

@implementation LuckboyMainViewController

@synthesize flipsidePopoverController = _flipsidePopoverController;
@synthesize picArray,image,scrollView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    picArray=[[NSMutableArray alloc] init];
    runtimeArray=[[NSMutableArray alloc] init];
    imageFrame=self.image.frame;
    luckyboys=[[NSMutableArray alloc] init];
    luckyboydicts=[[NSMutableArray alloc] init];
    NSLog(@"%f %f %f %f %d",imageFrame.size.width,imageFrame.size.height,imageFrame.origin.x,imageFrame.origin.y,[[scrollView subviews] count]);
    workingFrame=imageFrame;
    workingFrame.size.width=self.scrollView.frame.size.height*4/3;
    workingFrame.size.height=self.scrollView.frame.size.height;
    workingFrame.origin.x=0;
    workingFrame.origin.y=0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
/*    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return ((interfaceOrientation != UIDeviceOrientationPortrait)&&(interfaceOrientation != UIDeviceOrientationPortraitUpsideDown));
    } else {
        return YES;
    }*/
    return ((interfaceOrientation != UIDeviceOrientationPortrait)&&(interfaceOrientation != UIDeviceOrientationPortraitUpsideDown));//两种设备都只有横屏模式
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(LuckboyFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)dealloc
{
    [_flipsidePopoverController release];
    [super dealloc];
}

- (IBAction)null:(id)sender {
    [image setImage:nil];
}

- (IBAction)showInfo:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
        [albumController setParent:elcPicker];
        [elcPicker setDelegate:self];
        
        [self presentModalViewController:elcPicker animated:YES];
        [elcPicker release];
        [albumController release];
    } else {
        if (!self.flipsidePopoverController) {
            ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
            [albumController setParent:elcPicker];
            [elcPicker setDelegate:self];
            
            self.flipsidePopoverController = [[[UIPopoverController alloc] initWithContentViewController:elcPicker] autorelease];

            [elcPicker release];
            [albumController release];
            
        }
        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
        } else {
            [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self.flipsidePopoverController dismissPopoverAnimated:YES]; 
    }
    [picArray removeAllObjects];
    [picArray addObjectsFromArray:info];
    [runtimeArray removeAllObjects];
    [runtimeArray addObjectsFromArray:picArray];
}

- (UIImage *)imageWithImage:(UIImage *)i scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)handleSingleTap:(UIGestureRecognizer *)sender
{   
    MyTapGR* tap=(MyTapGR*)sender;
    currTapDict=tap.dict;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"从中奖池中移除" message:@"你确定要从中奖池中移除一个中奖者吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.delegate=self;
    [alert show];
    [alert release];    
}

-(void) showImgDetail:(NSDictionary*)dict{
    NSURL *referenceURL = [dict objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset)
     {
         UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
         UIImage* scale=[self imageWithImage:copyOfOriginalImage scaledToSize:imageFrame.size];
         [self.image setImage: scale];
         
         UIImageView* luckyboy=[[UIImageView alloc]initWithImage:copyOfOriginalImage];
         [luckyboy setContentMode:UIViewContentModeScaleAspectFit];
         luckyboy.userInteractionEnabled=true;
         workingFrame.origin.x=workingFrame.size.width*[luckyboys count];
         luckyboy.frame = workingFrame;
         [luckyboys addObject:luckyboy];
         [luckyboydicts addObject:dict];
         
         
         MyTapGR *singleTap = 
         [[MyTapGR alloc] initWithTarget:self 
                                                 action:@selector(handleSingleTap:)];
         singleTap.numberOfTapsRequired = 1;
         singleTap.dict=dict;
         [luckyboy addGestureRecognizer:singleTap];
         [singleTap release];
         
         
         [self.scrollView addSubview:luckyboy];
         [self.scrollView setContentSize:CGSizeMake(workingFrame.size.width*[luckyboys count], workingFrame.size.height)];

         [luckyboy release];
         
     }
            failureBlock:^(NSError *error)
     {
         // error handling
     }];
    [library release];
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    
    if ([picArray count]<=0){
        [image setImage:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"你需要首先选择一个拥有超过1副照片的相册!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        [alert release];    
    }
    else{
        if (!pictimer){
            [runtimeArray removeAllObjects];//每次重新更新列表
            pictimer = [[NSTimer scheduledTimerWithTimeInterval:.05f target:self selector:@selector(onTimer) userInfo:nil repeats:YES] retain];
        }
        else{
            if (currImage){
                [self showImgDetail:currImage];
                [picArray removeObject:currImage];//已经中奖的不再中奖
            }
            [pictimer invalidate];
            pictimer=nil;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {  
    
    if (buttonIndex==1){
        for (int i=0;i<[luckyboydicts count];i++){
            NSDictionary* dict=[luckyboydicts objectAtIndex:i];
            if (dict==currTapDict){
                [luckyboys removeObjectAtIndex:i];
                [luckyboydicts removeObjectAtIndex:i];
                break;
            }
        }
        
        
        for (UIView *v in scrollView.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        };
        
        for (int i=0;i<[luckyboys count];i++){
            UIImageView* img=[luckyboys objectAtIndex:i];
            img.frame=CGRectMake(i*workingFrame.size.width, 0, workingFrame.size.width, workingFrame.size.height);
            [scrollView addSubview:img];
        }
        
        
        [self.scrollView setContentSize:CGSizeMake(workingFrame.size.width*[luckyboys count], workingFrame.size.height)];
        //[selectedView release];
    
        [picArray addObject:currTapDict];
    }
}  

- (void) onTimer {
    if ([runtimeArray count]<=0){
        [runtimeArray addObjectsFromArray:picArray];
    }
    
    int idx=random() % [runtimeArray count];
    currImage=[runtimeArray objectAtIndex:idx];
    [self.image setImage:[currImage objectForKey:UIImagePickerControllerOriginalImage]];
    [runtimeArray removeObjectAtIndex:idx];
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self.flipsidePopoverController dismissPopoverAnimated:YES]; 
    }
}

@end
