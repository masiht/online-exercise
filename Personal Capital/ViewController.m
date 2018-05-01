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
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //////////////////////////////////////////
    //////////////  TODO list:
    // 1. loading indicator
    // 2. create a network manager class and model object models for rss feeds
    
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:
                  @"https://www.personalcapital.com/blog/feed/?cat=3,891,890,68,284"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];

    parser.delegate = self;
//    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}


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
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if ([element isEqualToString:@"title"]) { [title appendString:string]; }
    else if ([element isEqualToString:@"link"]) { [link appendString:string]; }
    else if ([element isEqualToString:@"description"]) { [description appendString:string]; }
    else if ([element isEqualToString:@"pubDate"]) { [date appendString:string]; }
    else if ([element isEqualToString:@"media:content"]) { [image appendString:string]; }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {

//        [item setObject:title       forKey:@"title"];
//        [item setObject:link        forKey:@"link"];
//        [item setObject:description forKey:@"description"];
//        [item setObject:date        forKey:@"date"];
//        [item setObject:image       forKey:@"image"];
//        [feeds addObject:[item copy]];
        
        [feeds addObject:[[RSSEntry alloc] init:title description:description imageUrl:image articleUrl:link articleDate:date]];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
//    [self.tableView reloadData];
    NSLog(@"done!!!!!!!!!!!!");
    NSLog(@"%lu", (unsigned long)feeds.count);
    
    for (RSSEntry *feed in feeds) {
        NSLog(@"%@", feed.title);
    }
    
}


@end
