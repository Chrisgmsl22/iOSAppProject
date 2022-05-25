//
//  QuestionTableView.swift
//  EscenaConTabla
//
//  Created by Christian (Lap 10) on 25/03/22.
//

/**
 Dentro de esta clase actuará como el controlador que procesa
 las interacciones dentro de la vista en el Table View, es decir, en donde
 tendremos en # de preguntas que se tenga almacenado dentro del coreData para que asi se puedan visualizar todas
 */

import UIKit
import CoreData

class QuestionTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Lista de preguntas/respuestas
    var questionsAnswers : [QuestionAnswer] = [QuestionAnswer]()
    
    //Pregunta/respuesta
    var questionAnswer : QuestionAnswer = QuestionAnswer()
    
    
    var action : String = "add"
    var type = "*"
    
    var selectedIncex = -1
    
    //Para emplearse en el momento de darle tap, y que se colapsen
    var isCollapse = false
    
    //El filtro que se encuentra en la parte superior del table view
    @IBOutlet weak var segFiltro: UISegmentedControl!
    
    //Todo el table view
    @IBOutlet weak var tableViewCositas: UITableView!
    
    
    //Solo surge la primera vez que aparec la escena
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCositas.delegate = self
        tableViewCositas.dataSource = self
        segFiltro.selectedSegmentIndex = 3
        tableViewCositas.estimatedRowHeight = 60
        tableViewCositas.rowHeight = UITableView.automaticDimension
        
    }
    
    //cuando ya no se activa por primera vez
    override func viewDidAppear(_ animated: Bool) {
        
        recoverPeople(type: type)
        tableViewCositas.reloadData()
        //Recuperamos las personas y posterior se recarga la vista y los datos
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat  { //equivalente a un double
        
        
        //AL darle tap, se desplegará la pregunta
        if selectedIncex == indexPath.row && isCollapse == true {
            
            return 180
        
        } else {
            
            return 60
        }
    }
    
    @IBAction func segFilter(_ sender: UISegmentedControl) {
        
        
        switch segFiltro.selectedSegmentIndex {
            
        case 0...2:
            type = segFiltro.titleForSegment(at: segFiltro.selectedSegmentIndex)!
            break
        case 3:
            type = Types.All.rawValue
            break
        default:
            break
        }
        
        recoverPeople(type: type)
        tableViewCositas.reloadData()
        
    }
    
    //Área de las funciones
    
    
    
    /**
            Esta funcion nos recupera el contenido que tengamos almacenado dentro de nuestro core data, en este caso el nombre de la funcion se llama como "recoverPeople", ya que estoy tomano el archivo desde la vez que se hizo en clase y no cambie los nombres de algunas funciones para no alterar la app o descomponerla
     */
    func recoverPeople(type : String){
        
        let context = getContext()
        let fetchRequest : NSFetchRequest<QuestionAnswer> = QuestionAnswer.fetchRequest()
        
        if type == "*" {
            
            fetchRequest.predicate = NSPredicate(format: "type LIKE %@ OR type == nil", type)
            
        } else {
            
            fetchRequest.predicate = NSPredicate(format: "type LIKE %@", type)
            
        }
        
        //se intentan recuperar las pregunytas/respuestas
        do{
            questionsAnswers = try context.fetch(fetchRequest)
        
        } catch let error as NSError {
            
            print("No se pudieron recuperar las preguntas y respuestas \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return questionsAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as! QuestionCell
        
        let questionAnswer = questionsAnswers[indexPath.row]
        
        cell.lblQuestion.text = questionAnswer.question
        cell.lblAnswer.text = questionAnswer.answer
        
        return cell
    }
    
    
    func tableView (_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){
            (_, _, completionHandler) in
            
            let person = self.questionsAnswers[indexPath.row]
            self.deleteEntityPerson(person)
            self.recoverData()
            self.tableViewCositas.reloadData()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .destructive, title: nil){
            (_, _, completionHandler) in
            
            self.action = "edit"
            self.questionAnswer = self.questionsAnswers[indexPath.row]
            
            self.performSegue(withIdentifier: "seguePrincipalToEdit", sender: nil)
        }
        
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        
        return configuration
    }
    
    func getContext() -> NSManagedObjectContext{
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    

    func recoverData(){
        
        let context = getContext()
        let fetchRequest : NSFetchRequest<QuestionAnswer> = QuestionAnswer.fetchRequest()
        
        do{
            questionsAnswers = try context.fetch(fetchRequest)
        
        } catch let error as NSError {
            
            print("No se pudo recuperar \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func showEscene(_ sender: UIBarButtonItem) {
        
        action = "add"
        
        performSegue(withIdentifier: "seguePrincipalToEdit", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if selectedIncex == indexPath.row {
            
            if self.isCollapse == false {
                
                self.isCollapse = true
            
            } else {
                
                self.isCollapse = false
            }
        
        } else {
            
            self.isCollapse = true
        }
        
        self.selectedIncex = indexPath.row
        tableViewCositas.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePrincipalToEdit" {
            
            if action == "edit"
            {
                let viewControllerNew = segue.destination as! NewEditQuestion
                viewControllerNew.questionAnswer = questionAnswer
            }
        }
    }
    
    func deleteEntityPerson(_ questionAnswer: QuestionAnswer)
    {
        let context = getContext()
        context.delete(questionAnswer)
        
        do{
            try context.save()
            
        } catch let error as NSError {
            
            print("No se pudo recuperar \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func unwindToTable(_ sender: UIStoryboardSegue)
    {
        print("Comming from new person")
    }

}

