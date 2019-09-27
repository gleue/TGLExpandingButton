//
//  TGLExpandingButton.swift
//  TGLExpandingButton
//
//  Created by Tim Gleue on 01.03.17.
//  Copyright © 2017-2019 Tim Gleue ( http://gleue-interactive.com )
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

/** A control that expands and collapses when one of its UIButton subviews is tapped.
 
    `TGLExpandingButton` itself has no visual representation. To use it in your code
    add UIButton subviews to it and style them as you like. When collapsed only the
    currently selected button is visible. When tapped the control expands and all other
    buttons are shown. Tapping the selected button or one of the unselected buttons
    changes the control's value `selectedIndex` and collapses it again, leaving only
    the newly selected button visible.
 
    The direction the control expands to may be controlled via the `expandMode` property.
    To receive message when a button is selected either add target actions to the individual
    buttons or associate a target action with the `valueChanged` control event of `TGLExpandingButton`.
 
    The currently selected button index is kept in property `selectedIndex`. It's the
    selected button's index in property `buttons` array of button subviews. The currently
    selected button has control state `selected`.
 
    If you are using Autolayout make sure to add constraints defining width and height
    of the button subviews as well as the axis perpendicular to the control's `expandMode`.
    Do NOT add constraints defining control's size parallel to the axis of expansion.
 
    For animation options see `animate(withDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)`.
 */
public class TGLExpandingButton: UIControl {

    /// The way the control expands when tapped.
    ///
    /// * `right` Expand horizontally to right.
    /// * `left`  Expand horizontally to left.
    /// * `down`  Expand downwards.
    /// * `up`    Expand upwards.
    @objc public enum ExpandMode: Int {
        case right = 0
        case left
        case down
        case up
    }
    
    /// Options passed to the animation function when expanding or collapsing buttons
    @objc public var animationOptions: UIView.AnimationOptions = []
    /// Duration of the expand or collapse animation, measured in seconds.
    @IBInspectable public var animationDuration: TimeInterval = 0.25
    /// Spring damping for the expand or collapse animation.
    @IBInspectable public var springDampingRation: CGFloat = 0.75
    /// Initial spring velocity for the expand or collapse animation.
    @IBInspectable public var springInitialVelocity: CGFloat = 1.0

    /// The amount of spacing between buttons when expanded.
    @IBInspectable public var spacing: CGFloat = 0.0

    /// Private property keeping track of the expanded state.
    private var _isExpanded: Bool = false

    /// Indicates whether the control is expanded (`true`) or collapsed (`false`).
    ///
    /// Setting this property will change the control's state without animating the transition.
    @objc public var isExpanded: Bool {
        get { return _isExpanded }
        set { self.setExpanded(newValue, animated: false) }
    }

    /// Expands or collapses the control optionally animating the transition.
    /// - parameter expanded: Pass `true` for expanded state or `false` for collapsed.
    /// - parameter animated: If `true` the transition will be animated.
    @objc public func setExpanded(_ expanded: Bool, animated: Bool) {
        self._isExpanded = expanded
        
        UIView.animate(withDuration: (animated ? self.animationDuration : 0.0),
                       delay: 0.0,
                       usingSpringWithDamping: self.springDampingRation,
                       initialSpringVelocity: self.springInitialVelocity,
                       options: self.animationOptions,
                       animations: { self.updateLayout() },
                       completion: nil)
    }

    /// The direction of expansion when tapped.
    @IBInspectable public var expandMode: ExpandMode = .right {
        didSet {
            self.setupFrame()
            self.setNeedsLayout()
        }
    }
    
    /// The currently selected button index in the `buttons` property.
    ///
    /// Setting this property will change the control's state without animating the transition.
    @IBInspectable public var selectedIndex: Int = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// The list of button subviews used by this control.
    ///
    /// Property `selectedIndex` denotes the currently selected button.
    @objc private(set) public var buttons: Array<UIButton> = []

    /// The layout constraint controlling the overall width for modes
    /// `left` and `right` and height for modes `up` and `down`.
    private var axisConstraint: NSLayoutConstraint!

    // MARK: - Subview handling
    
