//
//  BlurBackgroundViewController.swift
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

class BlurBackgroundViewController: UIViewController {

  var isLoading = false {
    didSet {
      if isLoading {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
    }
  }

  var backgroundImage: UIImage? {
    didSet {
      // Throttle background image transition to avoid extensive changes in a short period of time.
      NSObject.cancelPreviousPerformRequests(withTarget: self, selector: .animateBackgroundTransition, object: nil)
      perform(.animateBackgroundTransition, with: nil, afterDelay: 0.2)
    }
  }

  private let backgroundImageView = UIImageView()

  private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let _indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    _indicator.color = UIColor.Palette.GreyishBrown
    _indicator.hidesWhenStopped = true
    return _indicator
  }()

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.tvBackgroundColor()
    backgroundImageView.frame = view.bounds
    backgroundImageView.contentMode = .scaleAspectFill
    backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    view.addSubview(backgroundImageView)
    view.addSubview(blurEffectView)
    view.addSubview(activityIndicator)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  // MARK: - Private Methods

  @objc fileprivate func animateBackgroundTransition() {
    Debug.print(#function)
    UIView.transition(
      with: self.backgroundImageView,
      duration: 0.5,
      options: [.beginFromCurrentState, .transitionCrossDissolve, .curveEaseIn],
      animations: {
        self.backgroundImageView.image = self.backgroundImage
      }, completion: nil
    )
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let animateBackgroundTransition = #selector(BlurBackgroundViewController.animateBackgroundTransition)
}
