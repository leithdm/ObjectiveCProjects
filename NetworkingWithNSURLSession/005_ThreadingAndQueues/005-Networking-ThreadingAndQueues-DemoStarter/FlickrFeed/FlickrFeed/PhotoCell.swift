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

class PhotoCell: UICollectionViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var progressView: UIProgressView!
  
  var imageTask: NSURLSessionDownloadTask?

  var photo: Photo? {
    didSet {
      imageTask?.cancel()
      guard let photoUrl = photo?.photoUrl else {
        self.photoImageView.image = UIImage(named: "Downloading")
        return
      }
      imageTask = NetworkClient.sharedInstance.getImageInBackground(photoUrl,
        downloadProgressBlock: { [weak self] (progress) in
          if (progress > 0 && progress < 1) {
            self?.progressView.progress = progress
            self?.progressView.hidden = false
          } else {
            self?.progressView.hidden = true
          }
        }, completion: { [weak self] (image, error) in
          guard error == nil else {
            self?.photoImageView.image = UIImage(named: "Broken")
            return
          }
          self?.photoImageView.image = image
        })
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    photo = nil
  }
}