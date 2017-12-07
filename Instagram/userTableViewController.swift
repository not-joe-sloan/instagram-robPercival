//
//  userTableViewController.swift
//  Instagram
//
//  Created by Joe Sloan on 12/6/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit
import Parse

class userTableViewController: UITableViewController {
    
    var usernames = [String]()
    var objectIDs = [String]()
    var isFollowing = [String : Bool]()
    

    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a user query
        let query = PFUser.query()
        
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        
        //Get all the objects of user data
        query?.findObjectsInBackground(block: { (users, error) in
            
            //If there's an error, print it
            if error != nil {
                print(error)
            //If there are users returned
            }else if let users = users{
                for object in users {
                 //check it we can use object as a user
                    if let user = object as? PFUser {
                        if let username = user.username{
                            
                            if let objectId = user.objectId{
                                self.usernames.append(username)
                                self.objectIDs.append(user.objectId!)
                                
                                let query = PFQuery(className: "Following")
                                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                                query.whereKey("following", equalTo: objectId)
                                query.findObjectsInBackground(block: { (objects, error) in
                                    if let objects = objects{
                                        if objects.count > 0 {
                                            self.isFollowing[objectId] = true
                                            
                                        }else{
                                            self.isFollowing[objectId] = false
                                        }
                                        self.tableView.reloadData()
                                    }
                                })
                            }
                            
                        }
                        
                    }
                }
            }
            
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        
        if let followsBoolean = isFollowing[objectIDs[indexPath.row]]{
            if followsBoolean {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        let following = PFObject(className: "Following")
        following["follower"] = PFUser.current()?.objectId
        following["following"] = objectIDs[indexPath.row]
        following.saveInBackground()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
