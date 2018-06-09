//
//  LoginController.swift
//  myFood
//
//  Created by Radomyr Sidenko on 07.06.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

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

class LoginController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    @IBOutlet weak var nameUser: UITextField!
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
        // Add a UITextView to display output.
        signInButton.frame = view.bounds
        signInButton.frame = CGRect(origin: CGPoint(x: (UIScreen.main.bounds.width/2)-50,y : UIScreen.main.bounds.height/2), size: CGSize(width: 70, height: 100))
        signInButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    ////////////////////////Sign In/////////////////////////////////////
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            
            var ourName = user.profile.name
            print(ourName)
            UserDefaults.standard.set("login", forKey: "login")
            
            if(!(nameUser.text?.isEmpty)!){
                UserDefaults.standard.set(nameUser.text, forKey: "name")
            }else{
                UserDefaults.standard.set(ourName, forKey: "name")
            }

            showListPage()
        }
    }
    /////////////////////////////////////////////////////////////////////
    
    ////////////////////////Go to main page/////////////////////////////////////
    func showListPage(){
        let appDeligate = UIApplication.shared.delegate as? AppDelegate
        let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        appDeligate?.window?.rootViewController = main
    }
    /////////////////////////////////////////////////////////////////////
    
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
    /////////////////////////////////////////////////////////////////////
    
    ///////////////////keyBoard/////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    ////////////////////////////////////////////
    

    
    
    
}
