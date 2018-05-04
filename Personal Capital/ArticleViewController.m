//
//  ArticleViewController.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 5/4/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    webview.delegate = self;
    // apending display mobile query param to original url
    NSString *urlString = [NSString stringWithFormat:@"%@?displayMobileNavigation=0",
                           [self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    // encoding url
    NSString *encodedUrlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview setScalesPageToFit:YES];
    [webview loadRequest:request];
    [self.view addSubview:webview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error : %@",error);
}



@end
