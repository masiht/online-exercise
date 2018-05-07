//
//  ViewController.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 4/30/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "RootViewController.h"
#import "RSSParser.h"
#import "RSSEntry.h"
#import "Cell.h"
#import "HeaderView.h"
#import "ArticleViewController.h"

@interface RootViewController () {
    
    NSArray *feeds;
    NSMutableArray *imagesData;
    UIActivityIndicatorView *spinner;
    RSSParser *rssParser;
    BOOL iPad;
    HeaderView *headerView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // nav bar
    self.title = @"Research & Insights";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFeed)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
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
    
    // header view
    headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, _collectionView.frame.size.width, headerHeight - 50)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnHeader:)];
    [headerView addGestureRecognizer:tap];
    [_collectionView addSubview:headerView];
    
    // Masonry is a great tool for setting constraints programmatically
    // It is very easy to use and reduce lots of complexities
    //////////////////////////////////////////////////////////////
    // Auto Layout Constrains
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.view setNeedsLayout];
}

/**
 loads the content after receiving notification indicating the parser did parsed the document
 @param notification contains array of articles
 */
-(void)loadFeeds:(NSNotification *)notification {
    
    feeds = [notification object];
    imagesData = [[NSMutableArray alloc] init];
    for (RSSEntry *feed in feeds) {
        [imagesData addObject: [NSData dataWithContentsOfURL:[NSURL URLWithString:feed.image]]];
    }
    // back to main thread to update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner stopAnimating];
        [headerView setRSSFeed:((RSSEntry *)[feeds objectAtIndex:0])];
        [_collectionView reloadData];
        _collectionView.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    });
}

/**
 referesh handler
 */
-(void)refreshFeed {
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _collectionView.userInteractionEnabled = NO;
    [rssParser startParsing];
}

- (void)handleTapOnHeader:(UITapGestureRecognizer *)recognizer {
    [self viewArticleInWebview:((RSSEntry *)[feeds objectAtIndex:0])];
}

/**
 a helper method that navigates to webview and sends url to the webview
 @param entry webview shows given rss entry
 */
- (void)viewArticleInWebview:(RSSEntry *)entry {
    ArticleViewController *articleViewController = [[ArticleViewController alloc] initWithNibName:nil bundle:nil];
    articleViewController.title = entry.title;
    articleViewController.url = entry.link;
    [self.navigationController pushViewController:articleViewController animated:YES];
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
    cell.imageView.image = [UIImage imageWithData:[imagesData objectAtIndex:indexPath.row+1]];
    
    // title
    cell.title.text = currentArticle.title;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RSSEntry *entry = ((RSSEntry *)[feeds objectAtIndex:indexPath.row+1]);
    [self viewArticleInWebview:entry];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat widthSize = [[UIScreen mainScreen] bounds].size.width - 100.0;
    UIInterfaceOrientation orientationOnLunch = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientationOnLunch)) {
        return iPad ? CGSizeMake(widthSize / 3, widthSize / 3 - 35) : CGSizeMake(widthSize / 2, widthSize / 2 - 35);
    } else {
        return iPad ? CGSizeMake(widthSize / 4, widthSize / 4 - 35) : CGSizeMake(widthSize / 3, widthSize / 3 - 35);
    }
}

@end
