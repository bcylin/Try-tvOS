//
//  MenuView.swift
//  TryTVOS
//
//  Created by Ben on 05/04/2016.
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

/// A customized view with a layout of `H:|[focusGuide][button]-|`.
class MenuView: UIView {

  private let imageView = UIImageView(image: UIImage(named: "icook-tv-logo"))

  private lazy var titleLabel: UILabel = {
    let _label = UILabel()
    _label.font = UIFont.tvFontForHeaderTitle()
    _label.textColor = UIColor.tvHeaderTitleColor()
    _label.text = "iCook TV".localizedString
    return _label
  }()

  private(set) lazy var button: UIButton = {
    let _button = MenuButton(type: .System)
    _button.titleLabel?.font = UIFont.tvFontForMenuButton()
    return _button
  }()

  private let focusGuide = UIFocusGuide()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpSubviews()
  }

  // MARK: - Private Methods

  private func setUpSubviews() {
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(button)
    addLayoutGuide(focusGuide)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false

    focusGuide.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
    focusGuide.trailingAnchor.constraintEqualToAnchor(button.leadingAnchor).active = true
    focusGuide.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
    focusGuide.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true

    imageView.contentMode = .ScaleAspectFill
    imageView.widthAnchor.constraintEqualToConstant(87).active = true
    imageView.heightAnchor.constraintEqualToConstant(64).active = true
    imageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: Metrics.EdgePadding.left).active = true
    imageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true

    titleLabel.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: 20).active = true
    titleLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true

    button.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -Metrics.EdgePadding.right).active = true
    button.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
  }

}
