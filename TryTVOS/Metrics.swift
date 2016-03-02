//
//  Metrics.swift
//  TryTVOS
//
//  Created by Ben on 28/02/2016.
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

struct Metrics {

  static let EdgePadding = UIEdgeInsets(top: 0, left: 90, bottom: 25, right: 90)

  static var horizontalFlowLayout: UICollectionViewFlowLayout {
    let _horizontal = UICollectionViewFlowLayout()
    _horizontal.scrollDirection = .Horizontal
    _horizontal.sectionInset = UIEdgeInsets(top: 0, left: EdgePadding.left, bottom: 0, right: EdgePadding.right)
    _horizontal.minimumInteritemSpacing = 0
    _horizontal.minimumLineSpacing = 50
    _horizontal.itemSize = CGSize(width: 308, height: 308)
    return _horizontal
  }

  static var verticalFlowLayout: UICollectionViewFlowLayout {
    let _vertical = UICollectionViewFlowLayout()
    _vertical.scrollDirection = .Vertical
    _vertical.sectionInset = UIEdgeInsets(top: EdgePadding.top, left: 0, bottom: EdgePadding.bottom, right: 0)
    _vertical.minimumInteritemSpacing = 0
    _vertical.minimumLineSpacing = 50
    _vertical.headerReferenceSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 100)
    _vertical.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 308)
    return _vertical
  }

}
