//
//  TGLExpandingButton.swift
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

public class TGLExpandingButton: UIControl {

    @objc public enum ExpandMode: Int {

        case right = 0
        case left
        case down
        case up
    }
    
    public var animationOptions: UIViewAnimationOptions = []

    @IBInspectable public var animationDuration: TimeInterval = 0.25
    @IBInspectable public var springDampingRation: CGFloat = 0.75
    @IBInspectable public var springInitialVelocity: CGFloat = 1.0

    @IBInspectable public var spacing: CGFloat = 0.0
    
    public var isExpanded: Bool = false {
        
        didSet {
            
            self.setNeedsLayout()
        }
    }

    public func setExpanded(_ expanded: Bool, animated: Bool) {
        
        self.isExpanded = expanded
        
        UIView.animate(withDuration: (animated ? self.animationDuration : 0.0), delay: 0.0, usingSpringWithDamping: self.springDampingRation, initialSpringVelocity: self.springInitialVelocity, options: self.animationOptions, animations: { self.updateLayout() }, completion: nil)
    }
    
    @IBInspectable public var expandMode: ExpandMode = .right {
        
        didSet {
            
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var selectedIndex: Int = 0 {
        
        didSet {

            self.setNeedsLayout()
        }
    }
    
    fileprivate(set) public var buttons: Array<UIButton> = []
    
    public override func didAddSubview(_ subview: UIView) {
        
        super.didAddSubview(subview)
        
        if let button = subview as? UIButton {
         
            self.buttons.append(button)
            
            button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        
        super.willRemoveSubview(subview)
        
        if let button = subview as? UIButton, let idx = self.buttons.index(of: button) {
            
            self.buttons.remove(at: idx)
            
            button.removeTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Layout

    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.updateLayout()
    }
    
    private func updateLayout() {
        
        if !self.isExpanded {
            
            switch self.expandMode {
                
            case .right:
                
                var frame = self.frame
                
                frame.size.width = self.buttons[self.selectedIndex].frame.size.width
                self.frame = frame
                
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;
                    
                    frame.origin.x = 0;
                    
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
                
            case .left:
                
                var frame = self.frame
                
                frame.origin.x = frame.maxX - self.buttons[self.selectedIndex].frame.size.width
                frame.size.width = self.buttons[self.selectedIndex].frame.size.width
                self.frame = frame
                
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;
                    
                    frame.origin.x = self.frame.size.width - frame.size.width;
                    
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
                
            case .down:
            
                var frame = self.frame
                
                frame.size.height = self.buttons[self.selectedIndex].frame.size.height
                self.frame = frame
                
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;
                    
                    frame.origin.y = 0;
                    
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
                
            case .up:
                
                var frame = self.frame
                
                frame.origin.y = frame.maxY - self.buttons[self.selectedIndex].frame.size.height
                frame.size.height = self.buttons[self.selectedIndex].frame.size.height
                self.frame = frame
                
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;
                    
                    frame.origin.y = self.frame.size.height - frame.size.height;
                    
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
            }

        } else {
            
            switch self.expandMode {
            
            case .right:
    
                var offset: CGFloat = 0.0
        
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;
                    
                    frame.origin.x = offset;
                    
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    
                    offset += frame.size.width + self.spacing
                }
                
                var frame = self.frame
                
                frame.size.width = offset - self.spacing
                self.frame = frame
                
            case .left:
                
                var offset: CGFloat = self.buttons.reduce(0.0) { return $0 + $1.frame.size.width } + self.spacing * CGFloat(self.buttons.count - 1)
                var frame = self.frame
                
                frame.origin.x = frame.maxX - offset
                frame.size.width = offset
                self.frame = frame
                
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;

                    frame.origin.x = offset - frame.size.width;
                    
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    
                    offset -= frame.size.width + self.spacing
                }
                
            case .down:
                
                var offset: CGFloat = 0.0
                
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;
                    
                    frame.origin.y = offset;
                    
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    
                    offset += frame.size.height + self.spacing
                }
                
                var frame = self.frame
                
                frame.size.height = offset - self.spacing
                self.frame = frame
                
            case .up:
                
                var offset: CGFloat = self.buttons.reduce(0.0) { return $0 + $1.frame.size.height } + self.spacing * CGFloat(self.buttons.count - 1)
                var frame = self.frame
                
                frame.origin.y = frame.maxY - offset
                frame.size.height = offset
                self.frame = frame
                
                for (index, button) in self.buttons.enumerated() {
                    
                    var frame = button.frame;
                    
                    frame.origin.y = offset - frame.size.height;
                    
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    
                    offset -= frame.size.height + self.spacing
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func buttonTapped(_ sender: UIButton) {
        
        if let sndidx = self.buttons.index(of: sender) {
            
            self.isExpanded = !self.isExpanded
            
            if !self.isExpanded {
                
                self.selectedIndex = sndidx
                self.sendActions(for: .valueChanged)
            }
        
            UIView.animate(withDuration: self.animationDuration, delay: 0.0, usingSpringWithDamping: self.springDampingRation, initialSpringVelocity: self.springInitialVelocity, options: self.animationOptions, animations: { self.updateLayout() }, completion: nil)
        }
    }
}
