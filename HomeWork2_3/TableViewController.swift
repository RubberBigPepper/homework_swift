//
//  TableViewController.swift
//  HomeWork2_3
//
//  Created by Albert on 19.10.2020.
//

import UIKit
import Bond
import ReactiveKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    private var names = MutableObservableArray(NameGenerator.generator.nextNames(20))
    private var search = Property("") //маска поиска
 
    override func viewDidLoad() {
        super.viewDidLoad()

        //        c) UITableView с выводом 20 разных имён людей и две кнопки. Одна кнопка добавляет новое случайное имя в начало списка, вторая — удаляет последнее имя.
                //Список реактивно связан с UITableView.
        search //по другому связять маску фильтрации и список не удалось, это немного костыль, но знаний не хватает как сделать лучше
            .observeNext{_ in //интересно, почему тут не дает вставить [unowned self]
                self.names.batchUpdate { _ in //костыль тут - тупо говорим списку обновится
                }
            }
            .dispose(in: reactive.bag)
        
        names
            .filterCollection{ [unowned self] in //ну и сама фильтрация списка по маске, если маска пустая - пропускаем все элементы
                return !(self.search.value.count>0 && $0.lowercased().range(of: self.search.value) == nil)
            }
            .bind(to: tableView){ (dataSource, indexPath, tableView) ->
                UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
                let text = dataSource[indexPath.row]
                cell.labelName.text = text
                return cell
            }
            .dispose(in: reactive.bag)
        
        removeBtn.reactive.tap
            .observeNext{ [unowned self] in
                if self.names.count>0 {
                    self.names.remove(at: self.names.count - 1)
                }
            }
            .dispose(in: reactive.bag)
        
        addBtn.reactive.tap
            .observeNext {[unowned self] in
                self.names.insert(NameGenerator.generator.nextName(), at: 0)
            }
            .dispose(in: reactive.bag)
        
        makeSearchFilter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reactive.bag.dispose()
    }

    private func makeSearchFilter(){
//        f) Для задачи «c» добавьте поисковую строку. При вводе текста в поисковой строке, если текст не изменялся в течение двух секунд, выполните фильтрацию
        //имён по введённой поисковой строке (с помощью оператора throttle). Такой подход применяется в реальных приложениях при поиске, который отправляет
        //поисковый запрос на сервер, — чтобы не перегружать сервер и поисковая строка отправлялась на сервер, только когда пользователь закончит ввод (или
        //сделает паузу во вводе).
        
        //1 не понятно, почему throttle, а не debounce использовать
        //2 не понятно вообще как фильтровать
        
        searchTextField.reactive.text
            .debounce(for: 2.0)//мне кажется лучше debounce
            .map{//правим маску фильтрации
                $0 != nil ? $0!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines): ""
            }
            .bind(to: search)//передаем свойству
            .dispose(in: reactive.bag)
    }

    
}
