//
//  MainMenuView.swift
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

class MainMenuView: UIView {

  private let frontBanner = UIImageView(image: UIImage(named: "tv-banner-food-1"))
  private let backBanner = UIImageView(image: UIImage(named: "tv-banner-food-2"))
  private let imageView = UIImageView()

  private(set) lazy var titleLabel: UILabel = {
    let _title = UILabel()
    _title.font = UIFont.tvFontForLogo()
    _title.textColor = UIColor.tvHeaderTitleColor()
    _title.text = "Try-tvOS".localizedString
    return _title
  }()

  private(set) lazy var button: UIButton = {
    let _button = MenuButton(type: .System)
    _button.titleLabel?.font = UIFont.tvFontForHeaderTitle()
    return _button
  }()

  private let focusGuide = UIFocusGuide()
  private var frontBannerConstraint: NSLayoutConstraint?
  private var backBannerConstraint: NSLayoutConstraint?

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpSubviews()
  }

  // MARK: - UIFocusEnvironment

  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    let focused = (context.nextFocusedView == button)
    layoutIfNeeded()

    coordinator.addCoordinatedAnimations({
      self.frontBannerConstraint?.constant = focused ? -10 : 0
      self.backBannerConstraint?.constant = focused ? 0 : -10
      self.layoutIfNeeded()
    }, completion: nil)
  }

  // MARK: - Private Methods

  private func setUpSubviews() {
    addSubview(frontBanner)
    addSubview(backBanner)
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(button)
    addLayoutGuide(focusGuide)

    frontBanner.translatesAutoresizingMaskIntoConstraints = false
    backBanner.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.borderWidth = 1
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false

    frontBannerConstraint = frontBanner.topAnchor.constraintEqualToAnchor(topAnchor)
    frontBannerConstraint?.active = true
    frontBanner.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
    frontBanner.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true

    backBannerConstraint = backBanner.topAnchor.constraintEqualToAnchor(topAnchor, constant: -10)
    backBannerConstraint?.active = true
    backBanner.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
    backBanner.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true

    focusGuide.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
    focusGuide.trailingAnchor.constraintEqualToAnchor(button.leadingAnchor).active = true
    focusGuide.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
    focusGuide.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true

    imageView.widthAnchor.constraintEqualToConstant(120).active = true
    imageView.heightAnchor.constraintEqualToConstant(88).active = true
    imageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 222).active = true
    imageView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 136).active = true

    titleLabel.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: 20).active = true
    titleLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 150).active = true

    button.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -148).active = true
    button.centerYAnchor.constraintEqualToAnchor(titleLabel.centerYAnchor).active = true
  }

}
