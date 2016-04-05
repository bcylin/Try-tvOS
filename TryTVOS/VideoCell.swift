//
//  VideoCell.swift
//  TryTVOS
//
//  Created by Ben on 19/02/2016.
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

class VideoCell: UICollectionViewCell {

  let imageView = UIImageView()

  private(set) lazy var textLabel: UILabel = {
    let _label = UILabel()
    _label.font = UIFont.tvFontForNormalCell()
    _label.textColor = UIColor.grayColor()
    _label.textAlignment = .Center
    return _label
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpAppearance()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpAppearance()
  }

  // MARK: - UICollectionViewCell

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.kf_cancelDownloadTask()
    imageView.image = nil
    textLabel.text = nil
  }

  // MARK: - UIFocusEnvironment

  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    let restored = (context.previouslyFocusedView == self)

    let color = restored ? UIColor.grayColor() : UIColor.whiteColor()
    let transform = restored ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, 15)
    let font = restored ? UIFont.tvFontForNormalCell() : UIFont.tvFontForFocusedCell()

    coordinator.addCoordinatedAnimations({
      self.textLabel.textColor = color
      self.textLabel.transform = transform
      self.textLabel.font = font
    }, completion: nil)
  }

  // MARK: - Private Methods

  private func setUpAppearance() {
    clipsToBounds = false
    imageView.adjustsImageWhenAncestorFocused = true

    contentView.addSubview(imageView)
    contentView.addSubview(textLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
    imageView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
    imageView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
    imageView.heightAnchor.constraintEqualToAnchor(contentView.widthAnchor, multiplier: 3/4).active = true

    textLabel.translatesAutoresizingMaskIntoConstraints = false
    textLabel.topAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 20).active = true
    textLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
    textLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
  }

  // MARK: - Public Methods

  func configure(withVideo video: Video) {
    if let smallURL = video.cover?.small, let url = NSURL(string: smallURL) {
      imageView.kf_setImageWithURL(url)
    }
    textLabel.text = video.title
  }

}
