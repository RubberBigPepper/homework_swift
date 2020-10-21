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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reactive.bag.dispose()
    }
    
    private func makePasswordLogin(){
//   В лейбл выводится «некорректная почта», если введённая почта некорректна.
//    Если почта корректна, но пароль меньше шести символов, выводится: «Слишком короткий пароль».
//        В противном случае ничего не выводится. Кнопка «Отправить» активна, если введена корректная почта и
//        пароль не менее шести символов.
                
        combineLatest(loginTextField.reactive.text.ignoreNils(), passwordTextField.reactive.text.ignoreNils())
            { email, pass in //со статичной функцией (ее стоит вынести в файл утилит) не будет утечки
                return Utils.isEmailCorrect(email) ? (pass.count<6 ? "Слишком короткий пароль" : "") : "Некорректная почта"
            }
            .bind(to: resultLabel.reactive.text)
        
        combineLatest(loginTextField.reactive.text.ignoreNils(), passwordTextField.reactive.text.ignoreNils())
            { email, pass in //со статичной функцией (ее стоит вынести в файл утилит) не будет утечки
                return Utils.isEmailCorrect(email) && pass.count > 5
            }
            .bind(to: sendBtn.reactive.isEnabled)
            .dispose(in: reactive.bag)
    }
    
    private func makeIncrementBtn(){
//        Лейбл и кнопку. В лейбле выводится значение counter (по умолчанию 0), при нажатии counter увеличивается на 1.
        incrementBtn.reactive.tap
            .observeNext{ [unowned self] in
                self.incrementValue.value = self.incrementValue.value + 1
            }
            .dispose(in: reactive.bag)
        incrementValue.map{ String ($0) }
            .bind(to: incrementLabel.reactive.text)
    }
    
    private func makeCombindedBtn(){
//        e) Две кнопки и лейбл. Когда на каждую кнопку нажали хотя бы один раз, в лейбл выводится: «Ракета запущена».
        combineLatest(firstBtn.reactive.tap, secondBtn.reactive.tap)
            .map{_ in //так избежим утечки памяти
                return "Ракета запущена"
            }
            .bind(to: labelRocket.reactive.text)
/*            .observe{ _ in //интересно, а как тут избежать утечки?
                self.labelRocket.text = "Ракета запущена"
            }
            .dispose(in: reactive.bag)*/
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

