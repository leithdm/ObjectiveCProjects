import UIKit
import XCPlayground

//: # NSOperationQueue
//: NSOperationQueue is responsible for scheduling and running a set of operations, somewhere in the background. 
let printerQueue = NSOperationQueue()
printerQueue.maxConcurrentOperationCount = 2
startClock()
printerQueue.addOperationWithBlock({ sleep(5); print("Hello")})
printerQueue.addOperationWithBlock({ sleep(5); print("there")})
printerQueue.addOperationWithBlock({ sleep(5); print("you shithead")})
stopClock()

startClock()
printerQueue.waitUntilAllOperationsAreFinished()
stopClock()
//: To prevent the playground from killing background tasks when the main thread has completed, need to specify indefinite execution

//: ## Adding NSOperations to queues
let images = ["city", "dark_road", "train_day", "train_dusk", "train_night"].map { UIImage(named: "\($0).jpg") }
var filteredImages = [UIImage]()

//: Create the queue with the default constructor
let myNSOperationQueue = NSOperationQueue()

//: Create a filter operations for each of the iamges, adding a completionBlock
for image in images {
	let filterOperation = TiltShiftOperation()
	filterOperation.inputImage = image
	filterOperation.completionBlock = {
		guard let output = filterOperation.outputImage else { return }
		filteredImages.append(output)
	}
	myNSOperationQueue.addOperation(filterOperation)
}

//: Need to wait for the queue to finish before checking the results
myNSOperationQueue.waitUntilAllOperationsAreFinished()

//: Inspect the filtered images
filteredImages

XCPlaygroundPage.currentPage.needsIndefiniteExecution









