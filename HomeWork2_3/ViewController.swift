//
//  ViewController.swift
//  HomeWork2_3
//
//  Created by Albert on 19.10.2020.
//

import UIKit
//import Bond
//import ReactiveKit
import RxSwift
import RxCocoa

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
    
    private var incrementValue = 0
    private let rxBag = RxSwift.DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        rxBag = DisposeBag()
        makePasswordLogin()
        makeIncrementBtn()
        makeCombindedBtn()
        makeDelayedSearch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        reactive.bag.dispose()
    }
    
    private func makePasswordLogin(){
//   В лейбл выводится «некорректная почта», если введённая почта некорректна.
//    Если почта корректна, но пароль меньше шести символов, выводится: «Слишком короткий пароль».
//        В противном случае ничего не выводится. Кнопка «Отправить» активна, если введена корректная почта и
//        пароль не менее шести символов.
                
        Observable.combineLatest(loginTextField.rx.text.asObservable(), passwordTextField.rx.text.asObservable())
            { email, pass in //со статичной функцией (ее стоит вынести в файл утилит) не будет утечки
                if !Utils.isEmailCorrect(email ?? ""){
                    return "Некорректная почта"
                }
                if pass == nil || pass!.count<6 {
                    return "Слишком короткий пароль"
                }
                return ""
            }
            .bind(to: resultLabel.rx.text)
            .disposed(by: rxBag)
        
        Observable.combineLatest(loginTextField.rx.text.asObservable(), passwordTextField.rx.text.asObservable())
            { email, pass in //со статичной функцией (ее стоит вынести в файл утилит) не будет утечки
                return Utils.isEmailCorrect(email ?? "") && pass != nil && pass!.count > 5
            }
            .bind(to: sendBtn.rx.isEnabled)
            .disposed(by: rxBag)
    }
    
    private func makeIncrementBtn(){
//        Лейбл и кнопку. В лейбле выводится значение counter (по умолчанию 0), при нажатии counter увеличивается на 1.
        incrementBtn.rx.tap
            .map{   [unowned self] in
                    self.incrementValue = self.incrementValue + 1
                    return String(self.incrementValue)
            }
            .bind(to: incrementLabel.rx.text)
            .disposed(by: rxBag)
    }
    
    private func makeCombindedBtn(){
//        e) Две кнопки и лейбл. Когда на каждую кнопку нажали хотя бы один раз, в лейбл выводится: «Ракета запущена».
        Observable.combineLatest(firstBtn.rx.tap, secondBtn.rx.tap)
        .map{_ in //так избежим утечки памяти
            return "Ракета запущена"
        }
        .bind(to: labelRocket.rx.text)
        .disposed(by: rxBag)
    }
    
    private func makeDelayedSearch(){
//        b) Текстовое поле для ввода поисковой строки. Реализуйте симуляцию «отложенного» серверного запроса при вводе текста: если не было внесено никаких
        //изменений в текстовое поле в течение 0,5 секунд, то в консоль должно выводиться: «Отправка запроса для <введенный текст в текстовое поле>».
        
        searchTextField.rx.text.asObservable()
            .debounce( .milliseconds(500) , scheduler: MainScheduler.instance)
            .filter{
                $0 != nil && $0!.count > 0
            }
            .map{
                return $0!
            }
            .bind{
                print("Отправка запроса для \($0)")
            }
            .disposed(by: rxBag)
    }

}

