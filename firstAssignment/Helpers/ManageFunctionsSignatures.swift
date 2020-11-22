//
//  ManageFunctionsSignatures.swift
//  firstAssignment
//
//  Created by Anna Kulaieva on 15.11.2020.
//

import Foundation

enum FunctionNamesEnum: String {
    case isSimilar = "Is Similar", permulations = "Permutations",
         isSimpleNumber = "Is Primary", averageNumber = "Average Number",
         tripleLetterWordsCount = "Triple letter words count"
}

struct AllFunctions: Codable {
    let allFunctions: [FunctionSignitureInfo]
}

struct FunctionSignitureInfo: Codable {
    let functionName: String
    let inputFieldsNumber: Int
    let inputNames: [String]
}

class FunctionsSignatures {
    
    var functionInfo: AllFunctions?
    
    func readFunctionsInfoJSON() {
        if let url = Bundle.main.url(forResource: "functionsInfo", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(AllFunctions.self, from: data)
                functionInfo = jsonData
            }
            catch {
                print("error:\(error)")
            }
        }
    }
}
