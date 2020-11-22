//
//  InputOutputViewController.swift
//  firstAssignment
//
//  Created by Anna Kulaieva on 14.11.2020.
//

import UIKit

enum TextFields: Int {
    case top = 3, middle = 4, bottom = 5
}

class InputOutputViewController: UIViewController {
    
    @IBOutlet weak var functionNameLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var getResultButton: UIButton!
    @IBOutlet weak var inputTextFieldsView: UIView!
    @IBOutlet weak var computingIndicatorView: UIActivityIndicatorView!
    
    var inputTextFields: [UITextField] = []
    
    var selectedFunctionName: FunctionNamesEnum?
    var pickedFunctionsSignature: FunctionSignitureInfo?
    
    var topTextFieldInput: String = ""
    var middleTextFieldInput: String = ""
    var bottomTextFieldInput: String = ""
    
    var methods = MethodsImplementations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResultButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        computingIndicatorView.stopAnimating()
        if let functionNameE = selectedFunctionName {
            functionNameLabel.text = functionNameE.rawValue
        }
        inputTextFieldsView.layoutIfNeeded()
        setInitialLayout()
    }
    
    fileprivate func configureTextField(_ inputTextField: UITextField, placeholderText: String, i: Int) {
        inputTextField.delegate = self
        inputTextField.isHidden = false
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.borderStyle = .roundedRect
        inputTextField.placeholder = placeholderText
        inputTextField.tag = i + 3
    }
    
    fileprivate func createtextFieldFrame(i: Int, inputFieldsNum: CGFloat) -> CGRect {
        let viewBounds = inputTextFieldsView.bounds
        let textFieldWidth = viewBounds.width * 0.85
        var tfSectionHeight: CGFloat = 0.0
        var textFieldHeight: CGFloat = 0.0
        var yPos: CGFloat = 0.0
        if inputFieldsNum != 1 {
            tfSectionHeight = viewBounds.height / inputFieldsNum
            textFieldHeight = tfSectionHeight * 0.35
            yPos = (((tfSectionHeight) * CGFloat(i + 1)) - (tfSectionHeight / 2)) - textFieldHeight / 2
        }
        else {
            textFieldHeight = viewBounds.height * 0.1
            yPos = (viewBounds.height / 2) - textFieldHeight / 2
        }
        let tfRect = CGRect(x: (viewBounds.width / 2) - (textFieldWidth / 2), y: yPos, width: textFieldWidth, height: textFieldHeight)
        return inputTextFieldsView.convert(tfRect, to: inputTextFieldsView)
    }
    
    fileprivate func setInitialLayout() {
        if let pickedFunctionsSignature = pickedFunctionsSignature {
            for i in 0..<pickedFunctionsSignature.inputFieldsNumber {
                let inputTextField = UITextField(frame: createtextFieldFrame(i: i, inputFieldsNum: CGFloat(pickedFunctionsSignature.inputFieldsNumber)))
                configureTextField(inputTextField, placeholderText: pickedFunctionsSignature.inputNames[i], i: i)
                inputTextFieldsView.addSubview(inputTextField)
                inputTextFields.append(inputTextField)
            }
        }
    }
    
    fileprivate func computeAverageNumber() {
        if !topTextFieldInput.isEmpty {
            let inputStringArray = topTextFieldInput.contains(",") ? topTextFieldInput.components(separatedBy: ",") : topTextFieldInput.components(separatedBy: " ")
            var doublesArray: [Double] = []
            var intArray: [Int] = []
            for string in inputStringArray {
                if inputStringArray[0].contains("."), let double = Double(string.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    doublesArray.append(double)
                }
                else if let integer = Int(string.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    intArray.append(integer)
                }
            }
            if doublesArray.count == inputStringArray.count {
                outputLabel.text = "Average number is: " + "\(methods.average(numericArray: doublesArray))"
            }
            else if intArray.count == inputStringArray.count {
                outputLabel.text = "Average number is: " + "\(methods.average(numericArray: intArray))"
            }
            else {
                outputLabel.text = "Incorrect input"
            }
        }
        else {
            outputLabel.text = "Incorrect input"
        }
    }
    
    @IBAction func getFunctionResult(_ sender: UIButton) {
        guard let selectedFunctionName = selectedFunctionName else {
            return
        }
        switch selectedFunctionName {
        case .isSimilar:
            outputLabel.text = !topTextFieldInput.isEmpty && !middleTextFieldInput.isEmpty && !bottomTextFieldInput.isEmpty && (Int(bottomTextFieldInput) != nil) ? "\(selectedFunctionName.rawValue)" + " output is: " + "\(methods.isSimilar(a: topTextFieldInput, b: middleTextFieldInput, n: Int(bottomTextFieldInput)!))" : "Incorrect input"
        case .permulations:
            if !topTextFieldInput.isEmpty {
                outputLabel.text = "\(selectedFunctionName.rawValue)" + " output is: ["
                let permutationsResult = methods.permutations(s: topTextFieldInput)
                for i in 0..<permutationsResult.count - 1 {
                    outputLabel.text! += permutationsResult[i] + ", "
                }
                outputLabel.text! += permutationsResult.last! + "]"
            }
            else {
                outputLabel.text! = "Incorrect input"
            }
        case .isSimpleNumber:
            if !topTextFieldInput.isEmpty, let number = Int(topTextFieldInput) {
                outputLabel.text = methods.isSimple(n: number) ? "\(number) is primary. " : "\(number) is composite. "
                outputLabel.text! += "Algorithmic complexity is O(√n / 2)"
            }
            else {
                outputLabel.text = "Incorrect input"
            }
        case .averageNumber:
            computeAverageNumber()
        case .tripleLetterWordsCount:
            outputLabel.text = !topTextFieldInput.isEmpty && (Int(topTextFieldInput) != nil) ? "It is possible to create " + "\(methods.trippleLettersWordsCount(worldLen: Int(topTextFieldInput)!)) valid words" + " from given input. " : "Incorrect input"
        }
    }
}

extension InputOutputViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textfieldTag = TextFields(rawValue: textField.tag)
        guard let textInput = textField.text else {
            return
        }
        switch textfieldTag {
        case .top:
            topTextFieldInput = textInput
        case .middle:
            middleTextFieldInput = textInput
        case .bottom:
            bottomTextFieldInput = textInput
        default:
            return
        }
    }
}
