//
//  GridViewController.m
//  Flixter
//
//  Created by Emily Ito Okabe on 6/17/22.
//

#import "GridViewController.h"
#import "CollectionViewGridCell.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionGrid;
@property (nonatomic, strong) NSArray *movies;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionGrid.dataSource = self;
    self.collectionGrid.delegate = self;
    
    [self fetchMovies];
}

- (void)fetchMovies {
    
    //[self.activityIndicator startAnimating];
    
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
               
               //[self.activityIndicator stopAnimating];
               // TODO: Reload your table view data
               [self.collectionGrid reloadData];
           }
        //[self.refreshControl endRefreshing];
    }];
    
    // 5. Session task has been created, now resume
    [task resume];
    
    //[self.activityIndicator stopAnimating];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionViewGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSLog(@"%@", fullPosterURLString);
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(98, 156);
    return size;
}


@end
