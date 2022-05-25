//
//  Prhases.swift
//  EscenaConTabla
//
//  Created by ChristianGM on 20/05/22.
//


/**
    Para hacer uso de la API, en mi caso opté por usar una API que genera frases de programafor al azar, de
    manera que dentro del sistema y cada que quisiera obtener una frase nueva, es donde se accede al codigo para
    hacerla funcionar y recargar los mensajes
 */
import UIKit

struct QuoteData : Codable {
    
    var en : String
    var author : String
    var id : String
    
    
    
}


//Creamos una clase que fungirá como plantilla de las frases indicadas
class Prhases: UIViewController {
    
    
    //Los label que harán referencia la frase y el nombre del autor de dicha frase
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData {
            
            quoteData in
            
            self.lblText.text = quoteData.en
            self.lblAuthor.text = quoteData.author
        }
    }
    

    //Boton que hace referencia al recargar y mostrar una frase completamente diferente
    @IBAction func reloadData(_ sender: Any) {
        
        loadData { quoteData in
            
            print(quoteData)
            self.lblText.text = quoteData.en
            self.lblAuthor.text = quoteData.author
        }
    }
    
    func loadData(completion: @escaping (QuoteData) -> Void){
        
        //La url de la API de donde obtendremos el contenido
        let urlString = "https://programming-quotes-api.herokuapp.com/quotes/random"
        
        
        //Codigo obtenido del libro
        if let url = URL(string: urlString)
        {
            if let data = try? Data(contentsOf: url)
            {
                let decodificador = JSONDecoder()
                
                if let datosDecodificados = try? decodificador.decode(QuoteData.self, from: data)
                {
                    //Aqui se desplega la informacion de la APi dentro de los labels creados en la Vista
                    self.lblText.text = datosDecodificados.en
                    self.lblAuthor.text = "- \(datosDecodificados.author)"
                } else {
                    print("Third if")
                }
            } else {
                
                print("Second if")
            }
        } else {
            
            print("First if")
        }
    }
    
    

}
