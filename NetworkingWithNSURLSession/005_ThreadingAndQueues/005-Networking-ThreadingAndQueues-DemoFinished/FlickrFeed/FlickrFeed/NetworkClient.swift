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
typealias ProgressBlock = (Float) -> Void

class NetworkClient: NSObject {
  private var urlSession: NSURLSession
  private var backgroundSession: NSURLSession!
  private var completionHandlers = [NSURL: ImageResult]()
  private var progressHandlers = [NSURL: ProgressBlock]()
  static let sharedInstance = NetworkClient()

  override init() {
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    urlSession = NSURLSession(configuration: configuration)
    super.init()
    let backgroundConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.razeware.flickrfeed")
    backgroundSession = NSURLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: nil)
  }

  private var networkActivityCount: Int = 0 {
    didSet {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = (networkActivityCount > 0)
    }
  }

  // MARK: service methods

  func getURL(url: NSURL, completion: NetworkResult) {
    let request = NSURLRequest(URL: url)
    networkActivityCount += 1
    let task = urlSession.dataTaskWithRequest(request) { [unowned self] (data, response, error) in
      guard let data = data else {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.networkActivityCount -= 1
          completion(nil, error)
        }
        return
      }
      self.parseJSON(data, completion: completion)
    }
    task.resume()
  }

  func getImage(url: NSURL, completion: ImageResult) -> NSURLSessionDownloadTask {
    let request = NSURLRequest(URL: url)
    networkActivityCount += 1
    let task = urlSession.downloadTaskWithRequest(request) {
      (fileUrl, response, error) in
      guard let fileUrl = fileUrl else {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.networkActivityCount -= 1
          completion(nil, error)
        }
        return
      }
      // You must move the file or open it for reading before this closure returns or it will be deleted
      if let data = NSData(contentsOfURL: fileUrl), image = UIImage(data: data) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.networkActivityCount -= 1
          completion(image, nil)
        }
      } else {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.networkActivityCount -= 1
          completion(nil, NetworkClientError.ImageData)
        }
      }
    }
    task.resume()
    return task
  }

  func getImageInBackground(url: NSURL, downloadProgressBlock: ProgressBlock?, completion: ImageResult?) -> NSURLSessionDownloadTask {
    completionHandlers[url] = completion
    progressHandlers[url] = downloadProgressBlock
    let request = NSURLRequest(URL: url)
    networkActivityCount += 1
    let task = backgroundSession.downloadTaskWithRequest(request)
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
          self.networkActivityCount -= 1
          completion(dictionary, nil)
        }
      } else if let array = parseResults as? [NSDictionary] {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.networkActivityCount -= 1
          completion(array, nil)
        }
      }
    } catch let parseError {
      NSOperationQueue.mainQueue().addOperationWithBlock {
        self.networkActivityCount -= 1
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

  private func completeProgressForURL(url: NSURL) {
    if let progress = progressHandlers[url] {
      progressHandlers[url] = nil
      NSOperationQueue.mainQueue().addOperationWithBlock {
        progress(1)
      }
    }
  }
}

extension NetworkClient: NSURLSessionDelegate, NSURLSessionDownloadDelegate {
  func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    if let error = error, url = task.originalRequest?.URL, completion = completionHandlers[url] {
      completeProgressForURL(url)
      completionHandlers[url] = nil
      NSOperationQueue.mainQueue().addOperationWithBlock {
        self.networkActivityCount -= 1
        completion(nil, error)
      }
    }
  }

  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    if let url = downloadTask.originalRequest?.URL, progress = progressHandlers[url] {
      let percentDone = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
      NSOperationQueue.mainQueue().addOperationWithBlock {
        progress(percentDone)
      }
    }
  }

  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
    // You must move the file or open it for reading before this closure returns or it will be deleted
    if let data = NSData(contentsOfURL: location), image = UIImage(data: data), request = downloadTask.originalRequest, response = downloadTask.response {
      let cachedResponse = NSCachedURLResponse(response: response, data: data)
      self.urlSession.configuration.URLCache?.storeCachedResponse(cachedResponse, forRequest: request)
      if let url = downloadTask.originalRequest?.URL, completion = completionHandlers[url] {
        completeProgressForURL(url)
        completionHandlers[url] = nil
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.networkActivityCount -= 1
          completion(image, nil)
        }
      }
    } else {
      if let url = downloadTask.originalRequest?.URL, completion = completionHandlers[url] {
        completeProgressForURL(url)
        completionHandlers[url] = nil
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.networkActivityCount -= 1
          completion(nil, NetworkClientError.ImageData)
        }
      }
    }
  }

  func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, completionHandler = appDelegate.backgroundSessionCompletionHandler {
      appDelegate.backgroundSessionCompletionHandler = nil
      completionHandler()
    }
  }
}
