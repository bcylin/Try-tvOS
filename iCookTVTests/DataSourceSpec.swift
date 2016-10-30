//
//  DataSourceSpec.swift
//  TryTVOS
//
//  Created by Ben on 14/08/2016.
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

@testable import iCookTV
import UIKit
import Nimble
import Quick

class DataSourceSpec: QuickSpec {

  private struct TestCollection: DataCollection {
    typealias DataType = String
    private(set) var items: [String]
  }

  private var dataSource = DataSource(dataCollection: TestCollection(items: []))
  private let dataCollection = TestCollection(items: [
    "Lorem", "ipsum", "dolor", "sit", "amet"
  ])
  private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())

  override func spec() {

    beforeEach {
      self.dataSource = DataSource(dataCollection: self.dataCollection)
    }

    describe("SourceType") {
      describe("numberOfItems") {
        it("should return the count of items") {
          expect(self.dataSource.numberOfItems) == 5
        }
      }

      describe("subscript") {
        it("should return the item at index") {
          expect(self.dataSource[0]) == "Lorem"
          expect(self.dataSource[1]) == "ipsum"
          expect(self.dataSource[2]) == "dolor"
          expect(self.dataSource[3]) == "sit"
          expect(self.dataSource[4]) == "amet"
        }
      }
    }

    describe("append(_:toCollectionView:") {
      it("should append items to collection") {
        let items = ["consectetur", "adipisicing", "elit"]
        self.dataSource.append(items, toCollectionView: self.collectionView)

        expect(self.dataSource.numberOfItems) == 8
        expect(self.dataSource[5]) == "consectetur"
        expect(self.dataSource[6]) == "adipisicing"
        expect(self.dataSource[7]) == "elit"
      }
    }

    describe("moveItem(atIndexPathToTop:inCollectionView:") {
      it("should reorder the items") {
        self.dataSource.moveItem(
          atIndexPathToTop: IndexPath(row: 2, section: 0),
          inCollectionView: self.collectionView
        )
        expect(self.dataSource.numberOfItems) == 5
        expect(self.dataSource[0]) == "dolor"
        expect(self.dataSource[1]) == "Lorem"
        expect(self.dataSource[2]) == "ipsum"
        expect(self.dataSource[3]) == "sit"
        expect(self.dataSource[4]) == "amet"
      }
    }

  }

}
