//
//  ViewController.swift
//  MVVMBinding Example
//
//  Created by Ivan Foong on 29/11/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import UIKit

protocol ViewModelProtocol {
    var textFieldText: Observable<String?> { get set }
    var buttonText: Observable<String?> { get set }
    func start()
    func pause()
    func buttonTapped()
    func reset(with newInitialSecondsRemaining: Int)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    private var viewModel: ViewModelProtocol = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(textField:)), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(textFieldDidEndEditing(textField:)), for: .editingDidEnd)
        self.bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.pause()
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if self.textField.isEditing {
            self.textField.resignFirstResponder()
        }
        self.viewModel.buttonTapped()
    }
    
    @objc func textFieldDidBeginEditing(textField: UITextField) {
        if let text = textField.text, let initialSecondsRemaining = Int(text) {
            self.viewModel.reset(with: initialSecondsRemaining)
        } else {
            self.viewModel.reset(with: 0)
        }
    }
    
    @objc func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text, let initialSecondsRemaining = Int(text) {
            self.viewModel.reset(with: initialSecondsRemaining)
        }
    }
    
    private func bindUI() {
        self.viewModel.buttonText.bind(for: self, initialFire: true) { text in
            self.button.setTitle(text, for: .normal)
        }
        self.viewModel.textFieldText.bind(for: self, initialFire: true) { text in
            self.textField.text = text
        }
    }
}

