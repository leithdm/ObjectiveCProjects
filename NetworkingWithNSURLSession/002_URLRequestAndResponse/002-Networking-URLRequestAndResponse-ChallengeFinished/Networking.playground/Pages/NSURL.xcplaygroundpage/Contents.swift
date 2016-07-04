import Foundation
import XCPlayground

//: This class is just for the purpose of letting Charles be man-in-the-middle for SSL requests to Flickr
class SSLAuthHandler: NSObject, NSURLSessionDelegate {
  func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.host == "api.flickr.com" {
      let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
      completionHandler(.UseCredential, credential)
    } else {
      completionHandler(.PerformDefaultHandling, nil)
    }
  }
}
//: ### NSURL
//: Creating an NSURL from a string
let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
let url = NSURL(string: urlString)
let invalidUrl = NSURL(string: "this isn't a URL")
//: NSURL parses the URL into parts
url?.absoluteString
url?.scheme
url?.host
url?.path
url?.query
url?.baseURL
//: Creating an NSURL from pieces
let baseURL = NSURL(string: "https://api.flickr.com")
//url?.baseURL = baseURL
let relativeURL = NSURL(string: "services/feeds/photos_public.gne", relativeToURL: baseURL)
relativeURL?.absoluteString
relativeURL?.scheme
relativeURL?.host
relativeURL?.path
relativeURL?.query
relativeURL?.baseURL
//relativeURL?.query = "format=json&nojsoncallback=1"

//: ### NSURLComponents
let components = NSURLComponents(URL: relativeURL!, resolvingAgainstBaseURL: true)
components?.string
components?.URL
components?.scheme
components?.host
components?.path
components?.query = "format=json"
components?.URL
components?.queryItems?.append(NSURLQueryItem(name: "nojsoncallback", value: "1"))
components?.URL

//: ### NSURLRequest
let request = NSMutableURLRequest(URL: components!.URL!)
request.allowsCellularAccess = false
request.HTTPMethod = "POST"
request.allHTTPHeaderFields
request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
request.allHTTPHeaderFields
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.allHTTPHeaderFields
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.allHTTPHeaderFields

//: ### NSURLResponse
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
let delegate = SSLAuthHandler()
let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: delegate, delegateQueue: nil)
let task = session.dataTaskWithURL(url!) {
  (data, response, error) in
  response
  (response as? NSHTTPURLResponse)?.statusCode
  let headers = (response as? NSHTTPURLResponse)?.allHeaderFields
  error
  defer {
    XCPlaygroundPage.currentPage.finishExecution()
  }
  guard let data = data else { return }

  let result = NSString(data: data, encoding: NSUTF8StringEncoding)
}
task.resume()

//: Download Charles [here](http://www.charlesproxy.com/latest-release/download.do).
//: If you're using Charles in a playground, you don't have to worry about App Transport Security (ATS), but if you're using it in an app, you'll have to add exceptions to your Info.plist. Read more about NSAppTransportSecurity [here](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33).
//:
//: [Previous Page](@previous) | [Next Page](@next)
