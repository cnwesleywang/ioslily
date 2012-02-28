//
//  ZCDRCatViewController.m
//  zcdr
//
//  Created by Wang Qiang on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCDRCatViewController.h"
#import "LevelCat+ZCDR.h"
#import "Level+ZCDR.h"
#import "ZCDRLevelViewController.h"

@interface ZCDRCatViewController()
@property (nonatomic) BOOL isChinese;
@property (nonatomic,strong)UIActivityIndicatorView* activityIndicator;
@end

@implementation ZCDRCatViewController
@synthesize isChinese=_isChinese;
@synthesize activityIndicator=_activityIndicator;
@synthesize leveldatabase=_leveldatabase;

-(void)awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate=self;
}

-(void)setRelativeLevelCat:(NSIndexPath*)indexPath{
    LevelCat* cat=[self.fetchedResultsController objectAtIndexPath:indexPath];
    id vc=[self.splitViewController.viewControllers lastObject];
    if ([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController* nav=vc;
        vc=[nav.viewControllers lastObject];
    }
    if ((vc) && ([vc respondsToSelector:@selector(setLevelcat:)])){
        [vc setLevelcat:cat];
    }
}

-(void)fetchResultsController{
    NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"locale:%@",preferredLang);
    self.isChinese = [preferredLang hasPrefix:@"zh-"];

    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"LevelCat"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.leveldatabase.managedObjectContext 
                                                                          sectionNameKeyPath:nil cacheName:nil];

    if (self.splitViewController){
        [self setRelativeLevelCat:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    [self.activityIndicator stopAnimating];
    self.activityIndicator=nil;
    
}

-(void)splitViewController:(UISplitViewController *)svc 
    willShowViewController:(UIViewController *)aViewController 
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    id nav=[self.splitViewController.viewControllers lastObject];
    if (nav){
        if ([nav respondsToSelector:@selector(setNavBarItem:)]){
            [nav setNavBarItem:nil];
        }
    }    
}

-(void)splitViewController:(UISplitViewController *)svc 
    willHideViewController:(UIViewController *)aViewController 
         withBarButtonItem:(UIBarButtonItem *)barButtonItem 
      forPopoverController:(UIPopoverController *)pc{
    id nav=[self.splitViewController.viewControllers lastObject];
    if (nav){
        if ([nav respondsToSelector:@selector(setNavBarItem:)]){
            barButtonItem.title=self.navigationItem.title;
            [nav setNavBarItem:barButtonItem];
        }
    }    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(NSDictionary*)getDictionaryFromDataFile:(NSString*)path ext:(NSString*) ext{
    NSError* error;
    NSString* basepath = [[NSBundle mainBundle] pathForResource:path
                                                     ofType:ext];
    NSData* content = [NSData  dataWithContentsOfFile:basepath];
    return [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:&error];
}

-(void)fillJsonDataIntoDocument:(UIManagedDocument*) document{
    NSDictionary* levels=[self getDictionaryFromDataFile:@"data" ext:@"json"];
    for (NSDictionary* levelcat in levels.allValues){
        [LevelCat levelcatWithDictionary:levelcat inManagedObjectContext:[document managedObjectContext]];
        for (NSDictionary* level in [[levelcat objectForKey:@"contents"] allValues]){
            [Level  levelWithDictionary:level inManagedObjectContext:[document managedObjectContext]];
        }
    }
}

-(void) useDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.leveldatabase.fileURL path]]){
        [self.leveldatabase saveToURL:self.leveldatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL succ){
            [self fillJsonDataIntoDocument:self.leveldatabase];
            [self fetchResultsController];
        }];
    }else if (self.leveldatabase.documentState == UIDocumentStateClosed){
        [self.leveldatabase openWithCompletionHandler:^(BOOL success) {
            [self fetchResultsController];
        }];
    }else if (self.leveldatabase.documentState == UIDocumentStateNormal){
        [self fetchResultsController];
    }
}

-(void)setLeveldatabase:(UIManagedDocument *)leveldatabase{
    if (_leveldatabase!=leveldatabase){
        _leveldatabase=leveldatabase;
        [self useDocument];
    }
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    if (!self.leveldatabase){
        NSURL* url=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url=[url URLByAppendingPathComponent:@"level database"];
        self.leveldatabase=[[UIManagedDocument alloc] initWithFileURL:url];
        
        self.activityIndicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        self.activityIndicator.center = self.view.center;
        [self.activityIndicator startAnimating];
        [self.view addSubview: self.activityIndicator];
        
    }    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"level cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    LevelCat * cat=[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (self.isChinese){
        cell.textLabel.text=cat.name;
        cell.detailTextLabel.text= [NSString stringWithFormat:@"共%d关卡,已通过%d关卡",cat.levels.count,[cat.passed intValue]];
    }
    else{
        cell.textLabel.text=cat.fold;
        cell.detailTextLabel.text= [NSString stringWithFormat:@"Total:%d Levels, Passed %d Levels",cat.levels.count,[cat.passed intValue]];
    }
    NSString* imagepath=[[[cat.levels anyObject] path] stringByAppendingString:@"a.jpg"];
    cell.imageView.image=[UIImage  imageNamed:imagepath];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setRelativeLevelCat:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexpath=[self.tableView indexPathForCell:sender];
    LevelCat* cat=[self.fetchedResultsController objectAtIndexPath:indexpath];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setLevelcat:)]){
        [segue.destinationViewController setLevelcat:cat];
    }
        
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.leveldatabase=nil;
}

@end
