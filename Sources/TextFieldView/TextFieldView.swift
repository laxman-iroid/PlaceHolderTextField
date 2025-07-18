//
//  TextFieldView.swift
//  Lumity
//
//  Created by Nikunj Vaghela on 23/04/24.
//

import Foundation
import UIKit

public class TextFieldView: NibView{
    
    
//    @IBOutlet weak var requiredView: UIView!
//    
//    @IBOutlet weak var countryCodeView: UIView!
//            
//    @IBOutlet weak var countryCodeLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    public var onVisible: (() -> Void)?
    public var selectCountryCode: (() -> Void)?
    
    @IBInspectable var textFieldFontSize: CGFloat{
        get{
            return self.textField.font?.pointSize ?? 14.0
        }set{
            self.textField.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    @IBInspectable var placeHolder: String?{
        get{
            return self.placeHolderLabel.text
        }set{
            self.placeHolderLabel.text = newValue
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor?{
        get{
            return self.placeHolderLabel.textColor
        }set{
            self.placeHolderLabel.textColor = newValue
        }
    }
    
    @IBInspectable var text: String? {
        get {
            let trimmedText = self.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedText?.isEmpty == true ? "" : trimmedText
        }
        set {
            self.textField.text = newValue
        }
    }

    
    @IBInspectable var hideRightButton: Bool{
        get{
            return self.rightButton.isHidden
        }set{
            self.rightButton.isHidden = newValue
        }
    }
    
    @IBInspectable var rightImage: UIImage?{
        get{
            return self.rightButton.imageView?.image
        }set{
            self.rightButton.setImage(newValue, for: .normal)
        }
    }
    
    @IBInspectable var secureEntry: Bool{
        get{
            return self.textField.isSecureTextEntry
        }set{
            self.textField.isSecureTextEntry = newValue
        }
    }
    
    @IBInspectable var keyboardType: UIKeyboardType{
        get{
            return self.textField.keyboardType
        }set{
            self.textField.keyboardType = newValue
        }
    }
    
    @IBInspectable var delegate: UITextFieldDelegate?{
        get{
            return self.textField.delegate
        }set{
            self.textField.delegate = newValue
        }
    }
    
    @IBInspectable var returnKeyType: UIReturnKeyType{
        get{
            return self.textField.returnKeyType
        }set{
            self.textField.returnKeyType = newValue
        }
    }
    
//    @IBInspectable var isOptional: Bool{
//        get{
//            return self.requiredView.isHidden
//        }set{
//            self.requiredView.isHidden = newValue
//        }
//    }
    
//    @IBInspectable var optionalText: String{
//        get{
//            return ""
//        }set{
//            self.optionalLabel.text = newValue
//        }
//    }
    
//    @IBInspectable var optionalViewHide: Bool {
//        get {
//            return self.optionalView?.isHidden ?? true
//        }
//        set {
//            self.optionalView?.isHidden = newValue
//        }
//    }
    
//    @IBInspectable var disableCountryCode: Bool{
//        get{
//            return self.countryCodeView.isHidden
//        }set{
//            self.countryCodeView.isHidden = newValue
//        }
//    }
    
//    @IBInspectable var countryCode: String?{
//        get{
//            return self.countryCodeLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//        }set{
//            self.countryCodeLabel.text = newValue
//        }
//    }
    
    @IBInspectable var capitalization: UITextAutocapitalizationType{
        get{
            return self.textField.autocapitalizationType
        }set{
            self.textField.autocapitalizationType = newValue
        }
    }
    
    @IBInspectable var textAlignment: NSTextAlignment{
        get{
            return self.textField.textAlignment
        }set{
            self.textField.textAlignment = newValue
        }
    }
    
    @IBInspectable var isUserIntrection: Bool{
        get{
            return self.textField.isUserInteractionEnabled
        }set{
            self.textField.isUserInteractionEnabled = newValue
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            self.textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
            self.textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        }
    }
    
    public func beginEditing(){
        self.textField.becomeFirstResponder()
    }
    
    public func endEditing(){
        self.textField.resignFirstResponder()
    }
    
    public func isEmpty() -> Bool{
        return self.text?.count == 0
    }
    
    @IBAction func onVisible(_ sender: Any) {
        self.onVisible?()
    }
    
//    @IBAction func onCountryCode(_ sender: Any) {
//        self.selectCountryCode?()
//    }
    
    @MainActor @objc func textFieldDidBeginEditing() {
        UIView.animate(withDuration: 0.25) {
            self.placeHolderLabel.transform = CGAffineTransform(translationX: 0, y: -16)
            self.textField.transform = CGAffineTransform(translationX: 0, y: 4)
            self.placeHolderLabel.font = UIFont(name: "Mulish-Regular", size: 10) // Optional: make font smaller
            self.placeHolderLabel.textColor = UIColor.white
            self.mainView.layer.borderWidth = 1
        }
    }

    @MainActor @objc func textFieldDidEndEditing() {
        if let text = self.textField.text, text.isEmpty {
            UIView.animate(withDuration: 0.25) {
                self.placeHolderLabel.transform = .identity
                self.textField.transform = .identity
                self.placeHolderLabel.font = UIFont(name: "Mulish-Regular", size: 14) // Optional: reset font size
                self.placeHolderLabel.textColor = UIColor.white.withAlphaComponent(0.5)
                self.mainView.layer.borderWidth = 0
            }
        }
    }
}
