//
//  ViewModel.swift
//  MVVMBinding Example
//
//  Created by Ivan Foong on 29/11/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import Foundation

class ViewModel: ViewModelProtocol {
    var textFieldText: Observable<String?> = Observable("")
    var buttonText: Observable<String?> = Observable("")
    
    private var state: ViewModelState {
        if let timer = self.timer, timer.isValid {
            return .timerStarted
        } else if self.isPaused {
            return .timerPaused
        } else {
            return .timerStopped
        }
    }
    
    private var secondsRemaining: Int {
        didSet {
            self.updateOutput()
        }
    }
    private var initialSecondsRemaining: Int
    private var timer: Timer? {
        didSet {
            self.updateOutput()
        }
    }
    private var isPaused = false {
        didSet {
            self.updateOutput()
        }
    }
    
    init(initialSecondsRemaining: Int) {
        self.initialSecondsRemaining = initialSecondsRemaining
        self.secondsRemaining = self.initialSecondsRemaining
        self.textFieldText.value = String(self.secondsRemaining)
        self.buttonText.value = self.buttonText(for: .timerStopped)
    }
    
    convenience init() {
        self.init(initialSecondsRemaining: 10)
    }
    
    func buttonTapped() {
        switch self.state {
        case .timerStarted:
            self.pause()
        case .timerPaused:
            self.start()
        case .timerStopped:
            self.reset(with: self.initialSecondsRemaining)
            self.start()
        }
    }
    
    func start() {
        self.isPaused = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.isPaused = false
        self.secondsRemaining = self.initialSecondsRemaining
        print("stopped")
    }
    
    func pause() {
        self.timer?.invalidate()
        self.isPaused = true
    }
    
    func reset(with newInitialSecondsRemaining: Int) {
        self.initialSecondsRemaining = newInitialSecondsRemaining
        self.secondsRemaining = self.initialSecondsRemaining
        self.stop()
    }
    
    private func tick() {
        print("tick")
        switch self.state {
        case .timerStarted:
            self.secondsRemaining = self.secondsRemaining - 1
            if self.secondsRemaining <= 0 {
                self.stop()
            }
        default:
            return
        }
    }
    
    private func buttonText(for state: ViewModelState) -> String {
        switch state {
        case .timerStarted:
            return "Pause"
        case .timerPaused:
            return "Resume"
        case .timerStopped:
            return "Start"
        }
    }
    
    private func updateOutput() {
        print("updateOutput")
        self.textFieldText.value = String(self.secondsRemaining)
        self.buttonText.value = self.buttonText(for: self.state)
    }
}
