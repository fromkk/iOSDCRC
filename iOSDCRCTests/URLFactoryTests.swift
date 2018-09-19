//
//  URLFactoryTests.swift
//  iOSDCRCTests
//
//  Created by Kenji Tanaka on 2018/09/18.
//  Copyright © 2018年 Kazuya Ueoka. All rights reserved.
//

import XCTest
@testable import iOSDCRC

class URLFactoryTests: XCTestCase {
    func testCreateTwitterUserURL() {
        XCTAssertEqual(
            URL(string: "twitter://user?screen_name=ktanaka117"),
            URLFactory.createTwitterUserURL(screenName: "ktanaka117")
        )

        XCTAssertEqual(
            URL(string: "twitter://user?screen_name=giginet"),
            URLFactory.createTwitterUserURL(screenName: "giginet")
        )

        XCTAssertEqual(
            nil,
            URLFactory.createTwitterUserURL(screenName: "")
        )
    }
}
