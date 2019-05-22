//
//  String_isOnlyNumber.swift
//  freee_SelectionSubject_AccountBook
//
//  Created by 大林拓実 on 2019/05/20.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//
//  Reference by https://qiita.com/nakau1/items/32c9be34906e94603ff1

import Foundation

extension String{
    public func isOnly(_ characterSet: CharacterSet) -> Bool {
        return self.trimmingCharacters(in: characterSet).count <= 0
    }
    
    public func isOnlyNumeric() -> Bool {
        return isOnly(.decimalDigits)
    }
    
    public func isOnly(_ characterSet: CharacterSet, _ additionalString: String) -> Bool {
        var replaceCharacterSet = characterSet
        replaceCharacterSet.insert(charactersIn: additionalString)
        return isOnly(replaceCharacterSet)
    }
}
