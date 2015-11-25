

// Name : Nithin Raju Chandy
// AddNewItemViewController.swift
// Last updated : Nov 19, 2015

//***************************************************************
//  ADDING NEW EVENT TO PARSE
//****************************************************************

import UIKit
import Parse

class AddNewItemViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {
 
    @IBOutlet weak var eventname: UITextField!
    @IBOutlet weak var eventdescription: UITextView!
    @IBOutlet weak var eventimage: UIImageView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // adding border to event description text area
        eventdescription.layer.borderColor = UIColor.blackColor().CGColor
        eventdescription.layer.borderWidth = 0.2
        eventdescription.layer.cornerRadius = 5 

    }
    
    
    func DismissKeyboard(){
        
        //Causes the view (or one of its embedded text fields) to resign the first responder
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Add a photo for each event
    @IBAction func selectEventPhotoButtonTapped(sender: AnyObject) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    // uses inbuilt imagepicker controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        eventimage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    // when user hits SAVE button
    @IBAction func savebutton(sender: UIButton) {
        
        let eName = eventname.text
        let eDesc = eventdescription.text
        

        if(eName!.isEmpty || eDesc!.isEmpty)
        {
            
            let myAlert = UIAlertController(title:"Alert", message:"All fields are required to fill in", preferredStyle:UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
   
        else {
        
        let testObject = PFObject(className: "Events")
        
        // saving data to parse
        testObject["EventName"] = eName
        testObject["EventDescription"] = eDesc
        testObject["CreatedBy"] = PFUser.currentUser()
            
            // saving image to parse
            if let eventImageData = eventimage.image
            {
                let eventImageDataJPEG = UIImageJPEGRepresentation(eventImageData, 1)
                
                let eventImageFile = PFFile(data: eventImageDataJPEG!)
                testObject.setObject(eventImageFile, forKey: "event_thumbnail")
                
            }
            
            
 

   
   
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
        print("Object has been saved.")
            
            // Show activity indicator
            let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            spiningActivity.labelText = "Adding New Event to Database"
            
            
            // nice animation using dispatch_after
            let delay = 0.75 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(time, dispatch_get_main_queue()) {
                spiningActivity.labelText = "Event Added"
                // Hide activity indicator
                spiningActivity.hide(true)
                
                // Going back to events page
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            
            
            
         }
            
     }
    
  }
    

}
