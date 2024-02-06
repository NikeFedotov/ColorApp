//
//  ViewController.swift
//  ColorApp
//
//  Created by Никита on 22.01.2024.
//

import UIKit

protocol SecondViewControllerDelegate: AnyObject {
    func changeColor(_ color: UIColor)
}

final class SecondViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTF: UITextField!
    @IBOutlet weak var greenTF: UITextField!
    @IBOutlet weak var blueTF: UITextField!
    
    var color: UIColor!
    
    weak var delegate: SecondViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @IBAction func sliderPressed(_ sender: UISlider) {
        setupBackgroundColor(for: mainView)
        
        switch sender {
        case redSlider:
            setValue(for: redLabel)
            setValue(for: redTF)
        case greenSlider:
            setValue(for: greenLabel)
            setValue(for: greenTF)
        default:
            setValue(for: blueLabel)
            setValue(for: blueTF)
        }
    }
    
    @IBAction func doneButtonPressed() {
        delegate.changeColor(mainView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    
}

//MARK: - Extension VC

extension SecondViewController {
    private func setupBackgroundColor(for someView: UIView) {
        someView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1)
    }
    
    func setupMainView() {
        mainView.backgroundColor = color
        
        setValue(for: redSlider, greenSlider, blueSlider)
        setValue(for: redTF, greenTF, blueTF)
        setValue(for: redLabel, greenLabel, blueLabel)
        
        mainView.layer.cornerRadius = 15
    }
    
    private func setValue(for lables: UILabel...) {
        lables.forEach{ lable in
            switch lable {
            case redLabel: lable.text = string(from: redSlider)
            case greenLabel: lable.text = string(from: greenSlider)
            default: lable.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redTF: textField.text = string(from: redSlider)
            case greenTF: textField.text = string(from: greenSlider)
            default: textField.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for colorSliders: UISlider...) {
        let ciColor = CIColor(color: color)
        colorSliders.forEach { colorSlider in
            switch colorSlider {
            case redSlider: colorSlider.value = Float(ciColor.red)
            case greenSlider: colorSlider.value = Float(ciColor.green)
            default: colorSlider.value = Float(ciColor.blue)
            }
        }
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension SecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            showAlert(withTitle: "Wrong format!", andMessage: "Please enter correct message")
            return
        }
        
        guard let currentValue = Float(text), (0...1).contains(currentValue) else {
            showAlert(withTitle: "Wrong format!", andMessage: "Please enter correct message")
            return
        }
        
        switch textField {
        case redTF:
            redSlider.setValue(currentValue, animated: true)
            setValue(for: redLabel)
        case greenTF:
            greenSlider.setValue(currentValue, animated: true)
            setValue(for: greenLabel)
        default:
            blueSlider.setValue(currentValue, animated: true)
            setValue(for: greenLabel)
        }
        
        setupBackgroundColor(for: mainView)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}

