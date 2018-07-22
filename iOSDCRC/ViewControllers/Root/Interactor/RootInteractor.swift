//
//  RootInteractor.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

protocol RootInteractorProtocol {
    func menu(completion: @escaping ([RootEntity]) -> ())
}

class RootInteractor: RootInteractorProtocol {
    func menu(completion: @escaping ([RootEntity]) -> ()) {
        completion(RootEntity.allCases)
    }
}
