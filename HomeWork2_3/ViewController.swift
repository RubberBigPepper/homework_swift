//
//  ViewController.swift
//  HomeWork2_3
//
//  Created by Albert on 19.10.2020.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var incrementLabel: UILabel!
    @IBOutlet weak var labelRocket: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginTextField.rx.text.orEmpty
            .bind	
    }


    @IBAction func inscrementPressed(_ sender: Any) {
    }
    
    @IBAction func btnFirstPressed(_ sender: Any) {
    }
    
    @IBAction func btnSecondPressed(_ sender: Any) {
    }
}

