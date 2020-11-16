//
//  TaskImplementationViewController.swift
//  firstAssignment
//
//  Created by Anna Kulaieva on 14.11.2020.
//

import UIKit

class TaskImplementationViewController: UIViewController {
    
    @IBOutlet weak var functionNameLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var topInputTextField: UITextField!
    @IBOutlet weak var middleInputTextField: UITextField!
    @IBOutlet weak var bottomInputTextField: UITextField!
    @IBOutlet weak var getResultButton: UIButton!
    
    var selectedFunctionName: FunctionNamesEnum?
    var pickedFunctionsSignature: FunctionSignitureInfo?
    var allFunctionNames: [String] = []
    
    var topTextFieldInput: String = ""
    var middleTextFieldInput: String = ""
    var bottomTextFieldInput: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResultButton.layer.cornerRadius = 5
        topInputTextField.delegate = self
        middleInputTextField.delegate = self
        bottomInputTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let functionNameE = selectedFunctionName {
            functionNameLabel.text = functionNameE.rawValue
        }
        setInitialLayout()
    }
    
    fileprivate func setInitialLayout() {
        if let pickedFunctionsSignature = pickedFunctionsSignature {
            switch pickedFunctionsSignature.inputFieldsNumber {
            case 1:
                topInputTextField.isHidden = true
                bottomInputTextField.isHidden = true
                middleInputTextField.placeholder = pickedFunctionsSignature.inputNames[0]
            case 2:
                bottomInputTextField.isHidden = true
                topInputTextField.placeholder = pickedFunctionsSignature.inputNames[0]
                middleInputTextField.placeholder = pickedFunctionsSignature.inputNames[1]
            case 3:
                topInputTextField.placeholder = pickedFunctionsSignature.inputNames[0]
                middleInputTextField.placeholder = pickedFunctionsSignature.inputNames[1]
                bottomInputTextField.placeholder = pickedFunctionsSignature.inputNames[2]
            default:
                break
            }
        }
    }
    
    @IBAction func getFunctionResult(_ sender: UIButton) {
        guard let selectedFunctionName = selectedFunctionName else {
            outputLabel.text = "Incorrect input"
            return
        }
        switch selectedFunctionName {
        case .isSimilar:
            if !topTextFieldInput.isEmpty && !middleTextFieldInput.isEmpty && !bottomTextFieldInput.isEmpty, let n = Int(bottomTextFieldInput) {
                outputLabel.text = "\(selectedFunctionName.rawValue)" + " output is: " + "\(isSimilar(a: topTextFieldInput, b: middleTextFieldInput, n: n))"
            }
            else {
                outputLabel.text = "Incorrect input"
            }
        case .permulations:
            if !middleTextFieldInput.isEmpty {
                outputLabel.text = "\(selectedFunctionName.rawValue)" + " output is: ["
                let permutationsResult = permutations(s: middleTextFieldInput)
                for string in permutationsResult {
                    outputLabel.text! += string
                    if string != permutationsResult.last {
                        outputLabel.text! += ", "
                    }
                }
                outputLabel.text! += "]"
            }
            
        default:
            outputLabel.text = "Not implemented yet"
            return
        }
    }
}

extension TaskImplementationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textInput = textField.text else {
            return
        }
        switch textField.accessibilityIdentifier {
        case "top":
            topTextFieldInput = textInput
        case "middle":
            middleTextFieldInput = textInput
        case "bottom":
            bottomTextFieldInput = textInput
        default:
            return
        }
    }
}

extension TaskImplementationViewController {
    
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
    
    func generatePermutations(k: Int, sInitial: inout [Character],  result: inout [String]) {
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
}
