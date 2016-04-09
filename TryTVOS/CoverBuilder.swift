//
//  CoverBuilder.swift
//  TryTVOS
//
//  Created by Ben on 09/04/2016.
//  Copyright © 2016 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class CoverBuilder {

  private lazy var operationQueue: NSOperationQueue = {
    let _queue = NSOperationQueue()
    _queue.maxConcurrentOperationCount = 1
    return _queue
  }()

  private(set) var cover: UIImage?

  // MARK: - Public Methods

  func addImage(image: UIImage, atCorner corner: Grid, completion: (newCover: UIImage) -> Void) {
    operationQueue.addOperation(NSBlockOperation {
      let imageSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)

      var canvas: UIImage!
      if let currentImage = self.cover where currentImage.size == imageSize {
        canvas = currentImage
      } else {
        canvas = UIImage.placeholderImage(withSize: imageSize)
      }

      let cover = canvas.image(byReplacingImage: image, atCorner: corner)
      self.cover = cover

      dispatch_async(dispatch_get_main_queue()) {
        completion(newCover: cover)
      }
    })
  }

  func resetCover() {
    cover = nil
  }

}
