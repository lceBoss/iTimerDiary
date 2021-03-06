//
//  LCEAlbumViewController.m
//  iTimerDiary
//
//  Created by tarena on 16/1/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LCEAlbumViewController.h"
#import "RACollectionViewCell.h"


@interface LCEAlbumViewController ()

@property (nonatomic, strong) NSString *documentsPath;

@property (nonatomic, strong) NSArray *diaryArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photosArray;



@end

@implementation LCEAlbumViewController
- (NSArray *)diaryArray {
    if (!_diaryArray) {
        _diaryArray = [NSArray array];
    }
    return _diaryArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *diaryPath = [self.documentsPath stringByAppendingPathComponent:@"diary.plist"];
    
    self.diaryArray = [[NSArray alloc] initWithContentsOfFile:diaryPath];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self setupPhotosArray];
    
    
    
    
}

- (void)setupPhotosArray
{
    [_photosArray removeAllObjects];
    _photosArray = nil;
    _photosArray = [NSMutableArray array];
//    for (NSInteger i = 1; i <= 20; i++) {
//        NSString *photoName = [NSString stringWithFormat:@"%ld.jpg",i];
//        UIImage *photo = [UIImage imageNamed:photoName];
//        
//        
//
//       
//        
//        [_photosArray addObject:photo];
//    }
    
    
    for (int i = 0; i < self.diaryArray.count; i++) {
        
        NSDictionary *diaryDic = self.diaryArray[i];
        
        NSArray *photos = diaryDic[@"photos"];
        
        
        for (int j = 0; j < photos.count; j++) {
            
            UIImage *photo = [UIImage imageWithContentsOfFile:[self.documentsPath stringByAppendingPathComponent:photos[j]]];
            
            [_photosArray addObject:photo];
        }

    }
    
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _photosArray.count;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage *image = [_photosArray objectAtIndex:fromIndexPath.item];
    [_photosArray removeObjectAtIndex:fromIndexPath.item];
    [_photosArray insertObject:image atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    RACollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.imageView removeFromSuperview];
    cell.imageView.frame = cell.bounds;
    cell.imageView.image = _photosArray[indexPath.item];
    [cell.contentView addSubview:cell.imageView];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_photosArray.count == 1) {
        return;
    }
    [self.collectionView performBatchUpdates:^{
//        [_photosArray removeObjectAtIndex:indexPath.item];
//        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

- (IBAction)refresh:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
