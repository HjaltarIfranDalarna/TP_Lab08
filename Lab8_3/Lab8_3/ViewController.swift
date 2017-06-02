//
//  ViewController.swift
//  Lab8_3
//
//  Created by Admin on 09.05.17.
//  Copyright (c) 2017 Parnasus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var studentNameTextField: UITextField!
   
    @IBOutlet weak var table: UITableView!
    
    var students: [NSManagedObject] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")! as UITableViewCell
        let student = students[indexPath.row]
        cell.textLabel?.text = student.value(forKey: "name") as? String //Заполняем текст ячейки таблицы значением ключа "name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate //Создаем ссылку на класс AppDelegate из файла AppDelegate.swift
            let managedObjectContext = appDelegate.managedObjectContext //Создаем ссылку на метод managedObjectContext из класса AppDelegate в файле AppDelegate.swift
            managedObjectContext!.delete(students[indexPath.row] as NSManagedObject) //Выбираем метод удаления объекта из модели данных students

            var error: NSError? = nil
            managedObjectContext?.save(&error)
            if (error == nil)
            {
                students.remove(at: indexPath.row) //Удаляем объект из модели students
                tableView.deleteRows(at: [indexPath], with: .left) //Удаляем строку из таблицы
            }
            else
            {
                print("Data removing error: \(error)") //В случае возникновения ошибки, выводим ее в консоль
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addStudentButton(_ sender: AnyObject) {
        if studentNameTextField.text == "" || studentNameTextField.text == "Введите данные!"
        {
            studentNameTextField.text = "Введите данные!"
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate //Создаем ссылку на класс AppDelegate из файла AppDelegate.swift
            let managedObjectContext = appDelegate.managedObjectContext //Создаем ссылку на объект managedObjectContext из класса AppDelegate
            let newObject = NSEntityDescription.insertNewObject(forEntityName: "Student", into:managedObjectContext!) as NSManagedObject //Создаем переменную, которая будет заносить новый объект в сущность "Students"
            newObject.setValue(studentNameTextField.text!, forKey: "name") //Значением нового объекта для ключа "name" будет являться текст из текстового поля studentNameTextField
           
            var error: NSError? = nil
            managedObjectContext?.save(&error)
            if (error == nil)
            {
                students.append(newObject) //Добавляем новый объект в модель данных students
                studentNameTextField.text! = "" //Очищаем текстовое поле
                self.table.reloadData() //Обновляем содержимое таблицы
                self.view.endEditing(true) //Убираем клавиатуру с экрана и выходим из режима редактировани
            }
            else
            {
                print("Data saving error: \(error)") //В случае возникновения ошибки, выводим ее в консоль
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Создаем ссылку на класс AppDelegate из файла AppDelegate.swift
        let managedObjectContext = appDelegate.managedObjectContext //Создаем ссылку на объект managedObjectContext из класса AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student") //Создаем запрос из сущности "Students"
        
        var error : NSError? = nil
        students = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]
        if (error != nil)
        {
            print("Data loading error: \(error)")
        }
        self.table.reloadData() //Обновляем содержимое таблицы
    }

}

