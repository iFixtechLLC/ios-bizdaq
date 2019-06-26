//
//  TextEntryBox.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 08/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ValidatedTextField: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearImage: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var constrainToEdge: NSLayoutConstraint?
    
    // MARK: - Properties
    private let bag = DisposeBag()
    
    var amountTypedString = ""
    
    // Streams
    private let validatedSubject = BehaviorSubject<Bool>(value: false)
    var isValidatedDriver: Driver<Bool> { return validatedSubject.asDriver(onErrorJustReturn: false) }
    private let valueSubject = BehaviorSubject<String?>(value: nil)
    var valueDriver: Driver<String?> { return valueSubject.asDriver(onErrorJustReturn: nil) }
    private let clearedSubject = BehaviorSubject<Void>(value: ())
    var clearedDriver: Driver<Void> { return clearedSubject.asDriver(onErrorJustReturn: ()) }
    
    private var validationRegex: String?
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        xibSetup()
        bind()
        setImage(nil)
        setRightImage(nil)
    }
    
    override func layoutSubviews() {
        constrainToEdge?.isActive = imageView.image == nil
    }
    
    // MARK: - Binding
    private func bind() {
        validatedSubject.subscribe(onNext: { [weak self] (validated) in
            let color = validated ? Theme.UIElements.blueBorderColor : (self!.failedSubmit ? Theme.UIElements.errorColor : Theme.UIElements.defaultBorderColor)
            self?.style(borderWidth: 1.0, borderColor: color, rounded: true)
        })
        .disposed(by: bag)
    }
    private var failedSubmit: Bool = false;

    func showError(){
        showError(revalidate: false)
    }
    func showError(revalidate: Bool){
        failedSubmit = true
        if revalidate {
            validate(textField: textField)
        }
    }
    // MARK: - Private Methods
    private func validate(textField: UITextField) {
        guard let regex = validationRegex else { validatedSubject.onNext(false); return }
        guard let text = textField.text else { validatedSubject.onNext(false); return }
        guard !text.isEmpty else { validatedSubject.onNext(false); return }
        validatedSubject.onNext(text.matches(predicate: regex))
    }
    
    // MARK: - Public Methods
    func setValidationRegex(_ regexString: String) {
        validationRegex = regexString
    }
    
    func setPlaceholder(_ placeholderString: String) {
        textField.placeholder = placeholderString
    }
    
    func setSecureText(_ secure: Bool) {
        textField.isSecureTextEntry = secure
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = imageView.image == nil
    }
    
    func setRightImage(_ image: UIImage?) {
        rightImageView.image = image
        rightImageView.isHidden = rightImageView.image == nil
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    func setText(_ text: String?) {
        textField.text = text
        clearImage.isHidden = textField.text?.isEmpty ?? true
        rightImageView.isHidden = true
        validate(textField: textField)
        valueSubject.onNext(textField.text)
    }
    
    // MARK: - Actions
    @IBAction func didPressClearButton() {
        clearImage.isHidden = true
        rightImageView.isHidden = rightImageView.image == nil
        textField.text = nil
        textField.endEditing(true)
        validate(textField: textField)
        valueSubject.onNext(nil)
        clearedSubject.onNext(())
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        clearImage.isHidden = sender.text?.isEmpty ?? true
        rightImageView.isHidden = (rightImageView.image == nil && !clearImage.isHidden)
        showError()
        validate(textField: sender)
        valueSubject.onNext(sender.text)
    }
}

// MARK: - Text Field Delegate
extension ValidatedTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}

// MARK: - Styles
extension ValidatedTextField {
    
    func applyCurrencyStyle() {
        setImage(Theme.Icons.currencyIcon)
        setKeyboardType(.decimalPad)
        setValidationRegex(Constants.Validation.anyCharactersRegex)
    }
}
