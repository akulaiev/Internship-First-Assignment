//
//  MethodsImplementations.swift
//  firstAssignment
//
//  Created by Anna Kulaieva on 22.11.2020.
//

import Foundation

class MethodsImplementations {
    
    func isSimilar(a: String, b: String, n: Int) -> Bool {
        var differentSymbolsLeft = n
        if a.count != b.count {
            return false
        }
        if a == b {
            return true
        }
        for (letterA, letterB) in zip(a, b) {
            if letterA != letterB {
                differentSymbolsLeft -= 1
            }
            if differentSymbolsLeft < 0 {
                return false
            }
        }
        return true
    }
    
    fileprivate func generatePermutations(k: Int, sInitial: inout [Character],  result: inout [String]) {
        if k > 1 {
            generatePermutations(k: k - 1, sInitial: &sInitial, result: &result)
            for i in 0..<k - 1 {
                if k % 2 == 0 {
                    sInitial.swapAt(i, k - 1)
                }
                else {
                    sInitial.swapAt(0, k - 1)
                }
                result.append(String(sInitial))
                generatePermutations(k: k - 1, sInitial: &sInitial, result: &result)
            }
        }
    }
    
    func permutations(s: String) -> [String] {
        var result: [String] = [s]
        var sArray = Array(s)
        generatePermutations(k: sArray.count, sInitial: &sArray, result: &result)
        return result
    }
    
    func isSimple(n: Int) -> Bool {
        if n % 2 == 0 {
            return false
        }
        for i in stride(from: 3, through: sqrt(Double(n)), by: 2) {
            if n % Int(i) == 0 {
                return false
            }
        }
        return true
    }

    func average<T:MyNumericProtocol>(numericArray: [T]) -> T {
        var sum = T(0)
        for number in numericArray {
            sum = sum + number
        }
        return sum / T(numericArray.count)
    }
    
    fileprivate func createAllNLengthWords(charsToUse: String, result: String, resultArray: inout [String], initialWorldLen: Int, resultWordLen: Int) {
        if resultWordLen == 0 {
            if checkValidWord(for: "(.+?)\\1+", in: result) {
                resultArray.append(result)
            }
            return
        }
        for i in 0..<initialWorldLen {
            var newResString: String = ""
            newResString = result + String(charsToUse[charsToUse.index(charsToUse.startIndex, offsetBy: i)]);
            createAllNLengthWords(charsToUse: charsToUse, result: newResString, resultArray: &resultArray, initialWorldLen: initialWorldLen, resultWordLen: resultWordLen - 1)
        }
    }
    
    func checkValidWord(for regex: String, in text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            for test in results {
                if test.range.length > 1 {
                    return false
                }
            }
            return true
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    func trippleLettersWordsCount(worldLen: Int) -> Int {
        var resultArray: [String] = []
        createAllNLengthWords(charsToUse: "abc", result: "", resultArray: &resultArray, initialWorldLen: 3, resultWordLen: worldLen)
        return resultArray.count
    }
}

protocol MyNumericProtocol {
    static func +(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
    init(_ v: Int)
    init(_ v: Double)
}

extension Int: MyNumericProtocol {}
extension Double: MyNumericProtocol {}

