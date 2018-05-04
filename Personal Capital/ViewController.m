//
//  ViewController.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 4/30/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "ViewController.h"
#import "RSSParser.h"
#import "RSSEntry.h"
#import "Cell.h"
#import "HeaderView.h"

@interface ViewController () {
    
    NSArray *feeds;
    UIActivityIndicatorView *spinner;
    RSSParser *rssParser;
    BOOL iPad;
    HeaderView *headerView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // nav bar
    self.title = @"Research & Insights";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"⟲" style:UIBarButtonItemStyleDone target:self action:@selector(refreshFeed)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    
    // collection view layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat headerHeight = 150 + (self.view.bounds.size.width * 300)/780;
    layout.sectionInset = UIEdgeInsetsMake(headerHeight, 15, 10, 15);
    layout.minimumLineSpacing = 10;
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    
    // header view
    headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, _collectionView.frame.size.width, headerHeight - 50)];
    
    // parser
    // register for notification to subscribe to the parser finish notification
    //  note: this also can be implemented with delegate design pattern
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFeeds:) name:@"RSSParsingDone" object:nil];
    rssParser = [[RSSParser alloc] init];
    [rssParser startParsing];
    
    // activity indicator
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    spinner.center = self.view.center;
    [spinner startAnimating];
}

/**
 loads the content after receiving notification indicating the parser did parsed the document
 @param notification contains array of articles
 */
-(void)loadFeeds:(NSNotification *)notification {
    
    feeds = [notification object];
    // back to main thread to update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner stopAnimating];
        [_collectionView addSubview:headerView];
        [headerView setRSSFeed:((RSSEntry *)[feeds objectAtIndex:0])];
        [_collectionView reloadData];
    });
}

/**
 referesh handler
 */
-(void)refreshFeed {
    [spinner startAnimating];
    [rssParser startParsing];
}

#pragma mark -
#pragma mark collection view

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return feeds.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    RSSEntry *currentArticle = ((RSSEntry *)[feeds objectAtIndex:indexPath.row+1]);
    
    ////////////////////////////////////////////////////////////////////////
    //// LOADING IMAGES
    // when it comes to image download and caching, SDWebImage is good and powerful tool
    // especially when you are having a images inside tableview/collectionview cells
    // (since table reuses the cells on scroll)
    // It will cache the images and make the app faster and more responsive
    // here is a primitive implementation without SDWebImage
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentArticle.image]];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    // title
    cell.title.text = currentArticle.title;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // FIXME:
    CGFloat size = [[UIScreen mainScreen] bounds].size.width - 50.0;
    return iPad ? CGSizeMake(size / 3, size / 3 - 35) : CGSizeMake(size / 2, size / 2 - 35);
}

@end
