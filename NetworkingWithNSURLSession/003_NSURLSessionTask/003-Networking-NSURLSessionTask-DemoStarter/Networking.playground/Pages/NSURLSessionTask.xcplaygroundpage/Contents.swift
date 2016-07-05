import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*
let session = NSURLSession.sharedSession()
let urlString = "https://www.example.com"
let url = NSURL(string: urlString)!
let request = NSURLRequest(URL: url)

//: ### NSURLSessionDataTask
let dataTask = session.dataTaskWithRequest(request) {
  data, response, error in
//  defer {
//    XCPlaygroundPage.currentPage.finishExecution()
//  }
  response
  error
  guard let data = data else { return }

  let result = NSString(data: data, encoding: NSUTF8StringEncoding)
}
dataTask.resume()
*/

//: ### NSURLSessionUploadTask

/*
let queue = NSOperationQueue()
queue.qualityOfService = .UserInitiated
let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
let sessionThree = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
*/

let session = NSURLSession.sharedSession()
let urlString = "https://www.example.com"
let url = NSURL(string: urlString)!
let requestTwo = NSMutableURLRequest(URL: url)
requestTwo.HTTPMethod = "POST"
requestTwo.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
let components = NSURLComponents()
components.query = "param=value&otherparm=another value"
let body = components.percentEncodedQuery! //this is a  nice way of dealing with the space

let uploadTask = session.uploadTaskWithRequest(requestTwo, fromData: body.dataUsingEncoding(NSUTF8StringEncoding)) { (data, response, error) in
	  defer {
//	    XCPlaygroundPage.currentPage.finishExecution()
	  }

	response
	error
	
	guard let data = data else { return }
	let result = NSString(data: data, encoding: NSUTF8StringEncoding)
}

uploadTask.resume()

//: ### NSURLSessionDownloadTask


let downloadTask = session.downloadTaskWithURL(url) { (fileUrl, response, error) in
	defer {
		XCPlaygroundPage.currentPage.finishExecution()
	}
	response
	error
	
	guard let url = fileUrl else { return }
	url
	let result = try? NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
}

downloadTask.resume()

//: [Previous Page](@previous) | [Next Page](@next)
