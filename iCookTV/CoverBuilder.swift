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

  static let DidCreateCoverNotification = "CoverBuilderDidCreateCoverNotification"
  static let NotificationUserInfoCoverKey = "CoverBuilderNotificationUserInfoCoverKey"

  private lazy var operationQueue: NSOperationQueue = {
    let _queue = NSOperationQueue()
    _queue.maxConcurrentOperationCount = 1
    return _queue
  }()

  private(set) var cover: UIImage?

  private static let imageCache = NSCache()

  private var filledGrids = Set<Grid>()

  // MARK: - Private Methods

  private func cacheImage(image: UIImage, forKey key: String) {
    self.dynamicType.imageCache.setObject(image, forKey: key)

    NSNotificationCenter.defaultCenter().postNotificationName(
      self.dynamicType.DidCreateCoverNotification,
      object: self,
      userInfo: [self.dynamicType.NotificationUserInfoCoverKey: image]
    )
  }

  // MARK: - Public Methods

  func addImage(image: UIImage, atCorner corner: Grid, categoryID id: String? = nil, completion: (newCover: UIImage) -> Void) {
    operationQueue.addOperation(NSBlockOperation { [weak self] in
      let imageSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)

      var canvas: UIImage!
      if let currentImage = self?.cover where currentImage.size == imageSize {
        canvas = currentImage
      } else {
        canvas = UIImage.placeholderImage(withSize: imageSize)
      }

      let cover = canvas.image(byReplacingImage: image, atCorner: corner)
      self?.cover = cover
      self?.filledGrids.insert(corner)

      if let key = id where self?.filledGrids.count == Grid.numberOfGrids {
        self?.cacheImage(cover, forKey: key)
      }

      dispatch_sync(dispatch_get_main_queue()) {
        completion(newCover: cover)
      }
    })
  }

  func coverForCategory(withID id: String) -> UIImage? {
    return self.dynamicType.imageCache.objectForKey(id) as? UIImage
  }

  func resetCover() {
    cover = nil
    filledGrids.removeAll()
  }

}
