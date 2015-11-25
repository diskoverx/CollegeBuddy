
// Name : Nithin Raju Chandy
// AppDelegate.swift
// Last updated : Nov 19, 2015

//***************************************************************
//  MAIN DELEGATE FILE
//****************************************************************

import UIKit
import Parse
import Bolts
import ParseFacebookUtilsV4


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BWWalkthroughViewControllerDelegate {


    var window: UIWindow?
    var drawerContainer: MMDrawerController?
 
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // to make status bar font color adapt from the remaining settings
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        // hide the status bar 
        //application.statusBarHidden = true
        
        // customizing navigation bar color/background
        let navigationBarAppearace = UINavigationBar.appearance()
        
        
        let navBgImage:UIImage = UIImage(named:"events_nav_bg.png")!
        
        navigationBarAppearace.setBackgroundImage(navBgImage, forBarMetrics: .Default)
        
        //var nav_bg_image = UIImage(named: "sidebar_bg.png")! as UIImage
        
        //navigationBarAppearace.setBackgroundImage(nav_bg_image,
           // forBarMetrics: .Default)
        
        //navigationBarAppearace.tintColor = UIColor.greenColor()
        //navigationBarAppearace.barTintColor = UIColor.greenColor()
        navigationBarAppearace.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 14)!]
        
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("OfrfjeXHexpoq9uxUFmPgPb1XjdLkJiWbAHHisXU", clientKey: "0eRJah3g700Bcd5Aax5jt0G7DQeVuCqkwkJHYW83")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        PFTwitterUtils.initializeWithConsumerKey("cJBoPzbxvWLQUDZZ09S3YqjJM",  consumerSecret:"Rr2wfpjv5uaXyRDveOZLKBHaVaXZFL345oRBAD84tGr6vPMUVE")
 
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // This function will draw the category screen
        buildUserInterface()
     
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    
    }
    
    

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock { (success, error) -> Void in
            print("Registration successful? \(success)")
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register \(error.localizedDescription)")
    }
    
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        PFPush.handlePush(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
         FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    

    
    func buildUserInterface()
    {
        // Function that builds user interface
        let userName:String? =  NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        
        // if the user is already logged in, show him the category screen
        if(userName != nil)
            
        {
            // Navigate to Protected page
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            // Create View Controllers
            let mainPage:MainPageViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            let leftSideMenu:LeftSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
            let rightSideMenu:RightSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController
            
           // Wrap into Navigation controllers
            let mainPageNav = UINavigationController(rootViewController:mainPage)
            let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
            let rightSideMenuNav = UINavigationController(rootViewController:rightSideMenu)
            
            drawerContainer = MMDrawerController(centerViewController: mainPageNav, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: rightSideMenuNav)
            drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
            drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
            
            window?.rootViewController = drawerContainer
        }
        
        
        // if user not logged in, show him walkthrough screens
        else if(userName == nil)
        {
           show_walkthrough()

        }
   
    }
    
    
    
    // for debugging purposes
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    // This function will be called when user clicks "CLOSE" on walkthrough screens
    func walkthroughCloseButtonPressed() {
        //self.BWWalkthroughViewController.dismissViewControllerAnimated(true, completion: nil)
        show_signinpage()
    }
    
    
    func show_signinpage(){
        
        // Navigate to Protected page
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let signInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let signInPageNav = UINavigationController(rootViewController:signInPage)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signInPageNav

    }
    
    
    func show_walkthrough(){
        
        // Get view controllers and build the walkthrough screens
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0")
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_zero)
        
        window?.rootViewController = walkthrough
        
    }

}

