//
//  StripeManager.swift
//  WTV_GO
//
//  Created by NITV on 5/2/18.
//  Copyright © 2018 nitv. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

var controller: UIViewController? = nil
var amountToPay = 0.0

//let sharedInstance = StripeManager()
enum StripeHandlerAlertType{
    case failed
    case succeed
    
    func message() -> String{
        switch self {
        case .failed: return "Purchase can not succeed. Please try again"
        case .succeed: return "Succeed."
        }
    }
}

class StripeManager: NSObject,STPAddCardViewControllerDelegate{

    static let shared = StripeManager()
    let addCardViewController = STPAddCardViewController()
    var stripePurchaseStatusBlock: ((Result) -> Void)?
    
    private override init() {
        // private
    }
    
    func setupStripePaymentUI(withController: UIViewController?, amount: Double){
        //setup card viewcontroller
        amountToPay = amount
        controller = withController
        
        addCardViewController.delegate = self
        
        self.customizeYourTheme()
        //present  addcardViewController
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        controller?.present(navigationController, animated: true, completion: nil)
        
    }
    func customizeYourTheme(){
//            STPTheme.default().accentColor = self.colorWithRGB(R: 32.0, G: 23.0, B: 47.0)
//            STPTheme.default().primaryBackgroundColor = self.colorWithRGB(R: 125.0, G: 44.0, B: 107)
//            STPTheme.default().primaryForegroundColor = Utils.colorWithRGB(R: 125.0, G: 44.0, B: 107)
//            STPTheme.default().secondaryBackgroundColor = UIColor.white
//            STPTheme.default().secondaryForegroundColor = UIColor.white
//            STPTheme.default().errorColor = self.colorWithRGB(R: 125.0, G: 44.0, B: 107)
//            STPTheme.default().font = self.setFontWithSize(size: 14, type: "regular")
//            STPTheme.default().emphasisFont = self.setFontWithSize(size: 14, type: "regular")
        
    }
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        addCardViewController.dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.verifyToken(with: token, amount: amountToPay) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                //Post Notification
                addCardViewController.dismiss(animated: true, completion: {
                    self.stripePurchaseStatusBlock?(result)
                })
               // addCardViewController.dismiss(animated: true, completion: nil)

            // 2
            case .failure(let error):
                completion(error)
                self.stripePurchaseStatusBlock?(Result.failure(error))
                
            }
        }
    }
    func colorWithRGB(R: Float, G: Float , B: Float) ->UIColor{
        
        let color = UIColor(red: CGFloat (R/255.0), green: CGFloat (G/255.0), blue: CGFloat(B/255.0), alpha: CGFloat(1.0))
        
        return color
    }
    func setFontWithSize(size: CGFloat?, type: String?) -> UIFont{
        var fontSize: CGFloat = 14
        var fontName = "HelveticaNeue-Thin"
        if let ftype = type{
            switch ftype {
            case "regular":
                fontName = "HelveticaNeue-Thin"
                break
            case "mid":
                fontName = "HelveticaNeue-Mid"
                break
            case "bold":
                fontName = "HelveticaNeue-Bold"
                break
            default:
                break
            }
        }
        if let fsize = size{
            fontSize = fsize
        }
        return UIFont(name: fontName, size: fontSize)!
    }
}

