//
//  TasksListViewController.swift
//  firstAssignment
//
//  Created by Anna Kulaieva on 14.11.2020.
//

import UIKit

class TasksListViewController: UIViewController {

    @IBOutlet weak var tasksListPickerView: UIPickerView!
    @IBOutlet weak var testFunctionButton: UIButton!
    
    let functions = FunctionsSignatures()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functions.readFunctionsInfoJSON()
        testFunctionButton.layer.cornerRadius = 5
        tasksListPickerView.delegate = self
        tasksListPickerView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let taskImplementationVC = segue.destination as! InputOutputViewController
        guard let functionsInfo = functions.functionInfo else {
            print("An error reading functions info json file has occured")
            return
        }
        taskImplementationVC.selectedFunctionName = FunctionNamesEnum(rawValue: functionsInfo.allFunctions[tasksListPickerView.selectedRow(inComponent: 0)].functionName)
        taskImplementationVC.pickedFunctionsSignature = functionsInfo.allFunctions[tasksListPickerView.selectedRow(inComponent: 0)]
    }
}

extension TasksListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let functionsInfo = functions.functionInfo else {
            return 0
        }
        return functionsInfo.allFunctions.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let functionsInfo = functions.functionInfo else {
            return nil
        }
        return functionsInfo.allFunctions[row].functionName
    }
}
