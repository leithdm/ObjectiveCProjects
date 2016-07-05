import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let session = NSURLSession.sharedSession()
let urlString = "https://www.example.com"
let url = NSURL(string: urlString)!

//: ### NSURLSessionDataTask
let dataTask = session.dataTaskWithURL(url) {
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

//: ### NSURLSessionUploadTask

let request = NSMutableURLRequest(URL: url)
request.HTTPMethod = "POST"
request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
let components = NSURLComponents()
components.query = "param=value&otherparm=another value"
let body = components.percentEncodedQuery! //this is a  nice way of dealing with the space

let uploadTask = session.uploadTaskWithRequest(request, fromData: body.dataUsingEncoding(NSUTF8StringEncoding)) { (data, response, error) in
//	  defer {
//	    XCPlaygroundPage.currentPage.finishExecution()
//	  }

	response
	error
	
	guard let data = data else { return }
	let result = NSString(data: data, encoding: NSUTF8StringEncoding)
}

uploadTask.resume()

//: ### NSURLSessionDownloadTask


let downloadTask = session.downloadTaskWithURL(url) { (url, response, error) in
	defer {
		XCPlaygroundPage.currentPage.finishExecution()
	}
	response
	error
	
	guard let url = url else { return }
	url
	let result = try? NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
}

downloadTask.resume()

//: [Previous Page](@previous) | [Next Page](@next)
