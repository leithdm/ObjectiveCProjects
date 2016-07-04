import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: ### NSURLSession
//: `NSURLSession` is used to configure the network environment and create networking tasks.
let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
configuration.allowsCellularAccess = false
configuration.URLCache?.diskCapacity
configuration.URLCache?.memoryCapacity
let smallCache = NSURLCache(memoryCapacity: 512000, diskCapacity: 2000000, diskPath: nil)
configuration.URLCache = smallCache
configuration.URLCache?.diskCapacity
configuration.URLCache?.memoryCapacity
let session = NSURLSession(configuration: configuration)

//: Use `NSURLSession` to create a task.
//:
//: Info on all Flickr public feeds can be found on their [services page](https://www.flickr.com/services/feeds/).
//: Info on this particular feed can be found [here](https://www.flickr.com/services/feeds/docs/photos_public/).
let url = NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
let task = session.dataTaskWithURL(url) {
  (data, response, error) in
  guard let data = data else { print(error); return }

  let result = NSString(data: data, encoding: NSUTF8StringEncoding)
  XCPlaygroundPage.currentPage.finishExecution()
}
task.resume()
