//
//  CategoryCell.swift
//  TryTVOS
//
//  Created by Ben on 23/03/2016.
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
import Kingfisher

class CategoryCell: UICollectionViewCell {

  private(set) lazy var imageView: UIImageView = {
    let _imageView = UIImageView()
    _imageView.image = UIImage.placeholderImage(withSize: self.bounds.size)
    _imageView.contentMode = .ScaleAspectFill
    return _imageView
  }()

  private var urls = [Grid: NSURL]() {
    didSet {
      // Cancel previous tasks
      for (corner, task) in tasks {
        task.cancel()
        tasks[corner] = nil
      }
      for (corner, url) in urls {
        let downloading = ImageDownloader.defaultDownloader.downloadImageWithURL(url, progressBlock: nil) {
          [weak self] image, error, imageURL, originalData in

          self?.tasks[corner] = nil
          guard let image = image where imageURL == url else {
            return
          }
          self?.imageOperationQueue.addOperation(NSBlockOperation {
            self?.setImage(image, atCorner: corner)
          })
        }
        if let task = downloading {
          tasks[corner] = task
        }
      }
    }
  }

  private var tasks = [Grid: RetrieveImageDownloadTask]()

  private lazy var imageOperationQueue: NSOperationQueue = {
    let _queue = NSOperationQueue.mainQueue()
    _queue.maxConcurrentOperationCount = 1
    return _queue
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpSubviews()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    for (index, task) in tasks {
      task.cancel()
      tasks[index] = nil
    }
    imageOperationQueue.cancelAllOperations()
    imageView.image = UIImage.placeholderImage(withSize: bounds.size)
  }


  // MARK: - Private Methods

  private func setUpSubviews() {
    contentView.addSubview(imageView)
    imageView.adjustsImageWhenAncestorFocused = true
    imageView.image = UIImage.placeholderImage(withSize: bounds.size)
    imageView.contentMode = .ScaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false

    imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
    imageView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
    imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
    imageView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true

    imageView.contentMode = .ScaleAspectFill
  }

  private func setImage(image: UIImage, atCorner corner: Grid) {
    let coverSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
    var cover: UIImage!

    if let currentImage = imageView.image where currentImage.size == coverSize {
      cover = currentImage
    } else {
      cover = UIImage.placeholderImage(withSize: coverSize)
    }

    cover = cover.image(byReplacingImage: image, atCorner: corner)
    UIView.transitionWithView(
      imageView,
      duration: 0.3,
      options: [.TransitionCrossDissolve, .CurveEaseIn],
      animations: {
        self.imageView.image = cover
      }, completion: nil
    )
  }

  // MARK: - Public Methods

  func configure(withCategory category: Category) {
    var covers = [Grid: NSURL]()
    for (index, value) in category.coverURLs.enumerate() {
      guard let corner = Grid(rawValue: index), let url = NSURL(string: value) else { continue }
      covers[corner] = url
    }
    urls = covers
  }

}
