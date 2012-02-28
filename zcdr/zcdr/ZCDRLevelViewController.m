//
//  ZCDRLevelViewController.m
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCDRLevelViewController.h"
#import "ZCDRViewController.h"
#import "LevelCatView.h"
#import "Level.h"
#import "LevelCat+ZCDR.h"

@interface ZCDRLevelViewController()
@property (nonatomic,strong) NSArray* levels;
@property (nonatomic,strong) NSMutableArray* pageOfViews;
@property (nonatomic,weak) Level* segueLevel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbartitle;
@property (nonatomic) BOOL isChinese;

@end

@implementation ZCDRLevelViewController
@synthesize levelcat=_levelcat;
@synthesize pagectrl = _pagectrl;
@synthesize scrollview = _scrollview;
@synthesize levels=_levels;
@synthesize segueLevel=_segueLevel;
@synthesize toolbar = _toolbar;
@synthesize toolbartitle = _toolbartitle;
@synthesize pageOfViews=_pageOfViews;
@synthesize navBarItem=_navBarItem;
@synthesize isChinese=_isChinese;


-(void)setNavBarItem:(UIBarButtonItem *)navBarItem{
    if (_navBarItem!=navBarItem){
        NSMutableArray*toolbaritems=[self.toolbar.items mutableCopy];
        if (_navBarItem) [toolbaritems removeObject:_navBarItem];
        if (navBarItem) [toolbaritems insertObject:navBarItem atIndex:0];
        self.toolbar.items=toolbaritems;
        _navBarItem=navBarItem;
    }
}



-(NSMutableArray*)pageOfViews{
    if (!_pageOfViews){
        _pageOfViews=[[NSMutableArray alloc] init];
    }
    return _pageOfViews;
}

-(void)checkAndAddMorePage:(int)currpage{
    int colnum=ZCDR_COL_NUM;
    int rownum=ZCDR_ROW_NUM;
    int pagenum=_levelcat.levels.count/colnum/rownum;
    if (pagenum*colnum*rownum!=_levelcat.levels.count){
        pagenum+=1;
    }
    self.pagectrl.numberOfPages=pagenum;
    
    int currTotalPage=self.scrollview.contentSize.width/self.scrollview.frame.size.width;
    int totalPage=currTotalPage;
    int i=currpage;
    while (i<currpage+2){
        if (i<totalPage){//这一页已经准备过了，尝试下一页
            i+=1;
            continue;
        }
        if (totalPage>=pagenum) break;
        CGRect frame=CGRectMake(i*self.scrollview.frame.size.width, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
        LevelCatView* catview=[[LevelCatView alloc] initWithFrame:frame];
        catview.levels=self.levels;
        catview.pageidx=i;
        catview.delegate=self;
        [self.scrollview addSubview:catview];
        totalPage+=1;
        i+=1;
        self.scrollview.contentSize=CGSizeMake(totalPage*self.scrollview.frame.size.width, self.scrollview.frame.size.height);
        [self.pageOfViews addObject:catview];
    }
}

-(void) prepareLevelViewInScrollView{
    
    self.pagectrl.currentPage=0;
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES];
    NSArray* levels=[self.levelcat.levels sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    self.levels=levels;
    
    self.scrollview.contentSize=CGSizeZero;
    [self checkAndAddMorePage:0];
    
    self.scrollview.pagingEnabled=YES;
}


-(void)prepareForNewCat{
    NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    self.isChinese = [preferredLang hasPrefix:@"zh-"];
    for (UIView *v in self.scrollview.subviews) {
        if ([v isKindOfClass:[LevelCatView class]]) {
            [v removeFromSuperview];
        }
    };
    [self.pageOfViews removeAllObjects];
    self.scrollview.contentSize=CGSizeZero;
    [self prepareLevelViewInScrollView];
}

-(void) setAllTitle:(NSString*)t{
    self.title=t;
    self.toolbartitle.title=t;
    
}

-(void) setLevelcat:(LevelCat *)levelcat{
    if (_levelcat!=levelcat){
        _levelcat=levelcat;
        [self prepareForNewCat];
        if (self.isChinese){
            [self setAllTitle:levelcat.name];
        }
        else{
            [self setAllTitle:levelcat.fold];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController respondsToSelector:@selector(setLevel:)]){
        [segue.destinationViewController setLevel:self.segueLevel];
    }

    if ([segue.destinationViewController respondsToSelector:@selector(setDelegate:)]){
        [segue.destinationViewController setDelegate:self];
    }
}

-(void)levelFailed:(id)sender{
    //ZCDRViewController* dr=sender;
    //Level* l=dr.level;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)levelSucc:(id)sender{
    ZCDRViewController* dr=sender;
    Level* l=dr.level;
    l.passed=[NSNumber numberWithInt:1];
    
    self.levelcat.passed=[NSNumber numberWithInt:[self.levelcat getPassedTotal]];
    
    int idx=[self.levels indexOfObject:l];
    int page=idx/ZCDR_COL_NUM/ZCDR_ROW_NUM;
    [[self.pageOfViews objectAtIndex:page] setNeedsDisplay];
    
    if (idx<[self.levels count]-1){
        dr.level = [self.levels objectAtIndex:idx+1];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)levelCatView:(LevelCatView *)sender touchInIdx:(int)idx{
    self.segueLevel=[self.levels objectAtIndex:idx];
    
    Level *lastlevel=nil;
    if (idx>=1) {
        lastlevel=[self.levels objectAtIndex:idx-1];
    }
    if ((!lastlevel) || ([lastlevel passed])){
        [self performSegueWithIdentifier:@"show level" sender:self];
    }
    else{
        NSLog(@"should not be here. touch index:%d",idx);
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    /*for (int i=0;i<[self.pageOfViews count];i++){
        LevelCatView* view=[self.pageOfViews objectAtIndex:i];
        view.frame=CGRectMake(i*self.scrollview.frame.size.width, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
    }
    self.scrollview.contentSize=CGSizeMake([self.pageOfViews count]*self.scrollview.frame.size.width, self.scrollview.frame.size.height);*/
    [self prepareForNewCat];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1  
{
    CGPoint offsetofScrollView = scrollView1.contentOffset; 
    int currpage=offsetofScrollView.x / self.scrollview.frame.size.width;
    [self.pagectrl setCurrentPage:currpage];
    [self checkAndAddMorePage:currpage];
}

-(void) viewWillAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=self.navBarItem;    
    [self prepareForNewCat];
}

- (void)viewDidUnload {
    [self setPagectrl:nil];
    [self setScrollview:nil];
    [self setToolbar:nil];
    [self setToolbartitle:nil];
    [super viewDidUnload];
}
@end
