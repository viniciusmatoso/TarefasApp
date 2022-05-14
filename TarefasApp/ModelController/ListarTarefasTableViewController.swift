
import UIKit
import CoreData

class ListarTarefasTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var tarefas: [NSManagedObject] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarTarefas()
    }
    
    func recuperarTarefas(){
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Tarefa")
        
        let ordenacao = NSSortDescriptor(key: "data", ascending: false)
        requisicao.sortDescriptors = [ordenacao]
        
        do{
            let tarefasRecuperadas = try context.fetch(requisicao)
            self.tarefas = tarefasRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
            
        }catch let error{
            print("Erro ao recuperar as tarefas: \(error.localizedDescription)")
        }
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tarefas.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let tarefa = self.tarefas[indice]
        performSegue(withIdentifier: "verTarefa", sender: tarefa)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verTarefa" {
            
            let backItem = UIBarButtonItem()
            backItem.title = "Voltar"
            navigationItem.backBarButtonItem = backItem
            
            let viewDestino = segue.destination as! TarefaViewController
            viewDestino.tarefa = sender as? NSManagedObject
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let tarefa = self.tarefas[indexPath.row]
        let texto = tarefa.value(forKey: "texto")
        let data = tarefa.value(forKey: "data")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        
        let novaData = dateFormatter.string(from: data as! Date)
        
        cell.textLabel?.text = texto as? String
        cell.detailTextLabel?.text = novaData
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indice = indexPath.row
            let tarefa = self.tarefas[indice]
            
            self.context.delete(tarefa)
            self.tarefas.remove(at: indice)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do{
                try self.context.save()
            }catch let error{
                print("Erro ao recuperar as tarefas: \(error.localizedDescription)")
            }
        }
         
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