    /// Adds new UIButton subview to the internal list of buttons and attach a private target action to handle tapping it.
    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        if let button = subview as? UIButton {
            self.buttons.append(button)
            button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        }
        self.updateFrame()
        self.setNeedsLayout()
    }
    
    /// Removes UIButton subview from the internal list of buttons and detach private target action.
    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        if let button = subview as? UIButton, let idx = self.buttons.firstIndex(of: button) {
            self.buttons.remove(at: idx)
            button.removeTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        }
        self.updateFrame()
        self.setNeedsLayout()
    }
    
    // MARK: - Layout

    /// Lays out subviews.
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateButtons()
    }

    /// Resizes the control and layouts its buttons depending on the
    /// current expansion mode and state.
    private func updateLayout() {
        self.updateFrame()
        self.updateButtons()
    }

    /// Sets up the layout constraint for controlling the width in modes
    /// `left` and `right` and height in modes `up` and `down`.
    private func setupFrame() {
        if let constraint = self.axisConstraint { self.removeConstraint(constraint) }
        switch self.expandMode {
        case .left, .right:
            self.axisConstraint = self.widthAnchor.constraint(equalToConstant: self.frame.width)
        case .up, .down:
            self.axisConstraint = self.heightAnchor.constraint(equalToConstant: self.frame.height)
        }
        self.axisConstraint!.isActive = true
    }

    /// Updates the control's frame size and origin depending on current mode and state.
    private func updateFrame() {
        if self.axisConstraint == nil { self.setupFrame() }

        if self.isExpanded {
            var frame = self.frame

            switch self.expandMode {
            case .right:
                // The resulting right border of the last button
                // defines the control's new total width, while
                // keeping it's left border fixed
                //
                let width = self.buttons.reduce(0.0) { return $0 + $1.frame.width + self.spacing } - self.spacing

                frame.size.width = width
                self.axisConstraint!.constant = width

            case .left:
                // The control's new left border is defined by the total
                // width of all buttons spread out horizontally, while
                // keeping it's right border fixed
                //
                let width = self.buttons.reduce(0.0) { return $0 + $1.frame.width + self.spacing } - self.spacing

                frame.origin.x = frame.maxX - width
                frame.size.width = width
                self.axisConstraint!.constant = width

            case .down:
                // The resulting bttom border of the last button
                // defines the control's new total height, while
                // keeping it's top border fixed
                //
                let height = self.buttons.reduce(0.0) { return $0 + $1.frame.height + self.spacing } - self.spacing

                frame.size.height = height
                self.axisConstraint!.constant = height

            case .up:
                // The control's new top border is defined by the total
                // height of all buttons spread out vertically, while
                // keeping it's bottom border fixed
                //
                let height = self.buttons.reduce(0.0) { return $0 + $1.frame.height + self.spacing } - self.spacing

                frame.origin.y = frame.maxY - height
                frame.size.height = height
                self.axisConstraint!.constant = height
            }
            self.frame = frame
        } else {
            var frame = self.frame

            switch self.expandMode {
            case .right:
                // Own width is equal to selected button's
                // but left border of control is untouched
                //
                frame.size.width = self.buttons[self.selectedIndex].frame.size.width
                self.axisConstraint!.constant = frame.width

            case .left:
                // Own width is equal to selected button's
                // but right border of control is untouched
                //
                frame.origin.x = frame.maxX - self.buttons[self.selectedIndex].frame.size.width
                frame.size.width = self.buttons[self.selectedIndex].frame.size.width
                self.axisConstraint!.constant = frame.width

            case .down:
                // Own height is equal to selected button's
                // but top border of control is untouched
                //
                frame.size.height = self.buttons[self.selectedIndex].frame.size.height
                self.axisConstraint!.constant = frame.height

            case .up:
                // Own height is equal to selected button's
                // but bottom border of control is untouched
                //
                frame.origin.y = frame.maxY - self.buttons[self.selectedIndex].frame.size.height
                frame.size.height = self.buttons[self.selectedIndex].frame.size.height
                self.axisConstraint!.constant = frame.height
            }
            self.frame = frame
        }
    }

    // Updates the button layout depending on current mode and state.
    private func updateButtons() {
        if !self.isExpanded {
            // Collapsed
            //
            switch self.expandMode {
                
            case .right:
                // All button subviews are aligned to control's
                // left border. Un-selected buttons are hidden
                //
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;
                    
                    frame.origin.x = 0;
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
                
            case .left:
                // All button subviews are aligned to control's
                // right border. Un-selected buttons are hidden
                //
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;
                    
                    frame.origin.x = self.frame.size.width - frame.size.width;
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
                
            case .down:
                // All button subviews are aligned to control's
                // top border. Un-selected buttons are hidden
                //
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;
                    
                    frame.origin.y = 0;
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
                
            case .up:
                // All button subviews are aligned to control's
                // bottom border. Un-selected buttons are hidden
                //
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;
                    
                    frame.origin.y = self.frame.size.height - frame.size.height;
                    button.frame = frame
                    button.alpha = (index == self.selectedIndex) ? 1.0 : 0.0
                    button.isSelected = (index == self.selectedIndex)
                }
            }
        } else {
            // Expanded
            //
            switch self.expandMode {
            case .right:
                // All button subviews are lined-up horizontally from
                // the control's left border to the right
                //
                var width: CGFloat = 0.0
        
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;
                    
                    frame.origin.x = width;
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    width += frame.size.width + self.spacing
                }

            case .left:
                // The control's new left border is defined by the total
                // width of all buttons spread out horizontally, while
                // keeping it's right border fixed
                //
                var width = self.buttons.reduce(0.0) { return $0 + $1.frame.size.width + self.spacing } - self.spacing

                // All button subviews are lined-up horizontally from
                // the control's right border to the left
                //
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;

                    frame.origin.x = width - frame.size.width;
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    width -= frame.size.width + self.spacing
                }
                
            case .down:
                // All button subviews are lined-up vertically from
                // the control's top border downwards
                //
                var height: CGFloat = 0.0
                
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;
                    
                    frame.origin.y = height;
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    height += frame.size.height + self.spacing
                }

            case .up:
                // The control's new top border is defined by the total
                // height of all buttons spread out vertically, while
                // keeping it's bottom border fixed
                //
                var height = self.buttons.reduce(0.0) { return $0 + $1.frame.size.height + self.spacing } - self.spacing

                // All button subviews are lined-up vertically from
                // the control's bottom border upwards
                //
                for (index, button) in self.buttons.enumerated() {
                    var frame = button.frame;
                    
                    frame.origin.y = height - frame.size.height;
                    button.frame = frame
                    button.alpha = 1.0
                    button.isSelected = (index == self.selectedIndex)
                    height -= frame.size.height + self.spacing
                }
            }
        }
    }
    
    // MARK: - Actions
    
    /// Private handler for `touchUpInside` events generated by button subviews
    @IBAction private func buttonTapped(_ sender: UIButton) {
        if let index = self.buttons.firstIndex(of: sender) {
            if self.isExpanded {
                self.selectedIndex = index
                self.sendActions(for: .valueChanged)
            }
            self.setExpanded(!self.isExpanded, animated: true)
        }
    }
}
