import Foundation
import XCTest
@testable import iOSDCRC


let defaultTimeout: TimeInterval = 3



class TimelinePresenterTests: XCTestCase {
    func testNotFetchedYet() {
        let stub = TwitterAccessTokenInteractorStub(willReturn: "IIKANJI_TOKEN")
        let model = TwitterAccessTokenModel(interactor: stub)

        XCTAssertEqual(model.state, .notLoadYet)
    }


    func testLoading() {
        let stub = TwitterAccessTokenInteractorLoadingStub(willReturn: "IIKANJI_TOKEN")
        let model = TwitterAccessTokenModel(interactor: stub)

        model.fetch()

        XCTAssertEqual(model.state, .loading)
    }


    func testLoaded() {
        let expectation = self.expectation(description: "いい感じ Token が帰ってくるまで待つ")

        let token = "IIKANJI_TOKEN"
        let stub = TwitterAccessTokenInteractorStub(willReturn: token)
        let model = TwitterAccessTokenModel(interactor: stub)
        let spy = TwitterAccessTokenModelDelegateSpy()
        spy.callback = { state in
            // .loading は無視する
            guard !state.isLoading else { return }

            XCTAssertEqual(model.state, .loaded(accessToken: token))
            expectation.fulfill()
        }
        model.delegate = spy

        model.fetch()

        self.waitForExpectations(timeout: defaultTimeout)
    }


    func testFailed() {
        let expectation = self.expectation(description: "Token 取得の失敗が判明するまで待つ")

        let stub = TwitterAccessTokenInteractorStub(willReturn: nil)
        let model = TwitterAccessTokenModel(interactor: stub)
        let spy = TwitterAccessTokenModelDelegateSpy()
        spy.callback = { state in
            // .loading は無視する
            guard !state.isLoading else { return }

            XCTAssertEqual(model.state, .failed)
            expectation.fulfill()
        }
        model.delegate = spy

        model.fetch()

        self.waitForExpectations(timeout: defaultTimeout)
    }
}



class TwitterAccessTokenInteractorStub: TwitterAccessTokenInteractorProtocol {
    var nextValue: String?


    init(willReturn firstValue: String?) {
        self.nextValue = firstValue
    }


    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ()) {
        DispatchQueue.main.async {
            completion(self.nextValue)
        }
    }
}



class TwitterAccessTokenInteractorLoadingStub: TwitterAccessTokenInteractorProtocol {
    var nextValue: String?


    init(willReturn firstValue: String?) {
        self.nextValue = firstValue
    }


    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ()) {
    }
}



class TwitterAccessTokenModelDelegateSpy: TwitterAccessTokenModelDelegate {
    var callback: ((TwitterAccessTokenModelState) -> Void)?


    func twitterAccessTokenModelStateDidChange(state: TwitterAccessTokenModelState) {
        DispatchQueue.main.async {
            self.callback?(state)
        }
    }
}
