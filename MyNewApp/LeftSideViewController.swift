
import UIKit
import Parse

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    
   // var menuItems:[String] = ["H o m e","Free Events","Free Food","Free Books","Free Furniture", "Miscellaneous", "Help", "Settings", "Log Out"]
    
    var menuItems:[String] = ["F E E D S", "M Y   C O N T E N T", "P R O F I L E", "S E T T I N G S", "H E L P", "L O G   O U T"]
    
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "clock.png")!)
        //self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sidebar_bg.png")!)
        
        // code to make profile pic rounded
        self.userProfilePicture.layer.borderWidth = 1
        self.userProfilePicture.layer.masksToBounds = false
        self.userProfilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        self.userProfilePicture.layer.cornerRadius = userProfilePicture.frame.height/2
        self.userProfilePicture.clipsToBounds = true
        
        self.userFullNameLabel.textColor=UIColor.whiteColor()
        self.userFullNameLabel!.font = UIFont(name:"Helvetica Bold", size:12)
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 16)!]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        loadUserDetails()   
        
    }
    
    /*override func prefersStatusBarHidden() -> Bool {
    return true
    }*/
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    private func roundingUIView(let aView: UIView!, let cornerRadiusParam: CGFloat!) {
        aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadiusParam
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    return menuItems.count
    }
 
    
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //tableView.backgroundColor = UIColor.lightGrayColor()
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "sidebar_bg.png")!)
        tableView.separatorColor = UIColor(patternImage: UIImage(named:"sidebar_divider.png")!)
        
        // remove separator from empty cells
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name:"HelveticaNeue", size:10)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) 
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor = UIColor.whiteColor()
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.textLabel!.font = UIFont(name:"HelveticaNeue", size:10)
    }

    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.orangeColor()
        //tableView.separatorColor = UIColor(patternImage: UIImage(named:"sidebar_divider.png")!)
        
        //tableView.backgroundView = nil;
        // Custom image for user selection
       // selectedCell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "sidebar_select.png")!)
        //selectedCell.contentView.layer.borderColor = UIColor.orangeColor().CGColor
        selectedCell.contentView.layer.borderWidth = 0
        selectedCell.textLabel?.textColor = UIColor.grayColor()
        selectedCell.textLabel!.font = UIFont(name:"HelveticaNeue-Bold", size:14)
        
        
        
       switch(indexPath.row)
       {
       case 0:
        // open main page
        
        let mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
        
        let mainPageNav = UINavigationController(rootViewController: mainPageViewController)
        
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.centerViewController = mainPageNav
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        
        break
       
       case 1:
        // open about page
        
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
        
        let aboutPageNav = UINavigationController(rootViewController: aboutViewController)
        
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.centerViewController = aboutPageNav
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        break
        
        
       case 3:
        
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CategorySelection") as! CategorySelection
        
        let aboutPageNav = UINavigationController(rootViewController: aboutViewController)
        
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.centerViewController = aboutPageNav
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        break

        
        
       case 4:
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.show_walkthrough()
        
        break
        
        
   
        
       case 5:
        // perform sign out and take user to sign in page
        
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user_name")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Sending"
        spiningActivity.detailsLabelText = "Please wait"
        
        
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            
            
            spiningActivity.hide(true)
            
            
            // Navigate to Protected page
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            let signInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            let signInPageNav = UINavigationController(rootViewController:signInPage)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = signInPageNav
            
           
          
        }
    
        
        break
        
       default:
        print("Option is not handled")
        
       }
        
    }

    @IBAction func editButtonTapped(sender: AnyObject) {
        
        let editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        editProfile.opener = self
        
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        
        self.presentViewController(editProfileNav, animated: true, completion: nil)
    }
    
 
    
    func loadUserDetails()
    {
        if(PFUser.currentUser() == nil)
        {
            return
        }
        
        let userFirstName = PFUser.currentUser()?.objectForKey("first_name") as? String
        
        if userFirstName == nil
        {
           return
        }
        
        let userLastName = PFUser.currentUser()?.objectForKey("last_name") as! String
        
        userFullNameLabel.text = userFirstName! + " " + userLastName
        self.userFullNameLabel.text = self.userFullNameLabel.text?.uppercaseString
        
        
        let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as? PFFile
        
        if(profilePictureObject != nil)
        {
          profilePictureObject!.getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) -> Void in
            
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data: imageData!)

            }
            
         }
        }

    }
    
    

}



