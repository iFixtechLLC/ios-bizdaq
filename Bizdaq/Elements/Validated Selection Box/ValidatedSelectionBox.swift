//
//  ValidatedSelectionBox.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ValidatedSelectionBox: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var contentView: UIView?
    var value: String? { return textField.text }
    private var options: [String]?
    var pickerView: UIPickerView!
    
    // Streams
    private let validatedSubject = BehaviorSubject<Bool>(value: false)
    var isValidatedDriver: Driver<Bool> { return validatedSubject.asDriver(onErrorJustReturn: false) }
    private let valueSubject = BehaviorSubject<String?>(value: nil)
    var valueDriver: Driver<String?> { return valueSubject.asDriver(onErrorJustReturn: nil) }
    
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
        setupPickerView()
    }
    
    private func setupPickerView() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didPressDonePickerButton))
        pickerView = Utility.addPickerView(to: textField, with: doneButton)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // MARK: - Binding
    private func bind() {
        validatedSubject.subscribe(onNext: { [weak self] (validated) in
            //let color = validated ? Theme.UIElements.blueBorderColor : Theme.UIElements.defaultBorderColor
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
        guard let text = textField.text else { return }
        validatedSubject.onNext(!text.isEmpty)
    }
    
    // MARK: - Public Methods
    func setText(_ text: String) {
        textField.text = text
        validate(textField: textField)
        valueSubject.onNext(text)
    }
    
    func setPlaceholder(_ placeholderString: String) {
        textField.placeholder = placeholderString
    }
    
    func setOptions(_ options: [String]) {
        self.options = options
    }
    
    // MARK: - Actions
    @objc private func didPressDonePickerButton() {
        textField.endEditing(true)
    }
}

// MARK: - UITextField Delegate
extension ValidatedSelectionBox: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        arrowImageView.image = Theme.UIElements.upArrowImage
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        arrowImageView.image = Theme.UIElements.downArrowImage
        validate(textField: textField)
    }
}

// MARK: - Picker Delegate & Data Source
extension ValidatedSelectionBox: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let options = options else { return 0 }
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let options = options else { return nil }
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let options = options else { return }
        setText(options[row])
    }
}
