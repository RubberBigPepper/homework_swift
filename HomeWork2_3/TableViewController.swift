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
    private var search = "" //маска поиска
 
    override func viewDidLoad() {
        super.viewDidLoad()

//        c) UITableView с выводом 20 разных имён людей и две кнопки. Одна кнопка добавляет новое случайное имя в начало списка, вторая — удаляет последнее имя.
        //Список реактивно связан с UITableView.
        names
            .bind(to: tableView){ (dataSource, indexPath, tableView) ->
            UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
            let text = dataSource[indexPath.row]
            cell.labelName.text = text
            cell.isHidden = self.search.count>0 && text.lowercased().range(of: self.search) == nil
            return cell
        }
        
        removeBtn.reactive.tap
            .observe{ _ in
                if self.names.count>0 {
                    self.names.remove(at: self.names.count - 1)
                }
            }
        
        addBtn.reactive.tap
            .observe { _ in
                self.names.insert(NameGenerator.generator.nextName(), at: 0)
            }
        
        makeSearchFilter()
    }

    private func makeSearchFilter(){
//        f) Для задачи «c» добавьте поисковую строку. При вводе текста в поисковой строке, если текст не изменялся в течение двух секунд, выполните фильтрацию
        //имён по введённой поисковой строке (с помощью оператора throttle). Такой подход применяется в реальных приложениях при поиске, который отправляет
        //поисковый запрос на сервер, — чтобы не перегружать сервер и поисковая строка отправлялась на сервер, только когда пользователь закончит ввод (или
        //сделает паузу во вводе).
        
        //1 не понятно, почему throttle, а не debounce использовать
        //2 не понятно вообще как фильтровать
        
        searchTextField.reactive.text
            .ignoreNils()
            .debounce(for: 2.0)
            .filter{ $0.count > 0}
            .observeNext{ self.search = $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    
}
