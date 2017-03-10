//
//  ViewController.swift
//  TGLExpandingButton
//
//  Created by Tim Gleue on 01.03.17.
//  Copyright © 2017 Tim Gleue ( http://gleue-interactive.com )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var modeButton: TGLExpandingButton!
    
    @IBOutlet weak var sizeButton: TGLExpandingButton!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var colorButton: TGLExpandingButton!
    @IBOutlet weak var colorLabel: UILabel!

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
        
        self.colorButton.expandMode = .left
        self.downButton.expandMode = .down
        self.upButton.expandMode = .up
        
        self.upButton.layer.borderColor = UIColor.black.cgColor
        self.upButton.layer.borderWidth = 1
        
        self.updateSizeLabel(fromButton: self.sizeButton)
        self.updateColorLabel(fromButton: self.colorButton)

        self.updateDamping(fromSlider: self.dampingSlider)
        self.updateVelocity(fromSlider: self.velocitySlider)
    }

    // MARK: - Actions

    // Option 1: Handle individual buttons' `touchUpInside` actions
    //
    @IBAction func colorButtonTapped(_ sender: Any) {

        // Since this method is called on expand AND collapse
        // make sure we only handle the latter case, i.e.
        // wehn the actual selection took place
        //
        if !colorButton.isExpanded {
            
            self.updateColorLabel(fromButton: self.colorButton)
        }
    }
    
    // Option 2: Handle control's `valueChanged` event
    //
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

    // Convenience: Close any expanded button on background tap
    //
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        for view in self.view.subviews {
            
            if let button = view as? TGLExpandingButton {
                
                button.setExpanded(false, animated: true)
            }
        }
    }
    
    // MARK: - Helpers

    func updateSizeLabel(fromButton button: TGLExpandingButton) {
        
        self.sizeLabel.text = NSLocalizedString("Size: ", comment: "") + button.buttons[button.selectedIndex].title(for: .normal)!
    }
    
    func updateColorLabel(fromButton button: TGLExpandingButton) {
        
        self.colorLabel.text = NSLocalizedString("Color: ", comment: "") + button.buttons[button.selectedIndex].title(for: .normal)!
    }
    
    func updateDamping(fromSlider slider: UISlider) {
        
        self.dampingLabel.text = NSLocalizedString("Damping: ", comment: "") + NumberFormatter.localizedString(from: NSNumber(value: slider.value), number: .percent)

        for view in self.view.subviews {
            
            if let button = view as? TGLExpandingButton {
                
                button.springDampingRation = CGFloat(slider.value)
            }
        }
    }
    
    func updateVelocity(fromSlider slider: UISlider) {
        
        self.velocityLabel.text = NSLocalizedString("Velocity: ", comment: "") + NumberFormatter.localizedString(from: NSNumber(value: slider.value), number: .decimal)
        
        for view in self.view.subviews {
            
            if let button = view as? TGLExpandingButton {
                
                button.springInitialVelocity = CGFloat(slider.value)
            }
        }
    }
}

