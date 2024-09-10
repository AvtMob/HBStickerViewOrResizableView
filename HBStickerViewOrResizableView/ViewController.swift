//
//  ViewController.swift
//  HBStickerViewOrResizableView
//
//  Created by Avtar Singh on 17/07/18.
//  Copyright © 2018 Avtar Singh. All rights reserved.
//  Developer Email: hbdevelopers.helpdesk@gmail.com


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addSticketButton : HBButton!
    
    private let stickerIcons = ["bicycle","girl","dance_text","pineapple","dance_girl","wifi","main_sticker"]
    
    private var toggleControlBtns = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addSticker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func addStickerButtonAction(_ button:HBButton?){
        addSticker()
    }
    
    @IBAction func clearButtonAction(_ button:HBButton?){
        removeAllStickers()
    }
    
    @IBAction func toggleControlsButtonAction(_ button:HBButton?){
        toggleControls()
    }
    
    private func addSticker(){
        let x = CGFloat(Int.random(in: 100 ..< 200))
        let y = CGFloat(Int.random(in: 100 ..< 600))
        let sticketIndex = Int.random(in: 0 ..< stickerIcons.count)
        let sticker =  HBStickerView(frame: CGRect(x: x,y:y ,width: x,height: x))
        sticker.stickIcon = UIImage(named: stickerIcons[sticketIndex])
        self.view.addSubview(sticker)
    }
    
    private func removeAllStickers(){
        self.view.subviews.forEach { view in
            if view is HBStickerView{
                view.removeFromSuperview()
            }
        }
    }
    
    private func toggleControls(){
        toggleControlBtns = !toggleControlBtns
        self.view.subviews.forEach { view in
            if view is HBStickerView{
                (view as! HBStickerView).isControlsHidden = toggleControlBtns
            }
        }
    }
}

