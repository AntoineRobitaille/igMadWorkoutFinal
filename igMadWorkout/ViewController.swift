// ============================
import UIKit
import WatchConnectivity
// ============================
class ViewController: UIViewController, WCSessionDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    // ============================
    @IBOutlet weak var theDatePicker: UIDatePicker!
    @IBOutlet weak var thePickerView: UIPickerView!
    @IBOutlet weak var theRepsField: UITextField!
    @IBOutlet weak var theSetsField: UITextField!
    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var theSynchButton: UIButton!
    var exerciseAccount: UserDefaults = UserDefaults.standard
    var session: WCSession!
    // ============================
    var theDatabase: [String : [[String : String]]]!
    var theExercise: String!
    var exerciseAccountability = ["HEART: Treadmill" : 0, "LEGS: Laying Leg Press" : 0, "HAMSTRINGS: Laying Hamstring Curl" : 0, "HAMSTRINGS: Seated Hamstring Curls" : 0, "CALVES: Calf Press" : 0, "CALVES: Seated Calf Raise" : 0, "QUADS: Leg Extension" : 0, "INNER THIGH: Adductor" : 0, "GLUTES: Abductor" : 0, "GLUTES: Glute Kickback" : 0, "CHEST: Chest Press" : 0, "CHEST: Plated Chess Press" : 0, "CHEST: Pec Tec" : 0, "BACK: Cable Low Rows" : 0, "BACK: Cable Nose Pulls" : 0, "CHEST: Cable Flyes" : 0, "LATS: Lateral Pull-Downs" : 0, "ABS: Ab Cruch Machine" : 0, "LEGS: Standing Leg Press" : 0, "BACK: Rear Delt Flyes" : 0, "CHEST: Inclined Chess Press" : 0, "CHEST: Dumbell Flyes" : 0, "BICEPS: Preacher Curl" : 0, "BICEPS: Independant Bicep Curl" : 0, "TRICEPS: Tricep Pull-Down" : 0, "BICEPS: Cable Row Bicep Curls" : 0, "TRICEPS: Cable Row Pull-Downs" : 0, "TRICEPS: Bar Pull-Downs" : 0, "BICEPS: Overhead Cable Curls" : 0, "TRICEPS: Assisted Dips" : 0, "LATS: Assisted Pull-Ups" : 0, "BACK: Bentover Dumbell Rows" : 0, "BICEPS: Dumbell Curls" : 0, "TRICEPS: Dumbell Kickbacks" : 0, "BICEPS: Barbell Curls" : 0, "TRICEPS: Skull Crushers" : 0, "TRICEPS: French Presses" : 0, "SHOULDERS: Arnold Presses" : 0, "SHOULDERS: Overhead Presses" : 0, "SHOULDERS: Hammer Flyes" : 0, "SHOULDERS: Cable Upward Rows" : 0, "SHOULDERS: Barbell Upward Rows" : 0, "SHOULDERS: Cable Lateral Raises" : 0, "SHOULDERS: Dumbell Lateral Raises" : 0, "DELTS: Dumbell Forward Raises" : 0, "DELTS: Cable Forward Raises" : 0]
    
    
    // ============================
    override func viewDidLoad()
    {
        //----------
        super.viewDidLoad()
        //----------
        if WCSession.isSupported()
        {
            session = WCSession.default()
            session!.delegate = self
            session!.activate()
            
        }
        
        self.theExercise = ""
        Shared.sharedInstance.saveOrLoadUserDefaults("db")
        self.thePickerView.selectRow(0, inComponent: 0, animated: false)
        self.saveUserDefaultIfNeeded()
        
    }
    // ============================
    //--
    //WCSessionProtocol
    override func viewWillAppear(_ animated: Bool)
    {
        if (WCSession.isSupported())
        {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
        }
    }
    
    // ============================
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void){
        DispatchQueue.main.async { () -> Void in}
        print("Activation complete")
    }
    // ============================
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    // ============================
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession){
        print("Session inactive")
    }
    // ============================
    @available(iOS 9.3, *)
    public func sessionDidDeactivate( _ session: WCSession){
        print("Session desactiver")
    }
   // ============================
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    // ============================
    //Sauvegarde l'information pour pouvoir copier
    @IBAction func saveToClipboard(_ sender: UIButton)
    {
        let alertController = UIAlertController(title: "Alerte", message: "Informations copiées", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        let unSortedEcerciseKeys = Array(self.exerciseAccountability.keys)
        UIPasteboard.general.string = unSortedEcerciseKeys.joined(separator: ",")
    }
    
    // ============================
    //Envoie les informations à la montre
    @IBAction func sendToWatch(_ sender: AnyObject)
    {
        
        var dictToSendWach: [String : String] = [:]

        for aWorkout in Shared.sharedInstance.theDatabase {
            let aDate = aWorkout.0
            let exercises = aWorkout.1
            print(exercises)
            var str = ""
            for i in 0..<exercises.count {
                let exerc = Array(exercises[i].keys)[0]
                str += "\(exerc) : \(exercises[i][exerc]!)\n"
            }
            dictToSendWach[aDate] = str
        }
        sendMessage(aDict: dictToSendWach)
    }
    
    // ============================
    //Ajoute l'exercice à la liste
    @IBAction func doneButton(_ sender: UIButton)
    {
        self.thePickerView.selectRow(0, inComponent: 0, animated: true)
        
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DateInFormat:String = dateFormatter.string(from: todaysDate)
        let newDate = Date(dateString:DateInFormat)
        self.theDatePicker.date = newDate
        
        self.theRepsField.text = ""
        self.theSetsField.text = ""
    }
    
    // ============================
    //Sauvegarde l'exercice dans les userDefaults
    fileprivate func saveUserDefaultIfNeeded()
    {
        //self.exerciseAccount.removeObjectForKey("exercises")
        
        if !self.checkForUserDefaultByName("exercises", andUserDefaultObject: self.exerciseAccount)
        {
            self.exerciseAccount.setValue(self.exerciseAccountability, forKey: "exercises")
        }
        else
        {
            self.exerciseAccountability = self.exerciseAccount.value(forKey: "exercises") as! [String : Int]
        }
    }
    
    // ============================
    //Regarde les userDefaults
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
    //methodes pour choix entrainement
    // ============================
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // ============================
    //Code pour le pickerView
     @objc(pickerView:viewForRow:forComponent:reusingView:) func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
       
        let pickerLabel = UILabel()
        var anArrayOfString = ["- CHOOSE EXERCISE -"]
        
        let unSortedEcerciseKeys = Array(self.exerciseAccountability.keys)
        let sortedExerciseKeys = unSortedEcerciseKeys.sorted(by: <)
        
        var tempStr = ""
        for exercise in sortedExerciseKeys
        {
            tempStr = "\(exercise): \(self.exerciseAccountability[exercise]!)"
            anArrayOfString.append(tempStr)
        }
        
       let titleData = anArrayOfString[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Caviar Dreams", size: 18.0)!,
                                                                         NSForegroundColorAttributeName:UIColor.white])
        pickerLabel.text = titleData
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.attributedText = myTitle
        
        return pickerLabel
    }
    
    // ============================
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return exerciseAccountability.count;   //*** self.exercise....
    }
    
    // ============================
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var anArrayOfString = ["NO DATA"]
        
        let unSortedEcerciseKeys = Array(self.exerciseAccountability.keys)
        
        let sortedExerciseKeys = unSortedEcerciseKeys.sorted(by: <)
        
        for exercise in sortedExerciseKeys
        {
            anArrayOfString.append(exercise)
        }
        
        self.theExercise = anArrayOfString[row]
    }
    
    // ============================
    //methodes pour choix date
    // ============================
    func datePickerChanged(_ datePicker:UIDatePicker) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        let strDate = dateFormatter.string(from: datePicker.date)
        return strDate
    }
    // ============================
    @IBAction func addSetButton(_ sender: UIButton)
    {
        self.addExercise()
    }
    // ============================
    @IBAction func hideKeyboard(_ sender: UIButton)
    {
        self.view.endEditing(true)
    }
    // ============================
    fileprivate func addExercise()
    {
        let theExercise = self.theExercise
        
        if self.exerciseAccountability[theExercise!] == nil
        {
            self.mAlterts("Choose an exercise...")
            return
        }
        
        if self.theRepsField.text == "" || self.theSetsField.text == ""
        {
            self.mAlterts("Choose reps and sets...")
            return
        }
        
        self.theDatabase = Shared.sharedInstance.getDatabase("db")
        let theDate = self.datePickerChanged(self.theDatePicker)
        let theReps = self.theRepsField.text
        let theSets = self.theSetsField.text
        let setsAndReps = theSets! + " x " + theReps!
        
        if self.theDatabase[theDate] == nil
        {
            self.theDatabase[theDate] = [[theExercise! : setsAndReps]]
        }
        else
        {
            self.theDatabase[theDate]!.append([theExercise! : setsAndReps])
        }
        
        Shared.sharedInstance.saveDatabase(self.theDatabase)
        self.accountForExercise(theExercise!)
        self.mAlterts(self.displayWorkout(theDate))
    }
    
    // ============================
    fileprivate func accountForExercise(_ exerciseName: String)
    {
        var count = self.exerciseAccountability[exerciseName]!
        count += 1
        self.exerciseAccountability[exerciseName] = count
        self.exerciseAccount.setValue(self.exerciseAccountability, forKey: "exercises")
        self.thePickerView.reloadAllComponents()
    }
    
    // ============================
    func mAlterts(_ theMessage: String)
    {
        let alertController = UIAlertController(title: "Workout Summary...", message:
            theMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // ============================
    func displayWorkout(_ theDate: String) -> String
    {
        var strForDisplay = ""
        
        for (a, b) in self.theDatabase
        {
            if a == theDate
            {
                for c in b
                {
                    for (d, e) in c
                    {
                        strForDisplay += "[\(e)] : \(d)\n"
                    }
                }
            }
        }
        
        return strForDisplay
    }
    
    // ============================
    func sendMessage(aDict: [String : String]) {
        //----------
        let messageToSend = ["Message" : aDict]
        //----------
        session.sendMessage(messageToSend, replyHandler: { (replyMessage) in
            //----------
            DispatchQueue.main.async(execute: { () -> Void in
            })
            //----------
        }) { (error) in
            print("error: \(error.localizedDescription)")
        }
        //----------
    }
    //----------------------------------------
}

//code pour le format de date
extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
}










