//
//  LCECameraViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCECameraViewController.h"
#import "ZYQAssetPickerController.h"


@interface LCECameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZYQAssetPickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@end

@implementation LCECameraViewController

- (NSMutableArray *)cameraMutableArray {
    if (!_cameraMutableArray) {
        _cameraMutableArray= [NSMutableArray array];
    }
    return _cameraMutableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.cameraCollectionview.delegate = self;
    
    self.cameraCollectionview.dataSource = self;
    
    self.cameraCollectionview.backgroundColor = [UIColor clearColor];
    
    [self.cameraCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CamaelaCollectionCell"];
    
    if (self.cameraMutableArray.count == 0) {
        self.saveButton.enabled = NO;
    }
    
}
/**
 *  点击叉号
 *
 *  不保存直接退出
 */
- (IBAction)clickCancelBtn:(id)sender {
    
    self.cameraMutableArray = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  点击对号
 *
 *  @param sender 保存数据
 */
- (IBAction)clickSaveBtn:(id)sender {
    
    [self.delegate cameraVC:self setWriteDiaryCarmera:self.cameraMutableArray];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//从相册选择图片
- (IBAction)clickFromPhotoAlbum:(id)sender {
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    
    picker.maximumNumberOfSelection = 5 - self.cameraMutableArray.count ;
    
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    self.cameraCollectionview.hidden = NO;
    
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];

    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
//使用照相机拍摄
- (IBAction)clickUseCamera:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [self clickFromPhotoAlbum:sender];
        
    }else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        
      
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        self.cameraCollectionview.hidden = NO;
        

    }
    


}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cameraMutableArray.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView
                                  
    dequeueReusableCellWithReuseIdentifier:@"CamaelaCollectionCell" forIndexPath:indexPath];
    
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:self.cameraMutableArray[indexPath.row]];
    
    self.saveButton.enabled = YES;
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     
 return YES;
     
 }


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.cameraMutableArray removeObject:self.cameraMutableArray[indexPath.row]];
    
    [self.cameraCollectionview reloadData];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    for (int i = 0; i < assets.count; i++) {
        
        ALAsset *asset = assets[i];
        
        CGImageRef image = [asset thumbnail];
        
        UIImage *newImage = [UIImage imageWithCGImage:image];
        
        [self.cameraMutableArray addObject:newImage];
    
        
        
        if (self.cameraMutableArray.count > 5) {
            return;
        }
        }
    
    [self.cameraCollectionview reloadData];
    
  }





#pragma mark -- UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [[UIImage alloc]init];
    
    image =  [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    //生成缩略图
    UIImage *newimage = [self thumbnaiWithImage:image size:CGSizeMake(70,70)];
    
    [self.cameraMutableArray addObject:newimage];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    [self.cameraCollectionview reloadData];
}
//缩略图
-(UIImage *) thumbnaiWithImage:(UIImage *)image size:(CGSize)size{
    UIImage *newimage = nil;
    if (nil == image) {
        newimage = nil;
    }else{
        UIGraphicsBeginImageContext(size);
        
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
