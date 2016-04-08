//
//  DayPickerControl.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/6/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit

//@IBDesignable
class DayPickerControl: UIView {

    private  var dayButtons = [ UIButton]()
    var selectedDays = [Int]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       // let emptyStarImage = UIImage(named: "emptyStar")
        //let filledStarmage = UIImage(named: "filledStar")
        
        for day in 0..<7 {
            
            let button = UIButton()
            
           // let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
           // button.setImage(emptyStarImage, forState: .Normal)
          //  button.setImage(filledStarmage, forState: .Selected)
           // button.setImage(filledStarmage, forState: [.Highlighted , .Selected ])
            var dayText = "S"
            switch day
            {
            case 0 :
                dayText = "S"
            case 1 :
                dayText = "M"
            case 2 :
                dayText = "T"
            case 3 :
                dayText = "W"
            case 4 :
                    dayText = "T"
            case 5 :
                dayText = "F"
            case 6 :
                dayText = "S"
            default:
                 dayText = "S"
            }
            button.adjustsImageWhenHighlighted = false;
            button.setTitle(dayText, forState: .Normal)
            button.backgroundColor = UIColor.blueColor()
            button.addTarget(self, action: "dayButtonTapped:", forControlEvents: .TouchDown)
            addSubview(button)
            
            dayButtons.append(button)

        }
        
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + 5)*7
        return CGSize(width: width, height: buttonSize)
    }

    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        for (index, button) in dayButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
            button.frame = buttonFrame
        }
        setSelectedDays()
        
    }
    
    func dayButtonTapped(button:UIButton){
        
        let  btnIndex : Int = dayButtons.indexOf(button)!
       
        
        if selectedDays.contains(btnIndex)
        {
            selectedDays.removeAtIndex(selectedDays.indexOf(btnIndex)!)
             button.backgroundColor = UIColor.blueColor()
        }
        else
        {
            selectedDays.append(btnIndex)
            button.backgroundColor = UIColor.greenColor()
        }
    }
    
    private func setSelectedDays(){
    
    if !selectedDays.isEmpty
    {
        for frequency in selectedDays
        {
            dayButtons[frequency].backgroundColor = UIColor.greenColor()
        }
    }
    
    }
    
    
}
