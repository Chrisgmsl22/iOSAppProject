//
//  NewEditQuestion.swift
//  EscenaConTabla
//
//  Created by Christian (Lap 10) on 30/03/22.
//

import UIKit
import CoreData

class NewEditQuestion: UIViewController {

    var questionAnswer : QuestionAnswer?
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var segFilter: UISegmentedControl!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        settingView()
        
    }
    
    func settingView(){
        
        if questionAnswer != nil
        {
            navigationItem.title = "Edit Person"
            txtName.text = questionAnswer?.question
            txtLastName.text = questionAnswer?.answer
            
            if questionAnswer?.type == "First" {
                
                segFilter.selectedSegmentIndex = Int(Types.First.rawValue)!
                
            } else {
                
                if questionAnswer?.type == "Second"
                {
                    segFilter.selectedSegmentIndex =  Int(Types.Second.rawValue)!
                    
                } else {
                    
                    segFilter.selectedSegmentIndex =  Int(Types.Third.rawValue)!
                }
            }
                
        }
        
    }
    
    @IBAction func addEditPerson(_ sender: UIButton) {
        
        if let question = txtName.text, let answer = txtLastName.text, let type = segFilter.titleForSegment(at: segFilter.selectedSegmentIndex) {
            
            print(type)
            
            if navigationItem.title == "Edit Person"
            {
                updateEntityPerson(questionAnswer: questionAnswer!, question: question, answer: answer, type: type)
            
            } else {
                
                saveEntityPerson(question, answer, type)
                
            }
        }
        
    }
    
    func getContext() -> NSManagedObjectContext{
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveEntityPerson(_ question : String, _ answer : String, _ type : String)
    {
        let context = getContext()
        
        let entityQuestionAnswer = NSEntityDescription.entity(forEntityName: "QuestionAnswer", in: context)!
        let questionAnswerManaged = NSManagedObject(entity: entityQuestionAnswer, insertInto: context) as! QuestionAnswer
    
        questionAnswerManaged.question = question
        questionAnswerManaged.answer = answer
        questionAnswerManaged.type = type
        
        do{
            try context.save()
        
        } catch let error as NSError {
            
            print("No se pudo salvar: \(error), \(error.userInfo)")
        }
        
        
    }
    
    func updateEntityPerson(questionAnswer : QuestionAnswer, question : String, answer : String, type : String)
    {
        let context = getContext()
        let personManaged = questionAnswer as NSManagedObject
        personManaged.setValue(question, forKey: "question")
        personManaged.setValue(answer, forKey: "answer")
        personManaged.setValue(type, forKey: "type")
        
        do{
            try context.save()
            
        } catch let error as NSError {
            
            print("No se pudo actualizar: \(error), \(error.userInfo)")
        }
    }
    
}
