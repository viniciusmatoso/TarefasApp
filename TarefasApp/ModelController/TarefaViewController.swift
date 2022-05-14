//
//  TarefaViewController.swift
//  AppTarefas
//
//  Created by Marcus Vinicius Alves Matoso on 30/11/21.
//

import UIKit
import CoreData

class TarefaViewController: UIViewController {

    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var tarefa: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeFirstResponder()
        if tarefa != nil {
            self.navigationItem.title = "Atualizar"
            if let textoRecuperado = tarefa.value(forKey: "texto"){
                self.texto.text = String(describing: textoRecuperado)
            }
            
        }else {
            self.texto.text = ""
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
            
    }
    
    @IBAction func salvar(_ sender: Any) {
        
        if tarefa != nil{
            self.atualizarTarefa()
        }else {
            self.salvarTarefa()
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func atualizarTarefa(){
        tarefa.setValue(self.texto.text, forKey: "texto")
        tarefa.setValue(Date(), forKey: "data")
        
        do{
            try context.save()
        } catch let error {
            print("Erro ao atualizar tarefa: \(error.localizedDescription) ")
        }
    }
    
    func salvarTarefa(){
        let novaTarefa = NSEntityDescription.insertNewObject(forEntityName: "Tarefa", into: context)
        
        novaTarefa.setValue(self.texto.text, forKey: "texto")
        novaTarefa.setValue(Date(), forKey: "data")
        
        do{
            try context.save()
        } catch let error {
            print("Erro ao salvar tarefa: \(error.localizedDescription) ")
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
