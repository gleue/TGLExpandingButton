//
//  ViewController.swift
//  TGLExpandingButton
//
//  Created by Tim Gleue on 01.03.17.
//  Copyright © 2017 Tim Gleue • interactive software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var modeButton: TGLExpandingButton!
    
    @IBOutlet weak var sizeButton: TGLExpandingButton!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var leftButton: TGLExpandingButton!
    @IBOutlet weak var downButton: TGLExpandingButton!
    @IBOutlet weak var upButton: TGLExpandingButton!
    
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var dampingSlider: UISlider!
    
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        get { return .lightContent }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.leftButton.expandMode = .left
        self.downButton.expandMode = .down
        self.upButton.expandMode = .up
        
        self.upButton.layer.borderColor = UIColor.black.cgColor
        self.upButton.layer.borderWidth = 1
        
        self.updateSizeLabel(fromButton: self.sizeButton)
        
        self.updateDamping(fromSlider: self.dampingSlider)
        self.updateVelocity(fromSlider: self.velocitySlider)
    }

    // MARK: - Actions

    @IBAction func valueChanged(_ sender: TGLExpandingButton) {
        
        if sender === self.sizeButton {
            
            self.updateSizeLabel(fromButton: sender)
        }
    }

    @IBAction func dampingChanged(_ sender: UISlider) {
        
        self.updateDamping(fromSlider: sender)
    }
    
    @IBAction func velocityChanged(_ sender: UISlider) {
        
        self.updateVelocity(fromSlider: sender)
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        self.modeButton.setExpanded(false, animated: true)
        self.sizeButton.setExpanded(false, animated: true)
        self.leftButton.setExpanded(false, animated: true)
        self.downButton.setExpanded(false, animated: true)
        self.upButton.setExpanded(false, animated: true)
    }
    
    // MARK: - Helpers

    func updateSizeLabel(fromButton button: TGLExpandingButton) {
        
        self.sizeLabel.text = NSLocalizedString("Size: ", comment: "") + button.buttons[button.selectedIndex].title(for: .normal)!
    }
    
    func updateDamping(fromSlider slider: UISlider) {
        
        self.dampingLabel.text = NSLocalizedString("Damping: ", comment: "") + NumberFormatter.localizedString(from: NSNumber(value: slider.value), number: .percent)
        
        self.modeButton.springDampingRation = CGFloat(slider.value)
        self.sizeButton.springDampingRation = CGFloat(slider.value)
        self.leftButton.springDampingRation = CGFloat(slider.value)
        self.downButton.springDampingRation = CGFloat(slider.value)
        self.upButton.springDampingRation = CGFloat(slider.value)
    }
    
    func updateVelocity(fromSlider slider: UISlider) {
        
        self.velocityLabel.text = NSLocalizedString("Velocity: ", comment: "") + NumberFormatter.localizedString(from: NSNumber(value: slider.value), number: .percent)

        self.modeButton.springInitialVelocity = CGFloat(slider.value)
        self.sizeButton.springInitialVelocity = CGFloat(slider.value)
        self.leftButton.springInitialVelocity = CGFloat(slider.value)
        self.downButton.springInitialVelocity = CGFloat(slider.value)
        self.upButton.springInitialVelocity = CGFloat(slider.value)
    }
}

