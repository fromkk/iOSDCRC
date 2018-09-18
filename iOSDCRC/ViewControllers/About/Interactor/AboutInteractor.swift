//
//  AboutInteractor.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

class AboutInteractor: AboutInteractorProtocol {
    typealias Dependency = (
        resourceURLRepository: ResourceURLRepositoryProtocol,
        dataRepository: DataRepositoryProtocol,
        jsonDecodingRepository: AnyJSONDecodingRepository<AboutEntity>
    )
    private let dependency: Dependency


    init(dependsTo dependency: Dependency) {
        self.dependency = dependency
    }


    func fetch(_ completion: @escaping (AboutEntity?) -> ()) {
        guard let url = self.dependency.resourceURLRepository.url(forResource: "about", withExtension: "json") else {
            debugPrint(#function, "url get failed")
            completion(nil)
            return
        }
        
        guard let data = self.dependency.dataRepository.data(contentsOf: url) else {
            debugPrint(#function, "data get failed")
            completion(nil)
            return
        }

        guard let entity = self.dependency.jsonDecodingRepository.from(data: data, to: AboutEntity.self) else {
            debugPrint(#function, "decode failed")
            completion(nil)
            return
        }

        completion(entity)
    }
}


protocol ResourceURLRepositoryProtocol {
    func url(forResource basename: String, withExtension extension: String?) -> URL?
}


class BundleResourceURLRepository: ResourceURLRepositoryProtocol {
    private let bundle: Bundle
    
    
    init(_ bundle: Bundle) {
        self.bundle = bundle
    }
    
    
    func url(forResource basename: String, withExtension extname: String?) -> URL? {
        return self.bundle.url(forResource: basename, withExtension: extname)
    }
}


protocol DataRepositoryProtocol {
    func data(contentsOf url: URL) -> Data?
}


class DataRepository: DataRepositoryProtocol {
    func data(contentsOf url: URL) -> Data? {
        // TODO: あとでエラー原因がわかりやすくなるようにリファクタリングする
        return try? Data(contentsOf: url)
    }
}


protocol JSONDecodingRepositoryProtocol {
    associatedtype T: Decodable

    func from(data: Data, to type: T.Type) -> T?
}


extension JSONDecodingRepositoryProtocol {
    func asAny() -> AnyJSONDecodingRepository<T> {
        return AnyJSONDecodingRepository(repository: self)
    }
}


struct AnyJSONDecodingRepository<R: Decodable>: JSONDecodingRepositoryProtocol {
    typealias T = R


    private let decode: (R.Type, Data) -> R?


    init<Repository: JSONDecodingRepositoryProtocol>(repository: Repository) where Repository.T == R {
        self.decode = { (type: R.Type, data: Data) -> R? in
            return repository.from(data: data, to: type)
        }
    }


    func from(data: Data, to type: R.Type) -> R? {
        return self.decode(type, data)
    }
}


class JSONDecodingRepository<R: Decodable>: JSONDecodingRepositoryProtocol {
    typealias T = R


    private let jsonDecoder: JSONDecoder


    init() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601

        self.jsonDecoder = jsonDecoder
    }


    func from(data: Data, to type: R.Type) -> R? {
        // TODO: エラーはあとでわかりやすくする
        return try? self.jsonDecoder.decode(type, from: data)
    }
}
