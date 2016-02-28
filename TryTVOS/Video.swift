//
//  Video.swift
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

import Foundation
import Freddy

struct Video {

  let id: Int
  let title: String
  let description: String
  let youtube: String
  let cover: Cover?

}

extension Video {

  init(json value: JSON) throws {
    id = try value.int("id")
    title = try value.string("title")
    description = try value.string("description")
    youtube = try value.string("embed_url")
    cover = try value["image"].map(Cover.init)
  }

}


////////////////////////////////////////////////////////////////////////////////


struct Cover {

  let large: String
  let medium: String
  let thumb: String

}

extension Cover {

  init(json value: JSON) throws {
    large = try value.string("url")
    medium = try value.string("medium", "url")
    thumb = try value.string("thumb", "url")
  }

}
