
// Name : Nithin Raju Chandy
// EventsTableViewController.swift
// Last updated : Nov 19, 2015

//***************************************************************
//  IMPLEMENTS THE EVENTS TABLE VIEW
//****************************************************************

//  (+) Detailed view of each item is a simple segue
//  (+) Enabled Search feature as well


import UIKit
import Parse

// UISearchResultsUpdating Delegate is the key to live search results
class EventsTableViewController:  UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {

    // Array to hold all the items that belong to events category
    var eventtimelineData:NSMutableArray = NSMutableArray()
    
    // Array to hold search results
    // we can implement search using PFQueryController as well
    var filteredData:NSMutableArray = NSMutableArray()

    // UIsearchbar outlet variable
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Searchresults view controller
    var resultSearchController = UISearchController()
    

    
    // View did appear. Will be executed when all the screen loads completely
    override func viewDidAppear(animated: Bool) {
        
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Home_BG.png")!)
        
        
        
        
        
        // Initializing table view with event category items
        self.loadData()
        
        // Searchbar delegates to the same data source
        searchBar.delegate = self
    }

    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    
    // viewDidLoad is called exactly once, when the view controller is first loaded into memory.
    override func viewDidLoad() {
        
       super.viewDidLoad()
        
       // registering cell
       self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
       // search results should have the same cell height as the table cells
       // self.searchDisplayController!.searchResultsTableView.rowHeight = tableView.rowHeight
        
       // Customizing search results controller
       self.resultSearchController = ({
        
        let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        if let font = UIFont(name: "HelveticaNeue-Thin", size: 14) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        
        
        //let logo = UIImage(named: "title2x.png")
        //let imageView = UIImageView(image:logo)
        //self.navigationItem.titleView = imageView
        
        self.navigationItem.title="E V E N T S"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    
    
    
    
    
    
    

    // Function to load data to the events view controller
    @IBAction func loadData(){
        
        // Clearing the local events array to avoid duplicates
        self.eventtimelineData.removeAllObjects()
        
        // Clearing the local search results array to avoid duplicates
        // No need of local arrays if we use PFQueryController
        
        self.filteredData.removeAllObjects()
        

        // Get count of objects in each category --> for debugging purposes
        let query2 = PFQuery(className: "Events")
        query2.countObjectsInBackgroundWithBlock{
            (count: Int32, error: NSError?) -> Void in
            if error == nil{
                print(count)
            }
        }

        
        // Query to fetch all items in the events category
        // Just need to change the classname for other categories
        
        let query = PFQuery(className:"Events")
        
        // query.whereKey("CreatedBy", equalTo:PFUser.currentUser()!)
        // check parse website for more subqueries
        
         query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil {
                
                // Find succeeded
                print("Successfully retrieved \(objects!.count) parse objects.")
               
                // Inserting retreived objects to the local events array
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        self.eventtimelineData.addObject(object)

                        print(object.objectId) // --> for debugging purposes
                        print(object.description) // --> for debugging purposes
                    }
                    
                    let array:NSArray = self.eventtimelineData.reverseObjectEnumerator().allObjects
                    self.eventtimelineData = array.mutableCopy() as! NSMutableArray
                    self.tableView.reloadData()
                    
                }
            }
            
            else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            
            
        } // End of Query block
        
    } // End of loaddata()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // End of EventsTableViewController class definition
}



// Extending the class
extension EventsTableViewController {
        
    // return the number of sections in the table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    // return the number of rows in the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // if search controller is active, fetch from filtered data array
        if (self.resultSearchController.active) {
        return self.filteredData.count
        }
        
        else {
        return self.eventtimelineData.count
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //tableView.backgroundColor = UIColor.lightGrayColor()
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "tableview_bg.png")!)
        //tableView.separatorColor = UIColor(patternImage: UIImage(named:"sidebar_select.png")!)
        
        // remove separator from empty cells
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name:"HelveticaNeue", size:10)
    }
    
    
        
    // table cell updation
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        
        let cell:EventTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath!) as! EventTableViewCell

        let event_object:PFObject
        
        // if search controller is active, get from filtered data array
        if (self.resultSearchController.active) {
        event_object = self.filteredData.objectAtIndex(indexPath!.row) as! PFObject
        }
            
        else {
        event_object = self.eventtimelineData.objectAtIndex(indexPath!.row) as! PFObject
        }
        
        // Setting opacity of all items to zero for animation
        cell.event_Title.alpha = 0
        cell.added_Date.alpha = 0
        cell.event_Description.alpha = 0
        cell.event_Image.alpha = 0
        
        cell.event_Description.text = event_object.objectForKey("EventDescription") as! String
        cell.event_Title.text = event_object.objectForKey("EventName") as! String
      
        // Getting thumbnail
        let event_thumbnail_Object = event_object.objectForKey("event_thumbnail") as? PFFile
        
        if(event_thumbnail_Object != nil) {
            event_thumbnail_Object!.getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) -> Void in
                
                if(imageData != nil) {
                    cell.event_Image.image = UIImage(data: imageData!)
                }
                
            }
        }
        
        else{
            
            // show default image
        }
        

        // Showing all elements
        UIView.animateWithDuration(0.5, animations: {
            cell.event_Image.alpha = 1
            cell.event_Title.alpha = 1
            cell.added_Date.alpha = 1
            cell.event_Description.alpha = 1
            
        })


        return cell
        
      }
        
        
      // Sending data from each cell to detail view as a segue
      override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        super.prepareForSegue(segue, sender: sender)
        
        if let detailviewcontroller:CellDetailViewController = segue.destinationViewController as? CellDetailViewController {
   
                // Pass the selected object to the destination view controller.
                if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // hide search bar
                resultSearchController.active = false
                
                let row = Int(indexPath.row)
                detailviewcontroller.currentObject = (eventtimelineData[row] as! PFObject)
                    
                }
                
            }
        }
        
        
        // Function that implements live search results
        func updateSearchResultsForSearchController(searchController: UISearchController)
        {

            print(self.filteredData.count) // --> for debugging purposes
            
            // clear previous search results
            if (self.filteredData.count) > 0 {
             self.filteredData.removeAllObjects()
            }
            
            let searchPredicate = searchController.searchBar.text!
            print("Search keyword: \(searchPredicate)") // --> for debugging purposes
            
            if (searchPredicate != ""){
            
                let query = PFQuery(className:"Events")
                query.whereKey("EventName", containsString:searchPredicate)
            
                query.findObjectsInBackgroundWithBlock {
                    (objects, error) -> Void in
                
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) scores.")
                    
                        self.eventtimelineData.removeAllObjects()
                    
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            
                            for object in objects {
                            
                                self.eventtimelineData.addObject(object)
                                
                                print(object.objectId)  // --> for debugging purposes
                                print(object.description)  // --> for debugging purposes
                            }
                        
                        let array:NSArray = self.eventtimelineData.reverseObjectEnumerator().allObjects
                        self.filteredData = array.mutableCopy() as! NSMutableArray
                        self.tableView.reloadData()
                    }
                    
                    
                } else {
                    
                    print("Error: \(error!) \(error!.userInfo)")
                }
                    
                } // pfQuery block ends here
                
            } // if block ends here
        } // function ends here
        
    } // extension ends here
