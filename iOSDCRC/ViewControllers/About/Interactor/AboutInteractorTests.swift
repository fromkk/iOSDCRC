import Foundation
import XCTest
@testable import iOSDCRC


let defaultTimeout: TimeInterval = 3


class AboutInteractorTests: XCTestCase {
    func testFetch() {
        let expectation = self.expectation(description: "Awaiting the interactor")
        let expected = AboutEntityFactory.create()

        let interactor = AboutInteractor(
            dependsTo: (
                resourceURLRepository: ResourceURLRepositoryStub(willReturn: URL(string: "http://example.com")!),
                dataRepository: DataRepositoryStub(willReturn: Data()),
                jsonDecodingRepository: JSONDecodingRepositoryStub(willReturn: expected).asAny()
            )
        )

        interactor.fetch { entity in
            XCTAssertEqual(entity, expected)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: defaultTimeout)
    }
}


class ResourceURLRepositoryStub: ResourceURLRepositoryProtocol {
    var nextResult: URL?


    init(willReturn firstResult: URL?) {
        self.nextResult = firstResult
    }


    func url(forResource basename: String, withExtension extname: String?) -> URL? {
        return self.nextResult
    }
}


class ResourceURLRepositorySpy: ResourceURLRepositoryProtocol {
    private let repository: ResourceURLRepositoryProtocol
    private(set) var callArgs = [CallArgs]()

    
    enum CallArgs: Equatable {
        case url(basename: String, extname: String?)
    }


    init(wrapping repository: ResourceURLRepositoryProtocol) {
        self.repository = repository
    }


    func url(forResource basename: String, withExtension extname: String?) -> URL? {
        self.callArgs.append(.url(basename: basename, extname: extname))
        return self.repository.url(forResource: basename, withExtension: extname)
    }
}


class DataRepositoryStub: DataRepositoryProtocol {
    var nextResult: Data?


    init(willReturn firstResult: Data?) {
        self.nextResult = firstResult
    }


    func data(contentsOf url: URL) -> Data? {
        return self.nextResult
    }
}


class JSONDecodingRepositoryStub<R: Decodable>: JSONDecodingRepositoryProtocol {
    typealias T = R

    var nextResult: R?


    init(willReturn firstResult: R?) {
        self.nextResult = firstResult
    }


    func from(data: Data, to type: R.Type) -> R? {
        return self.nextResult
    }
}


enum AboutEntityFactory {
    static func create(
        dates: [AboutEntity.DateRange] = [AboutEntityFactory.createDateRange()],
        locations: [AboutEntity.Location] = [AboutEntityFactory.createLocation()],
        sponsors: [AboutEntity.Sponsor] = [AboutEntityFactory.createSponsor()],
        speakers: [AboutEntity.TwitterAccount] = [AboutEntityFactory.createSpeaker()],
        staffs: [AboutEntity.TwitterAccount] = [AboutEntityFactory.createStaff()]
    ) -> AboutEntity {
        return AboutEntity(
            dates: dates,
            locations: locations,
            sponsors: sponsors,
            speakers: speakers,
            staffs: staffs
        )
    }


    static func createDateRange(
        from: Date = DateFactory.date(iso8601String: "2018-01-01T00:00:00+00:00")!,
        to: Date = DateFactory.date(iso8601String: "2018-01-01T23:59:59+00:00")!
    ) -> AboutEntity.DateRange {
        return AboutEntity.DateRange(from: from, to: to)
    }


    static func createLocation(
        name: String = "LOCATION_NAME",
        postalCode: String = "LOCATION_POSTAL_CODE",
        address: String = "LOCATION_ADDRESS"
    ) -> AboutEntity.Location {
        return AboutEntity.Location(
            name: name,
            postalCode: postalCode,
            address: address
        )
    }


    static func createSponsor(
        name: String = "SPONSOR_NAME",
        description: String = "SPONSOR_DESCRIPTION"
    ) -> AboutEntity.Sponsor {
        return AboutEntity.Sponsor(
            name: name,
            description: description
        )
    }


    static func createSpeaker(
        name: String = "SPEAKER_NAME",
        account: String = "SPEAKER_ACCOUNT"
    ) -> AboutEntity.TwitterAccount {
        return AboutEntity.TwitterAccount(
            name: name,
            account: account
        )
    }


    static func createStaff(
        name: String = "STAFF_NAME",
        account: String = "STAFF_ACCOUNT"
    ) -> AboutEntity.TwitterAccount {
        return AboutEntity.TwitterAccount(
            name: name,
            account: account
        )
    }
}


enum DateFactory {
    static func date(iso8601String: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: iso8601String)
    }
}
