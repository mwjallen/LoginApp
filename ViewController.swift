//
//  ViewController.swift
//  LoginApp
//
//  Created by Michael W J Allen on 05/08/2017.
//  Copyright © 2017 Code2Run. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loggedinLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var showLogin: UIButton!

    
    var username = ""
    var password = ""
    var isLoggedIn = false
    
    //setup the data storage
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func showLoginButton(_ sender: UIButton) {
        
        //show the UIControls
        usernameLabel.isHidden = false
        passwordLabel.isHidden = false
        usernameField.isHidden = false
        passwordField.isHidden = false
        loginButton.isHidden = false
        
        loggedinLabel.isHidden = true
        showLogin.isHidden = true
    
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        //if the boxes are empty load message
            if usernameField.text != "" && passwordField.text != "" {
                
                username = usernameField.text!
                password = passwordField.text!
                
                isLoggedIn = login(user: username, pass: password)
                
                if isLoggedIn == true {
                    
                    //hide the UIControls
                    usernameLabel.isHidden = true
                    passwordLabel.isHidden = true
                    usernameField.isHidden = true
                    passwordField.isHidden = true
                    loginButton.isHidden = true
                    
                    //show the success label
                    loggedinLabel.text = "Success, \(username) you have logged in!"
                    loggedinLabel.isHidden = false

                }
                
            } else {
                
                //load message
                let alertController = UIAlertController(title: "Log In Message", message:
                    "You must complete both fields", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                deleteAllRecords()
                
            }
    }

    
    func deleteAllRecords() {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            
            try context.execute(deleteRequest)
            try context.save()
            
        } catch {
            
            //load message
            let deleteController = UIAlertController(title: "Error Message", message:
                "An error occured", preferredStyle: UIAlertControllerStyle.alert)
            deleteController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(deleteController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let username = result.value(forKey: "username") as? String{
                        
                        loggedinLabel.text = "Welcome \(username)- you're logged in"
                        loggedinLabel.isHidden = false
                        
                    }
                }
                
            } else {
                
                //show the UIControls
                usernameLabel.isHidden = false
                passwordLabel.isHidden = false
                usernameField.isHidden = false
                passwordField.isHidden = false
                loginButton.isHidden = false
                
                showLogin.isHidden = true

            }
            
        } catch {
            
            //load message
            let errorController = UIAlertController(title: "User Error", message:
                "Could not load the user details", preferredStyle: UIAlertControllerStyle.alert)
            errorController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(errorController, animated: true, completion: nil)
            
        }
    }
    
    func login(user: String, pass: String)-> Bool{
        
        //add the user to the database
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        newUser.setValue(user, forKey: "username")
        newUser.setValue(pass, forKey: "password")
        
        do {
            try context.save()
            
            isLoggedIn = true
  
        } catch {
            
            //load message
            let errorController = UIAlertController(title: "User Error", message:
                "You are not logged in", preferredStyle: UIAlertControllerStyle.alert)
            errorController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(errorController, animated: true, completion: nil)
            
        }
        
        return isLoggedIn
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

