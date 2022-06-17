//
//  MovieViewController.m
//  Flixter
//
//  Created by Emily Ito Okabe on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //[self.activityIndicator startAnimating];
    [self fetchMovies];
    //[self.activityIndicator stopAnimating];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    //[self.tableView addSubview:self.refreshControl];
}

- (void)fetchMovies {
    
    [self.activityIndicator startAnimating];
    
    UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
    }];
    
    [networkAlert addAction:tryAgainAction];
    
    // 1. Create URL: url for API
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    
    // 2. Create Request: takes url and generates request object
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
   
    // 3. Creat Session
    // queue identifies which
    // mainQueue: main thread
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    
    // 4. Create our session task
    // pass the request and session
    // completion handler: code to execute when we get a response
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               [self presentViewController:networkAlert animated:YES completion:^{
                   // optional code for what happens after the alert controller has finished presenting
               }];
           }
           else {
               // response (movie database) handled here
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.

               // TODO: Get the array of movies
               
               self.movies = dataDictionary[@"results"];
               
               // TODO: Store the movies in a property to use elsewhere
               
               for (NSDictionary *mov in self.movies) {
                   NSLog(@"%@", mov[@"title"]);
               }
               
               [self.activityIndicator stopAnimating];
               // TODO: Reload your table view data
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
    }];
    
    // 5. Session task has been created, now resume
    [task resume];
    
    //[self.activityIndicator stopAnimating];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger) section {
    return self.movies.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    //cell.textLabel.text = movie[@"title"];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // 1 Get indexpath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    
    // 2 Get movie dictionary
    NSDictionary *dataToPass = self.movies[indexPath.row]; // results -> movies
    
    // 3 Get reference to destination controller
    DetailsViewController *detailsVC = [segue destinationViewController];
    
    // 4 Pass the local dictionary to the view controller property
    detailsVC.movieInfo = dataToPass;
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/*
 
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 */


@end
