import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let session = NSURLSession.sharedSession()
let urlString = "https://www.example.com"
let url = NSURL(string: urlString)!

//: ### NSURLSessionDataTask
let dataTask = session.dataTaskWithURL(url) {
  data, response, error in
  defer {
    XCPlaygroundPage.currentPage.finishExecution()
  }
  response
  error
  guard let data = data else { return }

  let result = NSString(data: data, encoding: NSUTF8StringEncoding)
}
dataTask.resume()

//: ### NSURLSessionUploadTask

//: ### NSURLSessionDownloadTask


//: [Previous Page](@previous) | [Next Page](@next)
