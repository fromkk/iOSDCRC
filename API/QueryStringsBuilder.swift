//
//  QueryStringsBuilder.swift
//  API
//
//  Created by Kazuya Ueoka on 2018/07/08.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

public class QueryStringsBuilder {
    
    public enum Options {
        case urlEncoding
    }
    
    let dictionary: [String: Any]
    public init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    private var options: [Options] = []
    public func build(with options: [Options] = [.urlEncoding]) -> String {
        self.options = options
        return convert(dictionary: dictionary, with: "")
    }
    
    public func data() -> Data? {
        return build().data(using: .utf8)
    }
    
    func convert(array: [Any], with key: String) -> String {
        return array.enumerated().compactMap({ current in
            let key = String(format: "%@[%d]", key, current.offset)
            return toString(with: current.element, and: key)
        }).joined(separator: "&")
    }
    
    func convert(dictionary: [String: Any], with parentKey: String) -> String {
        return dictionary.keys.sorted().compactMap({ key in
            let outputKey: String = parentKey.isEmpty ? key : String(format: "%@[%@]", parentKey, key)
            guard let value = dictionary[key] else {  return nil }
            return toString(with: value, and: outputKey)
        }).joined(separator: "&")
    }
    
    func toString(with value: Any, and key: String) -> String? {
        if let stringValue = value as? String {
            return String(format: "%@=%@", key, escapeIfNeeded(with: stringValue))
        } else if let arrayValue = value as? [Any] {
            return convert(array: arrayValue, with: key)
        } else if let dictValue = value as? [String: Any] {
            return convert(dictionary: dictValue, with: key)
        } else if let custom = value as? CustomStringConvertible {
            return String(format: "%@=%@", key, escapeIfNeeded(with: custom.description))
        } else {
            return String(format: "%@=", key)
        }
    }
    
    private func escapeIfNeeded(with string: String) -> String {
        guard options.contains(.urlEncoding) else { return string }
        
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._~")
        return string.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
    }
}
