//
//  UIColor+TV.swift
//  TryTVOS
//
//  Created by Ben on 22/03/2016.
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
import Hue

extension UIColor {

  enum Palette {
    static let White = UIColor.whiteColor()
    static let LightGray = UIColor.hex("#EFEDE8")
    static let GreyishBrown = UIColor.hex("#564E4A")

    enum Button {
      static let TitleColor = White
      static let BackgroundColor = GreyishBrown.colorWithAlphaComponent(0.6)
    }

    enum FocusedButton {
      static let TitleColor = GreyishBrown
      static let BackgroundColor = White
    }
  }

  class func tvTaglineColor() -> UIColor {
    return Palette.GreyishBrown
  }

  class func tvTextColor() -> UIColor {
    return Palette.GreyishBrown.colorWithAlphaComponent(0.8)
  }

  class func tvFocusedTextColor() -> UIColor {
    return Palette.GreyishBrown
  }

  class func tvHeaderTitleColor() -> UIColor {
    return Palette.GreyishBrown
  }

  class func tvBackgroundColor() -> UIColor {
    return Palette.LightGray
  }

  class func tvMenuBarColor() -> UIColor {
    return Palette.LightGray
  }

}
