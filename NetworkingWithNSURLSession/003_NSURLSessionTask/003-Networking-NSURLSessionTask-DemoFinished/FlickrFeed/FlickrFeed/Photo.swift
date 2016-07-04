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

class Photo: NSObject {
  var itemId: String
  var photoUrl: NSURL
  var favorite = false

  static let itemIdKey = "itemId"
  static let photoUrlKey = "photoUrl"
  static let favoriteKey = "favorite"

  init(dictionary values: NSDictionary) {
    guard let link = values["link"] as? String else {
      fatalError("Photo item could not be created: " + values.description)
    }
    itemId = link

    guard let media = values["media"] as? NSDictionary,
      urlString = media["m"] as? String, url = NSURL(string: urlString) else {
      fatalError("Photo item could not be created: " + values.description)
    }
    photoUrl = url
  }

  // MARK: NSCoder methods

  @objc required init?(coder aDecoder: NSCoder) {
    guard let decodedItemId = aDecoder.decodeObjectForKey(Photo.itemIdKey) as? String,
      let decodedPhotoUrl = aDecoder.decodeObjectForKey(Photo.photoUrlKey) as? NSURL else {
        fatalError("Photo item could not be created")
    }
    itemId = decodedItemId
    photoUrl = decodedPhotoUrl
    favorite = aDecoder.decodeBoolForKey(Photo.favoriteKey)
  }

  @objc func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(itemId, forKey: Photo.itemIdKey)
    aCoder.encodeObject(photoUrl, forKey: Photo.photoUrlKey)
    aCoder.encodeBool(favorite, forKey: Photo.favoriteKey)
  }
}

// MARK: Equatable

func == (lhs: Photo, rhs: Photo) -> Bool {
  return lhs.itemId == rhs.itemId
}