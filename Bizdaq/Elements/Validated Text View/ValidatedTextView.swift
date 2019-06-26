//
//  ValidatedTextView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ValidatedTextView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var placeholder: String?
    private var showingPlaceholder = true
    
    // Streams
    private let validatedSubject = BehaviorSubject<Bool>(value: false)
    var isValidated: Driver<Bool> { return validatedSubject.asDriver(onErrorJustReturn: false) }
    private let valueSubject = BehaviorSubject<String?>(value: nil)
    var valueDriver: Driver<String?> { return valueSubject.asDriver(onErrorJustReturn: nil) }
    private var failedSubmit: Bool = false;

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
    }
    
    override func layoutSubviews() {
        showPlaceholder(true)
    }
    
    // MARK: - Binding
    private func bind() {
        validatedSubject.subscribe(onNext: { [weak self] (validated) in
            let color = validated ? Theme.UIElements.blueBorderColor : (self!.failedSubmit ? Theme.UIElements.errorColor : Theme.UIElements.defaultBorderColor)
            self?.style(borderWidth: 1.0, borderColor: color, rounded: true)
        })
            .disposed(by: bag)
    }
    func showError(){
        showError(revalidate: false)
    }
    func showError(revalidate: Bool){
        failedSubmit = true
        if revalidate {
            validate(textView: textView)
        }
    }
    // MARK: - Private Methods
    private func validate(textView: UITextView) {
        if showingPlaceholder { validatedSubject.onNext(false); return }
        guard let text = textView.text else { return }
        validatedSubject.onNext(!text.isEmpty)
    }
    
    private func showPlaceholder(_ show: Bool) {
        showingPlaceholder = show
        if show {
            guard let placeholderText = placeholder else { return }
            textView.text = placeholderText
            textView.textColor = Theme.UIElements.placeholderTextColor
        } else {
            textView.text = nil
            textView.textColor = Theme.UIElements.defaultTextColor
        }
    }
    
    
    // MARK: - Public Methods
    func setPlaceholder(_ text: String) {
        placeholder = text
    }
    
    func setText(_ text: String?) {
        textView.text = text
        validate(textView: textView)
        valueSubject.onNext(textView.text)
    }
}

// MARK: - UITextView Delegate
extension ValidatedTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty { showPlaceholder(true) }
        validate(textView: textView)
        valueSubject.onNext(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !textView.text.isEmpty {
            guard let placeholderText = placeholder else { return true }
            if textView.text == placeholderText {
                showPlaceholder(false)
            }
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            showPlaceholder(false)
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        showError()
        if textView.text.isEmpty { showPlaceholder(false) }
        validate(textView: textView)
    }
}



