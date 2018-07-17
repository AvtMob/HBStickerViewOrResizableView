//
//  Xib.swift
//  HBStickerViewOrResizableView
//
//  Created by Avtar Singh on 17/07/18.
//  Copyright © 2018 Avtar Singh. All rights reserved.
//  Developer Email: hbdevelopers.helpdesk@gmail.com


import UIKit
class HBXib: UIView {
    var contentView:UIView?
     var nibName:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    override func awakeFromNib() {
        xibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func xibSetup(){
        
        guard let view = loadFromNib() else {return}
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadFromNib()->UIView?{
        
        self.nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName!, bundle: bundle)
        return nib.instantiate(withOwner: self,
                               options: nil).first as? UIView
    }
    
}
