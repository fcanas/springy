//
//  SpringyView.swift
//  Springs
//
//  Created by Fabian Canas on 10/2/15.
//  Copyright © 2015 Fabián Cañas. All rights reserved.
//

import UIKit

class SpringyView: UIView {

    var shapeLayer :CAShapeLayer = CAShapeLayer()
    
    var link :CADisplayLink?
    var animator :UIDynamicAnimator?
    
    var innerRadius :CGFloat = -80.0
    var outerRadius :CGFloat = 80.0
    
    var weightView :UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildAndGo()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildAndGo()
    }
    
    func buildAndGo() {
        self.backgroundColor = .blackColor()
        layer.addSublayer(shapeLayer)
        
        buildAnimator()
        
        link = CADisplayLink(target: self, selector: "updateShape:")
        shapeLayer.fillColor = UIColor.magentaColor().CGColor
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        
        shapeLayer.path = shape()
        link?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "perturbWeight"))
    }
    
    func perturbWeight() {
        let push = UIPushBehavior(items: [weightView!], mode: UIPushBehaviorMode.Instantaneous)
        push.pushDirection = CGVector(dx: 0, dy: 10)
        animator?.addBehavior(push)
    }
    
    func buildAnimator() {
        animator = UIDynamicAnimator(referenceView: self)
        weightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        addSubview(weightView!)
        let gravity = UIGravityBehavior(items: [weightView!])
        let spring = UIAttachmentBehavior(item: weightView!, attachedToAnchor: CGPoint(x: 0, y: 0))
        spring.length = 100
        spring.damping = 0.8
        animator?.addBehavior(gravity)
        animator?.addBehavior(spring)
    }
    
    func shape() -> CGPath {
        let path = CGPathCreateMutable()
        var identity = CGAffineTransformMakeTranslation(bounds.size.width / 2, bounds.size.height / 2)
        
        let points = 4 * 7
        let delta_theta = M_PI / Double(points / 2)
        CGPathMoveToPoint(path, &identity, 0, 0)
        
        for var point = 0; point <= points; point++ {
            let radius = point % 2 == 0 ? innerRadius : outerRadius
            let x = radius * CGFloat(cos(Double(point) * delta_theta))
            let y = radius * CGFloat(sin(Double(point) * delta_theta))
            CGPathAddLineToPoint(path, &identity, x, y)
        }
        
        return path
    }
    
    func updateShape(link :CADisplayLink) {
        innerRadius = weightView!.frame.origin.y
        outerRadius = -2 * weightView!.frame.origin.y
        shapeLayer.path = shape()
    }

}
