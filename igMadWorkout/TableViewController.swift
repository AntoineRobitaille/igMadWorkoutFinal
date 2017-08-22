// ============================
import UIKit
// ============================
class TableViewController: UITableViewController
{
    /* -------------------------------- */
    var theDatabase: [String : [[String : String]]]!
    var theWorkout: [String]!
    /* -------------------------------- */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.theDatabase = Shared.sharedInstance.getDatabase("db")
        self.theWorkout = self.fillUpWorkoutArray(self.getDates()[Shared.sharedInstance.theRow])
    }
    /* -------------------------------- */
    func getDates() -> [String]
    {
        var tempArray = [""]
        
        for (a, _) in  self.theDatabase
        {
            tempArray.append(a)
        }
        
        tempArray.remove(at: 0)
        
        return tempArray
    }
    /* -------------------------------- */
    func fillUpWorkoutArray(_ theDate: String) -> [String]
    {
        var arrToReturn: [String] = []
        
        for (a, b) in self.theDatabase
        {
            if a == theDate
            {
                for c in b
                {
                    for (d, e) in c
                    {
                        arrToReturn.append("[\(e)] : \(d)")
                    }
                }
            }
        }
        
        return arrToReturn
    }
    /* -------------------------------- */
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    /* -------------------------------- */
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    /* -------------------------------- */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.theWorkout.count
    }
    /* -------------------------------- */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel!.font = UIFont(name: "Caviar Dreams", size: 18.0)
        cell.textLabel!.text = self.theWorkout[indexPath.row]
        tableView.backgroundColor = UIColor.colorWithRedValue(redValue: 63, greenValue: 92, blueValue: 255, alpha: 1)
        //tableView.backgroundColor = UIColor(red: 63.0, green: 92.0, blue: 255.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    /* -------------------------------- */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    /* -------------------------------- */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            self.theWorkout.remove(at: indexPath.row)
            self.deleteFromDatabase(self.getDates()[Shared.sharedInstance.theRow], indexToDelete: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath)
    {
        //        let itemToMove = self.theWorkout[fromIndexPath.row]
        //        self.theWorkout.removeAtIndex(fromIndexPath.row)
        //        self.theWorkout.insert(itemToMove, atIndex: toIndexPath.row)
    }
    
    func deleteFromDatabase(_ theDate: String, indexToDelete: Int)
    {
        for (a, b) in self.theDatabase
        {
            if a == theDate
            {
                for _ in b
                {
                    self.theDatabase[theDate]?.remove(at: indexToDelete)
                    Shared.sharedInstance.saveDatabase(self.theDatabase)
                    return
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // ============================
}

extension UIColor {
    static func colorWithRedValue(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}
