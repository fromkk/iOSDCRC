import XCTest
@testable import iOSDCRC



class TimelinePresenterTests: XCTestCase {
}


class TokenModelTests: XCTestCase {
    func testInit() {
        let spy = TokenModelDelegateSpy()
        let model = TokenModel(interactor: TimelineInteractorStub(firstResult: "ACCESS_TOKEN"))
        model.delegate = spy

        XCTAssertEqual(spy.results, [.notFetchedYet])
    }


    func testFetch() {
        let spy = TokenModelDelegateSpy()
        let model = TokenModel(interactor: TimelineInteractorFetchingStub())
        model.delegate = spy

        model.fetch()

        XCTAssertEqual(spy.results, [.notFetchedYet, .fetching])
    }


    func testFetched() {
        let accessToken = "ACCESS_TOKEN"
        let spy = TokenModelDelegateSpy()
        let model = TokenModel(interactor: TimelineInteractorStub(firstResult: accessToken))
        model.delegate = spy

        model.fetch()

        XCTAssertEqual(spy.results, [.notFetchedYet, .fetching, .fetched(accessToken: accessToken)])
    }


    func testReFetched() {
        let accessToken1 = "ACCESS_TOKEN_1"
        let accessToken2 = "ACCESS_TOKEN_2"
        let spy = TokenModelDelegateSpy()
        let interactorStub = TimelineInteractorStub(firstResult: accessToken1)
        let model = TokenModel(interactor: interactorStub)
        model.delegate = spy

        model.fetch()

        interactorStub.nextResult = accessToken2

        model.fetch()

        XCTAssertEqual(spy.results, [
            .notFetchedYet,
            .fetching,
            .fetched(accessToken: accessToken1),
            .fetching,
            .fetched(accessToken: accessToken2),
        ])
    }


    func testFailed() {
        let spy = TokenModelDelegateSpy()
        let model = TokenModel(interactor: TimelineInteractorStub(firstResult: nil))
        model.delegate = spy

        model.fetch()

        XCTAssertEqual(spy.results, [.notFetchedYet, .fetching, .failed(because: .unspecified(debugInfo: "nil"))])
    }


    class TokenModelDelegateSpy: TokenModelDelegate {
        private(set) var results = [TokenModelState]()

        func stateDidChange(state: TokenModelState) {
            self.results.append(state)
        }
    }
}


class TimelineInteractorStub: TwitterAccessTokenInteractorProtocol {
    var nextResult: String?


    init(firstResult: String?) {
        self.nextResult = firstResult
    }


    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ()) {
        completion(self.nextResult)
    }
}


class TimelineInteractorFetchingStub: TwitterAccessTokenInteractorProtocol {
    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ()) {}
}