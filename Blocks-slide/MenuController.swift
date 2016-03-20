//
//  MenuController.swift
//  Blocks-slide
//
//  Created by Serx on 3/15/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import UIKit
import CoreData

class MenuController: UIViewController {
        
    var managerContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: TEST
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "continue"{
            if !checkPlist(){
                let alert = UIAlertView()
                alert.title = "error"
                alert.message = "there is no last time state"
                alert.addButtonWithTitle("OK")
                alert.show()
                
                return false
            }
            else {
                return true
            }
        }
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
        if segue.identifier == "menuToMark"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let markView = navigationController.topViewController as! MarkViewController
            
            markView.managedContext = managerContext
            
        }else if segue.identifier == "continue"{
            
            NSLog("in ")
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextController = navigationController.topViewController as! ViewController
            
            nextController.isContinue = 1
            
            nextController.managedContext = managerContext
            
        }else if segue.identifier == "newGame"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextController = navigationController.topViewController as! chooseLevelTableViewController
            
            nextController.managerContext = managerContext
        }
    }
    
    func checkPlist() -> Bool{
        let store = storeTheLastTime()
        store.startToRead()
        
        let result = store.toReadArray
        
        print(result.count)
        if result.count == 0{
            return false
        }else{
            return true
        }
    }
}
