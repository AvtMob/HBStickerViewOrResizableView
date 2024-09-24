//
//  HBStickerView.swift

//
//  Created by Avtar Singh on 17/07/18.
//  Copyright © 2018 Avtar Singh. All rights reserved.
//  Developer Email: hbdevelopers.helpdesk@gmail.com

import UIKit

protocol HBStickerViewDelegate {
    func hbStickerView(didRemove hbStickerView:HBStickerView)
}

class HBStickerView: HBXib,UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnCross:HBButton!
    @IBOutlet weak var btnResize:HBButton!
    @IBOutlet weak var btnRotate:HBButton!
    @IBOutlet weak var btnFlip:HBButton!
    @IBOutlet weak var btnLeftBoundry:HBButton!
    @IBOutlet weak var btnRightBoundry:HBButton!
    @IBOutlet weak var btnTopBoundry:HBButton!
    @IBOutlet weak var btnBottomBoundry:HBButton!
    @IBOutlet weak var viewControls: HBView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBInspectable var stickIcon : UIImage?{
        didSet{
            imageView?.image = stickIcon
        }
    }
    
    
    //MARK:- Variables and Constants
    var delegate:HBStickerViewDelegate?
    
    var isControlsHidden = false{
        didSet{
            if isControlsHidden{
                hideControls()
            }else{
                   showControls()
            }
        }
    }
    
    var isBringToFront = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK:- Button Actions
    @IBAction func btnCrossAction(_ sender: HBButton) {
        self.removeFromSuperview()
        delegate?.hbStickerView(didRemove: self)
    }
    @IBAction func btnResizeAction(_ sender: HBButton) {
        
    }
    @IBAction func btnRotateAction(_ sender: HBButton) {
        enableMoveRestriction = false
    }
    @IBAction func btnFlipAction(_ sender: HBButton) {
        UIView.animate(withDuration: 0.3) {
            self.imageView.transform = self.imageView!.transform.scaledBy(x: -1, y: 1)
        }
    }
    @IBAction func btnLeftBoundryAction(_ sender: HBButton) {
        
    }
    @IBAction func btnRightBoundryAction(_ sender: HBButton) {
        
    }
    @IBAction func btnTopBoundryAction(_ sender: HBButton) {
        
    }
    @IBAction func btnBottomBoundryAction(_ sender: HBButton) {
        
    }
    
    //MARK:- Initial stuff
    func setup(){
          addGestureRecognizer(moveGestureRecognizer)
        
        //Enable multiple touch and user interaction for textfield
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRecognized(tap:))))
        
        //add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)))
        pinchGesture.delegate = self
        self.addGestureRecognizer(pinchGesture)
        
        //add rotate gesture.
        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
        rotate.delegate = self
        self.addGestureRecognizer(rotate)
        
        self.btnRotate.addGestureRecognizer(panRotateGesture)
        self.btnResize.addGestureRecognizer(scaleGestureRecognizer)
        self.btnLeftBoundry.addGestureRecognizer(leftBoundryGestureRecognizer)
        self.btnRightBoundry.addGestureRecognizer(rightBoundryGestureRecognizer)
        self.btnTopBoundry.addGestureRecognizer(topBoundryGestureRecognizer)
        self.btnBottomBoundry.addGestureRecognizer(bottomBoundryGestureRecognizer)
    }
    
    func hideControls(){
        self.viewControls.isHidden = true
        self.btnRotate.isHidden = true
        self.btnResize.isHidden = true
        self.btnCross.isHidden = true
        self.btnFlip.isHidden = true
        self.btnLeftBoundry.isHidden = true
        self.btnRightBoundry.isHidden = true
        self.btnTopBoundry.isHidden = true
        self.btnBottomBoundry.isHidden = true
    }
    func showControls(){
        if !isControlsHidden{
            self.viewControls.isHidden = false
            self.btnRotate.isHidden = false
            self.btnResize.isHidden = false
            self.btnCross.isHidden = false
            self.btnFlip.isHidden = false
            self.btnLeftBoundry.isHidden = false
            self.btnRightBoundry.isHidden = false
            self.btnTopBoundry.isHidden = false
            self.btnBottomBoundry.isHidden = false
        }
    }
    
    @objc func tapRecognized(tap:UITapGestureRecognizer){
        showControls()
        if isBringToFront{
            self.superview?.bringSubviewToFront(self)
        }
    }
    
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        
        if let view = pinch.view {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
    }
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    //MARK:- UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    fileprivate var touchLocation: CGPoint?
    fileprivate var deltaAngle: CGFloat?
    fileprivate var initialBounds: CGRect?
    fileprivate var initialDistance: CGFloat?
    fileprivate var beginningPoint: CGPoint?
    fileprivate var beginningCenter: CGPoint?
    fileprivate var beginBounds: CGRect?
    public var enableMoveRestriction: Bool = true
    public var enableScaleRestriction: Bool = true
    public var enableRotateRestriction: Bool = true
    
    private lazy var panRotateGesture: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(rotateViewPanGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    private lazy var moveGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    private lazy var scaleGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(scaleGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    private lazy var leftBoundryGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(leftBoundryGesture(recognizer:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    private lazy var rightBoundryGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(leftBoundryGesture(recognizer:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    private lazy var topBoundryGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(topBoundryGesture(recognizer:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    private lazy var bottomBoundryGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(topBoundryGesture(recognizer:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    @objc func rotateViewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        btnRotate.isEnabled = true
        touchLocation = recognizer.location(in: superview)
        let center = CGRectGetCenter(frame)
        
        if !enableRotateRestriction {
            return
        }
        
        switch recognizer.state {
        case .began:
            enableMoveRestriction = false
            enableScaleRestriction = false
            deltaAngle = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x) - CGAffineTrasformGetAngle(transform)
            initialBounds = bounds
            initialDistance = CGpointGetDistance(center, point2: touchLocation!)
            
        case .changed:
            let ang = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x)
            
            let angleDiff = deltaAngle! - ang
            transform = CGAffineTransform(rotationAngle: -angleDiff)
            layoutIfNeeded()
        case .ended:
            enableMoveRestriction = true
            enableScaleRestriction = true
        default:break
            
        }
    }
    
    @objc func moveGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if !enableMoveRestriction{
            return
        }
        
        touchLocation = recognizer.location(in: superview)
        
        switch recognizer.state {
        case .began:
            
            beginningPoint = touchLocation
            beginningCenter = center
            
            center = estimatedCenter()
            beginBounds = bounds
            
        case .changed:
            enableMoveRestriction = false
            center = estimatedCenter()
            enableMoveRestriction = true
        case .ended:
            center = estimatedCenter()
            break
        default:break
            
        }
    }
    
    @objc func scaleGesture(_ recognizer: UIPanGestureRecognizer){
        
        if !enableScaleRestriction{
            return
        }
        
        touchLocation = recognizer.location(in: superview)
        
        switch recognizer.state {
        case .began:
            enableMoveRestriction = false
            initialBounds = bounds
            initialDistance = CGpointGetDistance(center, point2: touchLocation!)
        case .changed:
            let scale = sqrtf(Float(CGpointGetDistance(center, point2: touchLocation!)) / Float(initialDistance!))
            let scaleRect = CGRectScale(initialBounds!, wScale: CGFloat(scale), hScale: CGFloat(scale))
            bounds = scaleRect
        case .ended:
            enableMoveRestriction = true
            break
        default:break
            
        }
    }
    
    
    @objc func leftBoundryGesture(recognizer:UIPanGestureRecognizer){
        touchLocation = recognizer.location(in: superview)
        switch recognizer.state {
        case .began:
            enableMoveRestriction = false
            initialBounds = bounds
            initialDistance = CGpointGetDistance(center, point2: touchLocation!)
            break
        case .changed:
            let s = sqrtf(Float(CGpointGetDistance(center, point2: touchLocation!)) / Float(initialDistance!))
            let scale = CGFloat(s)
            let rect = CGRect(x: initialBounds!.origin.x * scale , y: initialBounds!.origin.y, width: initialBounds!.size.width * scale, height: initialBounds!.size.height )
            bounds = rect
            break
        case .ended:
            enableMoveRestriction = true
            break
        default:
            break
        }
    }
    @objc func rightBoundryGesture(recognizer:UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        default:
            break
        }
    }
    @objc func topBoundryGesture(recognizer:UIPanGestureRecognizer){
        touchLocation = recognizer.location(in: superview)
        switch recognizer.state {
        case .began:
            enableMoveRestriction = false
            initialBounds = bounds
            initialDistance = CGpointGetDistance(center, point2: touchLocation!)
            break
        case .changed:
            let s = sqrtf(Float(CGpointGetDistance(center, point2: touchLocation!)) / Float(initialDistance!))
            let scale = CGFloat(s)
            let rect = CGRect(x: initialBounds!.origin.x  , y: initialBounds!.origin.y * scale, width: initialBounds!.size.width, height: initialBounds!.size.height * scale )
            bounds = rect
            break
        case .ended:
            enableMoveRestriction = true
            break
        default:
            break
        }
    }
    @objc func bottomBoundryGesture(recognizer:UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        default:
            break
        }
    }
    
    func CGRectGetCenter(_ rect: CGRect) -> CGPoint{
        return CGPoint(x: rect.midX, y: rect.midY)
    }
   
    func CGAffineTrasformGetAngle(_ t: CGAffineTransform) -> CGFloat{
        return atan2(t.b, t.a)
    }
    
    func CGpointGetDistance(_ point1: CGPoint, point2: CGPoint) -> CGFloat {
        let fx = point2.x - point1.x
        let fy = point2.y - point1.y
        return sqrt((fx * fx + fy * fy))
    }
    
    func CGRectScale(_ rect: CGRect, wScale: CGFloat, hScale: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x * wScale, y: rect.origin.y * hScale, width: rect.size.width * wScale, height: rect.size.height * hScale)
    }
    
    fileprivate func estimatedCenter() -> CGPoint{
        let newCenter: CGPoint!
        var newCenterX = beginningCenter!.x + (touchLocation!.x - beginningPoint!.x)
        var newCenterY = beginningCenter!.y + (touchLocation!.y - beginningPoint!.y)
        
        if (enableMoveRestriction) {
            if (!(newCenterX - 0.5 * frame.width > 0 &&
                newCenterX + 0.5 * frame.width < superview!.bounds.width)) {
                newCenterX = center.x;
            }
            if (!(newCenterY - 0.5 * frame.height > 0 &&
                newCenterY + 0.5 * frame.height < superview!.bounds.height)) {
                newCenterY = center.y;
            }
            newCenter = CGPoint(x: newCenterX, y: newCenterY)
        }else {
            newCenter = CGPoint(x: newCenterX, y: newCenterY)
        }
        return newCenter
    }
}
