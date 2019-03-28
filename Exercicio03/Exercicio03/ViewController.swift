//
//  ViewController.swift
//  Exercicio03
//
//  Created by user151751 on 3/26/19.
//  Copyright © 2019 user151751. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var birthdateTextField: UILabel!
    @IBOutlet weak var ageLabel: UITextField!
    enum AgeError: Error {
        case emptyText
        case invalidFormat
        case invalidDate
        case futureBirthDay
        case unknow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func actionButtonDidTap(_ sender: Any) {
        do{
            birthdateTextField.text = "\(try calculateAge(from: ageLabel.text, dateFormat: "dd/MM/yyyy")) anos"
        } catch AgeError.emptyText {
            birthdateTextField.text = "Data não informada!"
        } catch AgeError.futureBirthDay {
            birthdateTextField.text = "Prevendo o futuro!?"
        } catch AgeError.invalidDate {
            birthdateTextField.text = "Data inválida!"
        } catch AgeError.invalidFormat {
            birthdateTextField.text = "Formato inválido!"
        } catch AgeError.unknow {
            birthdateTextField.text = "Erro desconhecido!"
        } catch {
            birthdateTextField.text = "Erro inesperado: \(error)."
        }
    }
    
    private func calculateAge(from text: String?, dateFormat: String) throws -> Int {
        do {
            if let _text = text {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "pt_BR")
                dateFormatter.dateFormat = dateFormat
                
                if let birthday = dateFormatter.date(from: _text) {
                    
                    let now = Date()
                    guard birthday <= now else { throw AgeError.futureBirthDay }
                    
                    if let age = Calendar.current.dateComponents([.year], from: birthday, to: now ).year {
                        return age
                    } else {
                        throw AgeError.invalidDate
                    }
                    
                } else{
                    throw AgeError.invalidFormat
                }
                
            } else { throw AgeError.emptyText }
        } catch {
            throw AgeError.unknow
        }
    }
}

