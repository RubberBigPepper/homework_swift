//
//  ViewController.swift
//  HomeWork2_3
//
//  Created by Albert on 19.10.2020.
//

import UIKit
import Bond
import ReactiveKit

class ViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var incrementLabel: UILabel!
    @IBOutlet weak var labelRocket: UILabel!
    
    @IBOutlet weak var incrementBtn: UIButton!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    
    private var incrementValue = Property<Int>(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        makePasswordLogin()
        makeIncrementBtn()
        makeCombindedBtn()
        makeDelayedSearch()
    }
    
    private func isEmailCorrect(_ email:String)->Bool{//проверка корректности почты
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    private func makePasswordLogin(){
//   В лейбл выводится «некорректная почта», если введённая почта некорректна.
//    Если почта корректна, но пароль меньше шести символов, выводится: «Слишком короткий пароль».
//        В противном случае ничего не выводится. Кнопка «Отправить» активна, если введена корректная почта и
//        пароль не менее шести символов.
                
        combineLatest(loginTextField.reactive.text.ignoreNils(), passwordTextField.reactive.text.ignoreNils())
            { email, pass in
                return self.isEmailCorrect(email) ? (pass.count<6 ? "Слишком короткий пароль" : "") : "Некорректная почта"
            }
            .bind(to: resultLabel.reactive.text)
        
        combineLatest(loginTextField.reactive.text.ignoreNils(), passwordTextField.reactive.text.ignoreNils())
            { email, pass in
                return self.isEmailCorrect(email) && pass.count > 5
            }
          .bind(to: sendBtn.reactive.isEnabled)
    }
    
    private func makeIncrementBtn(){
//        Лейбл и кнопку. В лейбле выводится значение counter (по умолчанию 0), при нажатии counter увеличивается на 1.
        incrementBtn.reactive.tap
            .observeNext{ self.incrementValue.value = self.incrementValue.value + 1
            }
        incrementValue.map{ _ in String (self.incrementValue.value) }
            .bind(to: incrementLabel.reactive.text)
    }
    
    private func makeCombindedBtn(){
//        e) Две кнопки и лейбл. Когда на каждую кнопку нажали хотя бы один раз, в лейбл выводится: «Ракета запущена».
        combineLatest(firstBtn.reactive.tap, secondBtn.reactive.tap)
            .observe{ _ in self.labelRocket.text = "Ракета запущена" }
    }
    
    private func makeDelayedSearch(){
//        b) Текстовое поле для ввода поисковой строки. Реализуйте симуляцию «отложенного» серверного запроса при вводе текста: если не было внесено никаких
        //изменений в текстовое поле в течение 0,5 секунд, то в консоль должно выводиться: «Отправка запроса для <введенный текст в текстовое поле>».
        searchTextField.reactive.text
            .ignoreNils()
            .debounce(for: 0.5)
            .filter{ $0.count > 0}
            .observeNext{ print("Отправка запроса для \($0)") }
    }

}

