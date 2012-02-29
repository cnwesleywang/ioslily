//
//  ViewController.m
//  dxzmx
//
//  Created by 强 王 on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize srctxt;
@synthesize dstlabel;

-(NSString*) getPosDesc:(NSString*)value pos:(int)idx pointpos:(int)pointpos{
    NSString* ret=@"";
    int delta=pointpos-idx;
    char c=[value characterAtIndex:idx];
    switch (c){
        case '1':
            ret=[ret stringByAppendingString:@"壹"];
            break;
        case '2':
            ret=[ret stringByAppendingString:@"贰"];
            break;
        case '3':
            ret=[ret stringByAppendingString:@"叁"];
            break;
        case '4':
            ret=[ret stringByAppendingString:@"肆"];
            break;
        case '5':
            ret=[ret stringByAppendingString:@"伍"];
            break;
        case '6':
            ret=[ret stringByAppendingString:@"陆"];
            break;
        case '7':
            ret=[ret stringByAppendingString:@"柒"];
            break;
        case '8':
            ret=[ret stringByAppendingString:@"捌"];
            break;
        case '9':
            ret=[ret stringByAppendingString:@"玖"];
            break;
    }
    
    if (c=='0'){
        if (idx<pointpos){
            if ([value length]>idx+1){
                if (([value characterAtIndex:idx+1]!='0') && ([value characterAtIndex:idx+1]!='.')){
                    if (delta % 4!=1) ret=[ret stringByAppendingString:@"零"];
                }
            }
                
        }
        else{
            ret=[ret stringByAppendingString:@"零"];
        }
    }
    
    if ((delta>0) && (c!='0')){
        switch (delta % 4){
            case 2:
                ret=[ret stringByAppendingString:@"拾"];
                break;
            case 3:
                ret=[ret stringByAppendingString:@"佰"];
                break;
            case 0:
                ret=[ret stringByAppendingString:@"仟"];
                break;
        }
    }
    
    if (delta==5){
        int v=[value intValue];
        int vv=(v % 100000000)/10000;
        if (vv>0) ret=[ret stringByAppendingString:@"万"];
    }
    
    if (delta==9) ret=[ret stringByAppendingString:@"亿"];
    if (delta==-1) ret=[ret stringByAppendingString:@"角"];
    if (delta==-2) ret=[ret stringByAppendingString:@"分"];
    
    return ret;
    
}

-(NSString*) toUppercase:(NSString*)value{
    int total=[value length];
    for (int i=0;i<total;i++){
        if ([value characterAtIndex:i]!='0') break;
        value=[value substringFromIndex:1];
    }
    
    NSString* retvalue=@"";
    NSRange range=[value rangeOfString:@"."];
    int pointpos=range.location;
    if (pointpos==NSNotFound) pointpos=[value length];
    
    if (pointpos>12){
        return @"现在最大只支持到数字:999999999999";
    }
    
    for (int i=0;i<pointpos;i++){
        retvalue =[retvalue stringByAppendingString:[self getPosDesc:value pos:i pointpos:pointpos]];
    }
    
    if ([value intValue]>0){
        retvalue=[retvalue stringByAppendingString:@"元"];
    }
    
    for (int i=pointpos+1;i<[value length];i++){
        retvalue =[retvalue stringByAppendingString:[self getPosDesc:value pos:i pointpos:pointpos]];
    }
    
    if (pointpos==[value length]) retvalue=[retvalue stringByAppendingString:@"整"];
    
    return retvalue;
}

- (IBAction)onConvert:(id)sender {
    NSString* src=self.srctxt.text;
    NSString* value=[self toUppercase:src];
    
    
    CGRect frame=self.dstlabel.frame;
    
    CGSize maximumSize = CGSizeMake(frame.size.width, 9999);
    UIFont *dateFont = [self.dstlabel font];
    CGSize dateStringSize = [value sizeWithFont:dateFont 
                                   constrainedToSize:maximumSize 
                                       lineBreakMode:self.dstlabel.lineBreakMode];
    
    CGRect dateFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, dateStringSize.height);
    
    self.dstlabel.frame = dateFrame;
    self.dstlabel.text=value;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
