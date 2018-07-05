//
//  ViewController.swift
//  StripePayment
//
//  Created by NITV on 7/5/18.
//  Copyright © 2018 Own. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stripePaymentClicked(_ sender: Any) {
        StripeManager.shared.setupStripePaymentUI(withController: self, amount: 10)
        StripeManager.shared.stripePurchaseStatusBlock = {[weak self] (response) in
            guard let strongSelf = self else{return}
            switch response {
            case .success(let result):
                print("sucess payment")

                if let data = result.result.value as? NSDictionary {
                    print(data)
                    if let status = data["status"] as? String, status == "Successful"{
                        if let message = data["message"] as? String{
                            strongSelf.showPaymentSucessAlertMessage(title: "Congratulations", msg: message)
                        }
                    }
                    else{
                        if let message = data["message"] as? String{
                            strongSelf.showPaymentSucessAlertMessage(title: "Error", msg: message)
                        }
                        else{
                            strongSelf.showPaymentSucessAlertMessage(title: "Error", msg:" Error processing purchase")
                        }
                        
                    }
                    
                }
                
            case .failure(let error):
                print("failed payment \(error.localizedDescription)")
                strongSelf.showPaymentSucessAlertMessage(title: "Error", msg: error.localizedDescription)
            }
            
        }
    }
    
    func showPaymentSucessAlertMessage(title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("clicked ok")
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }

    
}

