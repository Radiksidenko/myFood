//
//  ViewController.swift
//  myFood
//
//  Created by Radomyr Sidenko on 06.06.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    
    @IBOutlet weak var output: UITextView!
    @IBOutlet weak var nameInput: UITextField!
    var loadBar:UIView!
    
    private let service = GTLRSheetsService()
    var ourName: String!
    var day = "Понедельник"
    
    ////////////////////////Spinner/////////////////////
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    /////////////////////////////////////////////
    
    
    func weekDay(_ dayWeek:Int) -> String{
        switch dayWeek {
        case 2:
            return "Понедельник"
        case 3:
            return "Вторник"
        case 4:
            return "Среда"
        case 5:
            return "Четверг"
        case 6:
            return "Пятница"
        default:
            return "Понедельник"
        }
    }
    
    override func viewDidLoad() {
        print("/////",UserDefaults.standard.string(forKey: "login"),"\t",UserDefaults.standard.string(forKey: "name"),"/////")
        super.viewDidLoad()
        let weekday = Calendar.current.component(.weekday, from: Date())
        day = "\(weekDay(weekday))"
        print("\(weekDay(weekday)) ")
        loadBar = ViewController.displaySpinner(onView: self.view)
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            ViewController.removeSpinner(spinner: loadBar)
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            ViewController.removeSpinner(spinner: loadBar)
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            foodMenu()
            ourName = UserDefaults.standard.string(forKey: "name")
//            print(ourName)
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        if(nameInput.text != ""){
            ourName = nameInput.text
        }
        foodMenu()
    }
    
    ///////////////////////sheet data/////////////////////
    func foodMenu() {
        output?.text = "Getting sheet data..."
        let spreadsheetId = "1NrPDjp80_7venKB0OsIqZLrq47jbx9c-lrWILYJPS88"
        let range = "\(day) !A1:M"
        print(range)
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:range)
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            print(error.localizedDescription)
            return
        }
        
        let rows = result.values!
        
        if rows.isEmpty {
            output?.text = "No data found."
            return
        }
        
        var list = ""
        
        for row in rows {
            let name = row[0] as! String
            if( name.lowercased() == ourName.lowercased()){
                list += "Name: \(name)\n"
                var count = 0
                for (index, ro) in row.enumerated(){
//                    print(index, ro)
                    if(ro as! String == "1"){
                        count+=1
//                        print("Eat \(rows[1][index])")
                        list += "\(count)) \t \(rows[1][index])\n"
                    }
                }
            }
        }
        if(list == ""){
            list += "No user with this name"
        }
        output?.text = "\(day)\n \(list)"
    }
    /////////////////////////////////////////////
    
    ///////////////////////window alert/////////////////////
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    /////////////////////////////////////////////
    
    ///////////////////////SignOut/////////////////////
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.set("", forKey: "login")
        UserDefaults.standard.set("", forKey: "name")
        print("//////////LOL")
        print("/////",UserDefaults.standard.string(forKey: "login"),"\t",UserDefaults.standard.string(forKey: "name"),"/////")
        let appDeligate = UIApplication.shared.delegate as? AppDelegate
        let main = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()
        appDeligate?.window?.rootViewController = main
        
        
    }
    /////////////////////////////////////////////
    
    @IBOutlet weak var newName: UITextField!
    @IBAction func specifyName(_ sender: Any) {
        if(!(newName.text?.isEmpty)!){
            UserDefaults.standard.set(newName.text, forKey: "name")
        }
        let appDeligate = UIApplication.shared.delegate as? AppDelegate
        let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        appDeligate?.window?.rootViewController = main
    }
    
    @IBAction func changeDay(_ sender: UIButton) {
        let dayBut = sender.currentTitle
        day = dayBut!
        foodMenu()
    }
    
}
