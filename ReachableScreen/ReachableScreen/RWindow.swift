//
//  RWindow.swift
//  ReachableScreen
//
//  Created by Kuanysh on 3/16/18.
//  Copyright © 2018 Kuanysh. All rights reserved.
//

import UIKit

public class RWindow: UIWindow {
    var force: Bool = false
    var circle: UIView!
    var finger: UIView!
    var box: UIImageView!
    var firstTouch: CGPoint!
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    var fullscreen: Bool!
    var view: UIView!
    public func load(fullscreen full: Bool) {
        self.fullscreen = full
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        addSubview(view)
        circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 10
        circle.backgroundColor = UIColor.black
        circle.alpha = 0.4
        circle.clipsToBounds = true
        circle.isHidden = true
        self.view.addSubview(circle)
        finger = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        finger.center = self.view.center
        finger.layer.cornerRadius = 25
        finger.backgroundColor = UIColor.black
        finger.alpha = 0.2
        finger.clipsToBounds = true
        finger.isHidden = true
        self.view.addSubview(finger)
        if (fullscreen) {
            box = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: width * 0.5, height: height * 0.5))
        } else {
            box = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height * 0.2))
        }
        box.center = self.view.center
        box.alpha = 1
        box.clipsToBounds = true
        box.isHidden = true
        self.view.addSubview(box)
    }
    
    override public func sendEvent(_ event: UIEvent) {
        if event.type == .touches {
            if let count = event.allTouches?.filter({ $0.phase == .began }).count, count > 0 {
                touchesBegan(event.allTouches!)
                super.sendEvent(event)
            }
            if let count = event.allTouches?.filter({ $0.phase == .moved }).count, count > 0 {
                touchesMoved(event.allTouches!)
                if (!force){
                    super.sendEvent(event)
                }
            }
            if let count = event.allTouches?.filter({ $0.phase == .ended }).count, count > 0 {
                touchesEnded(event.allTouches!)
                super.sendEvent(event)
            }
            if let count = event.allTouches?.filter({ $0.phase == .cancelled }).count, count > 0 {
                super.sendEvent(event)
            }
        }
    }
    
    
    
    func touchesBegan(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            firstTouch = touch.location(in: self.view)
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            let point = touch.location(in: self.view)
            finger.isHidden = true
            finger.center = CGPoint(x: point.x, y: point.y)
            if (touch.force/touch.maximumPossibleForce > 0.3 && !force){
                force = true
                if (fullscreen) {
                    box.center = CGPoint(x: point.x, y: point.y)
                    box.image = UIApplication.shared.screenShot
                } else {
                    box.center = CGPoint(x: width/2, y: point.y + 25)
                    let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height * 0.2)
                    box.image = UIApplication.shared.screenShot?.cropImage(cropRect: rect)
                }
                box.dropShadow()
                box.isHidden = false
                circle.isHidden = false
                finger.alpha = 0.7
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            } else {
                finger.alpha = 0.2
            }
            if (force) {
                let p2 = touch.location(in: self.box)
                if (fullscreen) {
                    circle.center = CGPoint(x: p2.x/0.5, y: p2.y/0.5)
                } else {
                    circle.center = CGPoint(x: p2.x, y: p2.y )
                }
            }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>) {
        if (force) {
            detectViewSelected(point: circle.center)?.sendActions(for: .touchUpInside)
            touchHandler(circle.center)
        }
        force = false
        circle.isHidden = true
        finger.isHidden = true
        box.isHidden = true
    }
    
    public var touchHandler: (_ point: CGPoint) -> () = {_ in
        
    }
    
    func detectViewSelected(point: CGPoint) -> UIButton? {
        for view in UIApplication.shared.topMostViewController()!.view.subviews {
            if let btn = view as? UIButton {
                if (btn.frame.maxX>=point.x && btn.frame.minX<=point.x && btn.frame.maxY>=point.y && btn.frame.minY<=point.y){
                    return btn
                }
            }
        }
        return nil
    }
}

