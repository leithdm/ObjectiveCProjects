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

enum NetworkClientError: ErrorType {
	case ImageData
}

typealias NetworkResult = (AnyObject?, ErrorType?) -> Void
typealias ImageResult = (UIImage?, ErrorType?) -> Void

class NetworkClient: NSObject {
	private var urlSession: NSURLSession
	private var backgroundSession: NSURLSession!
	static let sharedInstance = NetworkClient()
	
	override init() {
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		urlSession = NSURLSession(configuration: configuration)
		super.init()
		

	}
	
	// MARK: service methods
	
	func getURL(url: NSURL, completion: NetworkResult) {
		let request = NSURLRequest(URL: url)
		let task = urlSession.dataTaskWithRequest(request) { [unowned self] (data, response, error) in
			guard let data = data else {
				NSOperationQueue.mainQueue().addOperationWithBlock {
					completion(nil, error)
				}
				return
			}
			self.parseJSON(data, completion: completion)
		}
		task.resume()
	}
	
	func getImage(url: NSURL, completion: ImageResult) -> NSURLSessionDownloadTask  { //return back the task that gets created in this method
		let request = NSURLRequest(URL: url)
		let task = urlSession.downloadTaskWithRequest(request) { (url, response, error) in
			guard let url = url else {
				
				NSOperationQueue.mainQueue().addOperationWithBlock({
					completion(nil, error)
				})
				return
			}
			if let data = NSData(contentsOfURL: url), image = UIImage(data: data) {
				NSOperationQueue.mainQueue().addOperationWithBlock({
					completion(image, nil)
				})
			} else {
				NSOperationQueue.mainQueue().addOperationWithBlock({
					completion(nil, NetworkClientError.ImageData)
				})
			}
			
		}
		task.resume()
		return task
	}
	
	
	
	// MARK: helper methods
	
	private func parseJSON(data: NSData, completion: NetworkResult) {
		do {
			let fixedData = fixedJSONData(data)
			let parseResults = try NSJSONSerialization.JSONObjectWithData(fixedData, options: [])
			if let dictionary = parseResults as? NSDictionary {
				NSOperationQueue.mainQueue().addOperationWithBlock {
					completion(dictionary, nil)
				}
			} else if let array = parseResults as? [NSDictionary] {
				NSOperationQueue.mainQueue().addOperationWithBlock {
					completion(array, nil)
				}
			}
		} catch let parseError {
			NSOperationQueue.mainQueue().addOperationWithBlock {
				completion(nil, parseError)
			}
		}
	}
	
	private func fixedJSONData(data: NSData) -> NSData {
		guard let jsonString = String(data: data, encoding: NSUTF8StringEncoding) else { return data }
		let fixedString = jsonString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
		if let fixedData = fixedString.dataUsingEncoding(NSUTF8StringEncoding) {
			return fixedData
		} else {
			return data
		}
	}
}
