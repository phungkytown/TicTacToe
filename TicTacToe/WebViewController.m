//
//  WebViewController.m
//  TicTacToe
//
//  Created by Hai Phung on 10/3/14.
//  Copyright (c) 2014 Hai Phung. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldVerticalConstraint;
@property (nonatomic) CGPoint lastContentOffset;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the scrollView delegate of the webView
    self.webView.scrollView.delegate = self;

    // Change the state of the back and forward buttons
    [self changeNavigationButtonsState];

    // Load a default page
    [self loadPage:@"http://en.wikipedia.org/wiki/Tic-tac-toe"];

    // Show the clear button on the text field while its being edited.
    self.urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self changeNavigationButtonsState];

    // Update the url text field with the current url
    self.urlTextField.text = self.webView.request.URL.absoluteString;

    // Update the navbar title with the current page title
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Dismiss the keyboard.
    [textField resignFirstResponder];

    [self loadPage:textField.text];

    return YES;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.lastContentOffset.y) {
        [self moveTextFieldToPosition:-30.0 alpha:0.0];
    } else {
        [self moveTextFieldToPosition:8.0 alpha:1.0];
    }
}

#pragma mark - Helper Methods

- (void)loadPage:(NSString *)urlString {
    NSURL *url;

    if ([urlString hasPrefix:@"http://"]) {
        url = [NSURL URLWithString:urlString];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]];
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)changeNavigationButtonsState {
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

- (void)moveTextFieldToPosition:(CGFloat)y alpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.3 animations:^{
        self.urlTextField.alpha = alpha;
        self.textFieldVerticalConstraint.constant = y;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions

- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}

- (IBAction)onComingSoonButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Coming soon!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onDoneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
