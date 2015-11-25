
// Name : Nithin Raju Chandy
// CategorySelection.swift
// Last updated : Nov 19, 2015

//***************************************************************
//  IMPLEMENTS CATEGORY SELECTION SCREEN
//****************************************************************

import UIKit

class CategorySelection: UIViewController {

    
    // Various switches on the category screen
    @IBOutlet weak var events_switch: UISwitch!
    @IBOutlet weak var food_switch: UISwitch!
    @IBOutlet weak var furniture_switch: UISwitch!
    @IBOutlet weak var books_switch: UISwitch!
    @IBOutlet weak var misc_switch: UISwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preload_switch_states()
        
        
        // adding event listeners to each button
        self.events_switch.addTarget(self, action: Selector("EventswitchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.food_switch.addTarget(self, action: Selector("FoodswitchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.furniture_switch.addTarget(self, action: Selector("FurnitureswitchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.books_switch.addTarget(self, action: Selector("BookswitchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.misc_switch.addTarget(self, action: Selector("MiscswitchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)

        
    }
    
    
    @IBAction func sidebar_pressed(sender: AnyObject) {
        
     let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

    }


    // function that will be invoked when switch state changes
    func EventswitchIsChanged(myswitch : UISwitch) {
 
        if myswitch.on {
          self.defaults.setObject("ON", forKey: "Eventswitchstate")
            
        } else {
           self.defaults.setObject("OFF", forKey: "Eventswitchstate")
        }
    }
    
    
    func FoodswitchIsChanged(myswitch : UISwitch) {
        
        if myswitch.on {
            self.defaults.setObject("ON", forKey: "Foodswitchstate")
            
        } else {
            self.defaults.setObject("OFF", forKey: "Foodswitchstate")
        }
    }
    
    
    func FurnitureswitchIsChanged(myswitch : UISwitch) {
        
        if myswitch.on {
            self.defaults.setObject("ON", forKey: "Furnitureswitchstate")
            
        } else {
            self.defaults.setObject("OFF", forKey: "Furnitureswitchstate")
        }
    }

    func BookswitchIsChanged(myswitch : UISwitch) {
        
        if myswitch.on {
            self.defaults.setObject("ON", forKey: "Bookswitchstate")
            
        } else {
            self.defaults.setObject("OFF", forKey: "Bookswitchstate")
        }
    }
    
    
    func MiscswitchIsChanged(myswitch : UISwitch) {
        
        if myswitch.on {
            self.defaults.setObject("ON", forKey: "Miscswitchstate")
            
        } else {
            self.defaults.setObject("OFF", forKey: "Miscswitchstate")
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.preload_switch_states()
        
    }
    
    
    func preload_switch_states(){
        
        if let e_state = defaults.stringForKey("Eventswitchstate")
        {
            if (e_state == "OFF"){
                self.events_switch.setOn(false, animated: true)
            }
            else{
                self.events_switch.setOn(true, animated: true)
            }
        }
        
        
        
        if let f_state = defaults.stringForKey("Foodswitchstate")
        {
            if (f_state == "OFF"){
                self.food_switch.setOn(false, animated: true)
            }
            else{
                self.food_switch.setOn(true, animated: true)
            }
        }
        
        
        if let fu_state = defaults.stringForKey("Furnitureswitchstate")
        {
            if (fu_state == "OFF"){
                self.furniture_switch.setOn(false, animated: true)
            }
            else{
                self.furniture_switch.setOn(true, animated: true)
            }
        }
        
        
        
        if let bo_state = defaults.stringForKey("Bookswitchstate")
        {
            if (bo_state == "OFF"){
                self.books_switch.setOn(false, animated: true)
            }
            else{
                self.books_switch.setOn(true, animated: true)
            }
        }
        
        
        if let m_state = defaults.stringForKey("Miscswitchstate")
        {
            if (m_state == "OFF"){
                self.misc_switch.setOn(false, animated: true)
            }
            else{
                self.misc_switch.setOn(true, animated: true)
            }
        }

        
    }
    

}
