//
//  ViewController.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 4/30/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "ViewController.h"
#import "RSSEntry.h"

@interface ViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    
    // parser temprary variables
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *image;
    NSMutableString *description;
    NSMutableString *date;
    NSMutableString *link;
    NSString *element;
    
    // FIXME: move it to where it should be
    BOOL iPad;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Research & Insights";
    // ipad check:
    iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    
    // starting collectionview
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(300, 15, 10, 15);
    layout.minimumLineSpacing = 10;
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];

//     https://stackoverflow.com/questions/21731318/add-a-simple-uiview-as-header-of-uicollectionview/21732497
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _collectionView.frame.size.width, 120)];
    
//    [_collectionView registerClass:[Article class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.view addSubview:_collectionView];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"⟲" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //////////////////////////////
    /////////////////////// Parser
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:
                  @"https://www.personalcapital.com/blog/feed/?cat=3,891,890,68,284"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
  
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

-(void)rightBtnClick{
    // code for right Button
    NSLog(@"222222");
    
}

#pragma mark -
#pragma mark collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return feeds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    // SDWebImage & cache heneke
    
    NSString *url = ((RSSEntry *)[feeds objectAtIndex:indexPath.row]).image;
    NSURL *imageURL = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    // TODO: width and height have to come from the rss
    CGFloat imageHeight = (cell.bounds.size.width * 300)/780;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, imageHeight)];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    // title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imageHeight, cell.bounds.size.width - 10, 50)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [titleLabel.font fontWithSize:12];
    titleLabel.text = ((RSSEntry *)[feeds objectAtIndex:indexPath.row]).title;
    titleLabel.numberOfLines = 2;
    [cell.contentView addSubview:titleLabel];
    
    // draw border
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // FIXME:
    CGFloat size = [[UIScreen mainScreen] bounds].size.width - 50.0;
    return iPad ? CGSizeMake(size / 3, size / 3 - 35) : CGSizeMake(size / 2, size / 2 - 35);
}

//-(void)prepareForReuse {
//    [super prepareForReuse];
//}


#pragma mark -
#pragma mark RSS Parser methods and properties
//////////////////////////////////////////
//////////////  TODO list:
// 1. loading indicator
// 2. create a network manager class and model object models for rss feeds

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    if ([element isEqualToString:@"item"]) {
        item        = [[NSMutableDictionary alloc] init];
        title       = [[NSMutableString alloc] init];
        link        = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        date        = [[NSMutableString alloc] init];
        image       = [[NSMutableString alloc] init];
    }
    
    if ([element isEqualToString:@"media:content"]) {
        image = [attributeDict objectForKey:@"url"];
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if ([element isEqualToString:@"title"]) { [title appendString:string]; }
    else if ([element isEqualToString:@"link"]) { [link appendString:string]; }
    else if ([element isEqualToString:@"description"]) { [description appendString:string]; }
    else if ([element isEqualToString:@"pubDate"]) { [date appendString:string]; }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [feeds addObject:[[RSSEntry alloc] init:title description:description imageUrl:image articleUrl:link articleDate:date]];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
//    [self.tableView reloadData];
    NSLog(@"done!!!!!!!!!!!!");
    NSLog(@"%lu", (unsigned long)feeds.count);
    
    for (RSSEntry *feed in feeds) {
        NSLog(@"%@", feed.image);
    }
    
}


@end
