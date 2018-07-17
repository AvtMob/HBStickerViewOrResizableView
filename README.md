# HBStickerViewOrResizableView
Use HBStickerView for photo editing and sticker decorations in applications of ios swift

# How to Use

## First case
Step 1: Take a view in your storyboard

Step 2: Set Custom class of view to HBStickerView

Step 3: Build and Run.

## Second case

  let stickerview = HBStickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
  
  stickerview.imageView.image = UIImage(named: "main")
  
  self.view.addSubview(stickerview)
    
## Controls
  Call to showControls() function for show controls like cross, rotate and resize.
  
  **stickerview.showControls()**
  
  Call to hideControls() function for hide controls like cross, rotate and resize.
  
  **stickerview.hideControls()**
  
  ### Check controls state with
    stickerview.isControlsHidden
    
    if(stickerview.isControlsHidden){
    //do something here
    }
