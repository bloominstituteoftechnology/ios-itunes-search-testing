//
//  MockJSON.swift
//  iTunes SearchTests
//
//  Created by Joseph Rogers on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

let goodResultData = """
{
  "resultCount": 2,
  "results": [
        {
          "trackName": "GarageBand",
          "artistName": "Apple",
        },
        {
          "trackName": "Garage Virtual Drumset Band",
          "artistName": "Nexogen Private Limited",
        }
    ]
}
""".data(using: .utf8)!

let badResultData = """
{
  "resultCount": 2,
  "results":
        {
          "trackName": "GarageBand",
          "akName": "Garage Virtual Drumset Band",
          "artistName": "Nexogen Private Limited",
        }
    ] Fuck Segues
}
""".data(using: .utf8)!

let noResultsData = """
{
  "resultCount": 0,
  "results": []
}
""".data(using: .utf8)!
