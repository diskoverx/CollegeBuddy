
// Name : Nithin Raju Chandy
// CellDetailViewController.swift
// Last updated : Nov 19, 2015

//***************************************************************
//  IMPLEMENTS THE EVENTS DETAILED VIEW
//****************************************************************

//  (+) Detailed view of each item
//  (+) Integrated with Apple Maps
//  (+) Integrated with Event Kit for adding reminders

import UIKit
import EventKit
import MapKit
import MessageUI
import Foundation
import Social

class CellDetailViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var detail_title: UILabel!
    @IBOutlet weak var detail_desc: UILabel!
    
    
    // @IBOutlet weak var detail_location: UILabel!
    @IBOutlet weak var detail_image: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var scrollenable: UIScrollView!    
    @IBOutlet weak var add_reminder: UIButton!
    
    
    
    // Email feature
    @IBAction func send_email(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    // To store the event ID
    var savedEventId : String = ""

    // Container to store the PFObject reference
    var currentObject : PFObject?
  
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        detail_image.layer.borderWidth = 0.2
        // detail_image.layer.borderColor = UIColor.grayColor().CGColor
        scrollenable.contentSize = CGSizeMake(scrollenable.frame.size.width, 600);

        // Unwrap the current object object
        if let object = currentObject {
            
            
            detail_title.text = object["EventName"] as? String
            
            detail_desc.text = object["EventDescription"] as? String
                        
            
            
            
            let event_thumbnail_Object = object["event_thumbnail"] as? PFFile
            
            if(event_thumbnail_Object != nil)
            {
                event_thumbnail_Object!.getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) -> Void in
                    
                    if(imageData != nil)
                    {
                        self.detail_image.image = UIImage(data: imageData!)
                    }
                    
                }
            }

        }
        
        
        
        
        // Google maps ends here
        
        let location = CLLocationCoordinate2D(
            latitude: 40.5015464329687,
            longitude: -74.4502108251308
        )
        
        
        
        
        let span = MKCoordinateSpanMake(0.0125, 0.0125)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Busch Campus Center"
        annotation.subtitle = "New Brunswick, NJ"
        mapView.addAnnotation(annotation)

        // Map code ends here
        
        
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // Responds to button to add event. This checks that we have permission first, before adding the
    @IBAction func addEvent(sender: UIButton) {
        
        // Create object of eventstore
        let eventStore = EKEventStore()
        
        let date = "30 Nov 2015 10:50"
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "US_en")
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        let startDate = formatter.dateFromString(date)
        let endDate = startDate?.dateByAddingTimeInterval(3 * 60 * 60)
        
        
        // else if you get access to Eventstore, create event with details passed as args
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: self.detail_title.text!, description: self.detail_desc.text!, startDate: startDate!, endDate: endDate!)
            })
        } else {
            createEvent(eventStore, title: detail_title.text!, description: detail_desc.text!, startDate: startDate!, endDate: endDate!)
        }
        
        // if calendar access was denied
        if (EKEventStore.authorizationStatusForEntityType(.Event) == EKAuthorizationStatus.Denied) {
            
            print("Access to calendar got denied!!")
            
        }
        
        
    }

    
    
    // Creates an event in the EKEventStore. Assumes the eventStore is created & accessible
    func createEvent(eventStore: EKEventStore, title: String, description:String, startDate: NSDate, endDate: NSDate) {
        
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.notes = description
        event.startDate = startDate
        event.endDate = endDate
        // need to pass event location also
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Something went bad when trying to save eventID")
        }
        
        // Show activity indicator
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        spiningActivity.labelText = "Adding event to Calendar"
        
        
        // nice animation using dispatch_after
        let delay = 0.75 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            spiningActivity.labelText = "Event Added"
            // Hide activity indicator
            spiningActivity.hide(true)
        }

    }
    
    
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
    }
    
    
    
    
    
    @IBAction func facebookButtonPushed(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(detail_title.text)
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitterButtonPushed(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(detail_title.text)
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    

}


