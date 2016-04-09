//
//  CGRect+Grid.swift
//  TryTVOS
//
//  Created by Ben on 04/04/2016.
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

enum Grid: Int {
  case TopLeft, TopRight, BottomLeft, BottomRight

  static let numberOfGrids: Int = {
    var count = 0
    while let _ = Grid(rawValue: count) { count += 1 }
    return count
  }()
}

func == (lhs: Grid, rhs: Grid) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

extension CGRect {

  func rect(bySize size: CGSize, atCorner corner: Grid) -> CGRect {
    let target = CGSize(width: min(width, size.width), height: min(height, size.height))
    switch corner {
    case .TopLeft:
      return divide(target.height, fromEdge: .MaxYEdge).remainder.divide(target.width, fromEdge: .MaxXEdge).remainder
    case .TopRight:
      return divide(target.height, fromEdge: .MaxYEdge).remainder.divide(target.width, fromEdge: .MaxXEdge).slice
    case .BottomLeft:
      return divide(target.height, fromEdge: .MaxYEdge).slice.divide(target.width, fromEdge: .MaxXEdge).remainder
    case .BottomRight:
      return divide(target.height, fromEdge: .MaxYEdge).slice.divide(target.width, fromEdge: .MaxXEdge).slice
    }
  }

}
