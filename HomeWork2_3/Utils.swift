//
//  Utils.swift
//  HomeWork2_3
//
//  Created by Albert on 21.10.2020.
//

import Foundation

class Utils{
    public static func isEmailCorrect(_ email:String)->Bool{//проверка корректности почты
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }    
}
