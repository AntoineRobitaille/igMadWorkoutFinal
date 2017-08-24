// ============================
import UIKit
// ============================
class Shared: UIViewController
{
    // ============================
    var theDatabase: [String : [[String : String]]]!
    var savedUserDefault: UserDefaults = UserDefaults.standard
    static let sharedInstance = Shared()
    var theRow: Int!
    
    // ============================
    func checkForUserDefaultByName(_ theName: String, andUserDefaultObject: UserDefaults) -> Bool
    {
        let userDefaultObject = andUserDefaultObject.object(forKey: theName)
        
        if userDefaultObject == nil
        {
            return false
        }
        
        return true
    }
    
    // ============================
    func  saveOrLoadUserDefaults(_ name: String)
    {
        //self.savedUserDefault.removeObjectForKey(name)
        
        if !self.checkForUserDefaultByName(name, andUserDefaultObject: self.savedUserDefault)
        {
            var tempArray = ["" : [["" : ""]]]
            tempArray[""] = nil
            
            self.saveUserDefaultByName(name, andUserDefaultObject: self.savedUserDefault, andSomeValue: tempArray)
        }
        else
        {
            self.theDatabase = self.savedUserDefault.value(forKey: name) as! [String : [[String : String]]]
        }
    }
    
    // ============================
    func saveUserDefaultByName(_ theName: String, andUserDefaultObject: UserDefaults, andSomeValue: [String : [[String : String]]])
    {
        andUserDefaultObject.setValue(andSomeValue, forKey: theName)
    }
    
    // ============================
    func getDatabase(_ name: String) -> [String : [[String : String]]]
    {
        return self.savedUserDefault.value(forKey: name) as! [String : [[String : String]]]
    }
    
    // ============================
    func saveDatabase(_ valueToSave: [String : [[String : String]]])
    {
        self.savedUserDefault.setValue(valueToSave, forKey: "db")
    }
    // ============================
}








