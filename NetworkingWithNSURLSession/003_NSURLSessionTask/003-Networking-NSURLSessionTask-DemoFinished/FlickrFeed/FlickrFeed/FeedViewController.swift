/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class FeedViewController: UICollectionViewController {
  var photos: [Photo]?
  var currentMessage = "Loading photos..."
  let cellIdentifier = "photoCell"
  let messageCellIdentifier = "messageCell"

  override func viewDidLoad() {
    super.viewDidLoad()

    Photo.getAllFeedPhotos { [weak self] (photos, error) in
      guard error == nil else {
        if let error = error as? PhotoServiceError {
          self?.currentMessage = error.rawValue
        } else if let error = error as? NSError {
          self?.currentMessage = error.localizedDescription
        } else {
          self?.currentMessage = "Sorry, there was an error."
        }
        self?.photos = nil
        self?.collectionView?.reloadData()
        return
      }
      self?.photos = photos
      self?.collectionView?.reloadData()
    }
  }

  // MARK: - UICollectionView delegate/data source

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let photos = photos else { return 1 }
    return photos.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell: UICollectionViewCell
    if let photos = photos where photos.count > 0 {
      let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PhotoCell
      photoCell.photo = photos[indexPath.item]
      cell = photoCell
    } else {
      let messageCell = collectionView.dequeueReusableCellWithReuseIdentifier(messageCellIdentifier, forIndexPath: indexPath) as! MessageCell
      messageCell.messageLabel.text = currentMessage
      cell = messageCell
    }
    return cell
  }

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    guard let selectedPhoto = photos?[indexPath.item] else { return }
//    let manager = FavoriteListManager.sharedInstance
//    manager.toggleFavorite(selectedPhoto)
//    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCell
//    cell.configureStarImage()
  }
}
