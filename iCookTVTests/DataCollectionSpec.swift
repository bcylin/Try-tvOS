//
//  DataCollectionSpec.swift
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
import Nimble
import Quick

class DataCollectionSpec: QuickSpec {

  private struct TestCollection: DataCollection {
    typealias DataType = Int
    private(set) var items: [Int]
  }

  private var dataCollection = TestCollection(items: [])

  override func spec() {

    beforeEach {
      self.dataCollection = TestCollection(items: [1, 1, 2, 3, 5, 8])
    }

    describe("count") {
      it("should return the count of items") {
        expect(self.dataCollection.count) == 6
      }
    }

    describe("subscript") {
      it("should return the item at index") {
        expect(self.dataCollection[0]) == 1
        expect(self.dataCollection[1]) == 1
        expect(self.dataCollection[2]) == 2
        expect(self.dataCollection[3]) == 3
        expect(self.dataCollection[4]) == 5
        expect(self.dataCollection[5]) == 8
      }
    }

    describe("append(_:)") {
      it("should append items to collection") {
        let collection = self.dataCollection.append([13, 21, 34, 55])
        expect(self.dataCollection.count) == 6
        expect(collection.count) == 10
        expect(collection[6]) == 13
        expect(collection[7]) == 21
        expect(collection[8]) == 34
        expect(collection[9]) == 55
      }
    }

    describe("insert(_:atIndex:)") {
      it("should insert item to collection") {
        let collection = self.dataCollection.insert(42, atIndex: 3)
        expect(self.dataCollection.count) == 6
        expect(collection.count) == 7
        expect(collection.items) == [1, 1, 2, 42, 3, 5, 8]
      }
    }

    describe("deleteItem(atIndex:)") {
      it("should delete item at index") {
        let collection = self.dataCollection.deleteItem(atIndex: 3)
        expect(self.dataCollection.count) == 6
        expect(collection.count) == 5
        expect(collection.items) == [1, 1, 2, 5, 8]
      }
    }

    describe("moveItem(fromIndex:toIndex:)") {
      it("should reorder the items") {
        let collection = self.dataCollection.moveItem(fromIndex: 1, toIndex: 4)
        expect(self.dataCollection.count) == 6
        expect(collection.count) == 6
        expect(collection.items) == [1, 2, 3, 5, 1, 8]
      }
    }

  }

}
