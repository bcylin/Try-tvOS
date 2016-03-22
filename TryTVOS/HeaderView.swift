//
//  HeaderView.swift
//  TryTVOS
//
//  Created by Ben on 21/03/2016.
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

/// A customized view with a layout of `V:|-[icon][title]-(>=0)-[accessory]-|`.
class HeaderView: UICollectionReusableView {

  private(set) lazy var titleLabel: UILabel = {
    let _title = UILabel()
    _title.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
    _title.textColor = UIColor.tvTitleColor()
    return _title
  }()

  private(set) lazy var accessoryLabel: UILabel = {
    let _accessory = UILabel()
    _accessory.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
    _accessory.textColor = UIColor.tvTitleColor()
    return _accessory
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

  // MARK: - Private Methods

  private func setUpSubviews() {
    addSubview(titleLabel)
    addSubview(accessoryLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    accessoryLabel.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: Metrics.EdgePadding.left).active = true
    titleLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    accessoryLabel.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -Metrics.EdgePadding.right).active = true
    accessoryLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
  }

}
