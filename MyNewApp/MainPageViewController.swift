

import UIKit
import Parse

//var event_switch_state = 1

class MainPageViewController: UIViewController {

   @IBOutlet weak var event_notification_count: UILabel!
   //@IBOutlet weak var book_notification_count: UILabel!
   //@IBOutlet weak var furniture_notification_count: UILabel!
   //@IBOutlet weak var food_notification_count: UILabel!
    
    @IBOutlet weak var Event_button: UIButton!
    @IBOutlet weak var Food_button: UIButton!
    @IBOutlet weak var Furniture_button: UIButton!
    @IBOutlet weak var Book_button: UIButton!
    @IBOutlet weak var Misc_button: UIButton!
    
    @IBOutlet weak var scrollpage: UIScrollView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add background image here
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "clock.png")!)
        scrollpage.contentSize = CGSizeMake(scrollpage.frame.size.width, 600);
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("Eventswitchstate")
        {
            if (name == "OFF"){
                self.Event_button.hidden = true
            }
            else{
                self.Event_button.hidden = false
            }
        }
        
        

        let query = PFQuery(className:"Events")
        // query.whereKey("CreatedBy", equalTo:PFUser.currentUser()!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                self.event_notification_count.text = String (objects!.count)
            }
            
            
            
        }

        
        
        // Do any additional setup after loading the view.

        
    }
    
    /*override func prefersStatusBarHidden() -> Bool {
        return true
    }*/

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Enable navigation controller once view disappears
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    
    // disable navbar for the root controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        
        let navBgImage:UIImage = UIImage(named:"events_nav_bg.png")!
        
        bar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default)
        //bar.shadowImage = UIImage()
        bar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        //bar.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.3)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "feed_bg2.png")!)
        
        //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 14)!]
        self.navigationController!.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
   
        //if let font = UIFont(name: "HelveticaNeue-Thin", size: 14) {
           // UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        //}
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let ename = defaults.stringForKey("Eventswitchstate")
        {
            if (ename == "OFF"){
                self.Event_button.hidden = true
            }
            else{
                self.Event_button.hidden = false
            }
        }
        
        if let fname = defaults.stringForKey("Foodswitchstate")
        {
            if (fname == "OFF"){
                self.Food_button.hidden = true
            }
            else{
                self.Food_button.hidden = false
            }
        }
        
        if let funame = defaults.stringForKey("Furnitureswitchstate")
        {
            if (funame == "OFF"){
                self.Furniture_button.hidden = true
            }
            else{
                self.Furniture_button.hidden = false
            }
        }


        if let boname = defaults.stringForKey("Bookswitchstate")
        {
            if (boname == "OFF"){
                self.Book_button.hidden = true
            }
            else{
                self.Book_button.hidden = false
            }
        }

        if let miname = defaults.stringForKey("Miscswitchstate")
        {
            if (miname == "OFF"){
                self.Misc_button.hidden = true
            }
            else{
                self.Misc_button.hidden = false
            }
        }

          
        
    }
    
 
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }

    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        //let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
 
        //appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user_name")
        NSUserDefaults.standardUserDefaults().synchronize()
 
        
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            

            // Navigate to Protected page
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            let signInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            let signInPageNav = UINavigationController(rootViewController:signInPage)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = signInPageNav

            
        }
   
        
        
    }
    
    


    
}
