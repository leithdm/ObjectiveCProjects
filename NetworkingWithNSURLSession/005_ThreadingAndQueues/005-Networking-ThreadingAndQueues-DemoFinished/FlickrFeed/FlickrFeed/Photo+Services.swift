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

import Foundation

enum PhotoServiceError: String, ErrorType {
  case NotImplemented = "This feature has not been implemented yet"
  case URLParsing = "Sorry, there was an error getting the photos"
  case JSONStructure = "Sorry, the photo service returned something different than expected"
}

typealias PhotosResult = ([Photo]?, ErrorType?) -> Void

extension Photo {
  class func getAllFeedPhotos(completion: PhotosResult) {
    guard let url = NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1") else {
      completion(nil, PhotoServiceError.URLParsing)
      return
    }

    NetworkClient.sharedInstance.getURL(url) { (result, error) in
      guard error == nil else {
        completion(nil, error)
        return
      }
      if let dictionary = result as? NSDictionary, items = dictionary["items"] as? [NSDictionary] {
        var photos = [Photo]()
        for item in items {
          photos.append(Photo(dictionary: item))
        }
        completion(photos, nil)
      } else {
        completion(nil, PhotoServiceError.JSONStructure)
      }
    }
  }
}