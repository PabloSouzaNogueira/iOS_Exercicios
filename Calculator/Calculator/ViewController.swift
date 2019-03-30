import UIKit

class ViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private weak var digit0Button: UIButton!
    @IBOutlet private weak var digit1Button: UIButton!
    @IBOutlet private weak var digit2Button: UIButton!
    @IBOutlet private weak var digit3Button: UIButton!
    @IBOutlet private weak var digit4Button: UIButton!
    @IBOutlet private weak var digit5Button: UIButton!
    @IBOutlet private weak var digit6Button: UIButton!
    @IBOutlet private weak var digit7Button: UIButton!
    @IBOutlet private weak var digit8Button: UIButton!
    @IBOutlet private weak var digit9Button: UIButton!
    @IBOutlet private weak var cleanButton: UIButton!
    @IBOutlet private weak var sumOpButton: UIButton!
    @IBOutlet private weak var subtractOpButton: UIButton!
    @IBOutlet private weak var timesOpButton: UIButton!
    @IBOutlet private weak var divideOpButton: UIButton!
    @IBOutlet private weak var equalButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!

    // MARK: - Stored Properties

    private let calculator = Calculator()
    private var firstValue: Int = 0
    private var secondValue: Int = 0
    private var operation: Calculator.Operation = Calculator.Operation.sum
    private var calculating: Bool = true
    
    

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        resultLabel.text = "0"
        
        registerTouchEvents()
    }

    // MARK: -

    /// Registra o método que será acionado ao tocar em cada um dos eventos.
    private func registerTouchEvents() {
        let digitButtons = [digit0Button, digit9Button, digit8Button,
                            digit7Button, digit6Button, digit5Button,
                            digit4Button, digit3Button, digit2Button,
                            digit1Button]

        let operationButtons = [sumOpButton, subtractOpButton, timesOpButton, divideOpButton]

        digitButtons.forEach { $0?.addTarget(self, action: #selector(digitTap), for: .touchUpInside) }
        operationButtons.forEach { $0?.addTarget(self, action: #selector(operationTap(sender:)), for: .touchUpInside) }
        cleanButton.addTarget(self, action: #selector(clearTap), for: .touchUpInside)
        equalButton.addTarget(self, action: #selector(makeOperation), for: .touchUpInside)
    }

    /// Esse método é responsável por adicionar um dígito na calculadora
    /// - Parameter sender: Referência do botão que está executando a ação
    @objc func digitTap(sender: UIButton) {
        
        var digit: String
        
        switch sender {
            case digit0Button:
                digit = "0"
            case digit1Button:
                digit = "1"
            case digit2Button:
                digit = "2"
            case digit3Button:
                digit =  "3"
            case digit4Button:
                digit =  "4"
            case digit5Button:
                digit =  "5"
            case digit6Button:
                digit =  "6"
            case digit7Button:
                digit =  "7"
            case digit8Button:
                digit =  "8"
            case digit9Button:
                digit =  "9"
            default:
                return
        }
        
        if calculating {
            resultLabel.text = digit
            calculating = false
        } else {
            resultLabel.text! += digit
        }
        secondValue = Int(resultLabel.text!)!
    }

    /// Método acionado quando o botão AC é tocado.
    @objc func clearTap() {
        resultLabel.text = "0"
        firstValue = 0
        secondValue = 0
        calculating = true
    }

    /// Metódo responsável por escolhe qual a operação será realizada.
    /// - Parameter sender: Referência do botão de operação que foi tocado
    @objc func operationTap(sender: UIButton) {
        if resultLabel.text != "+" && resultLabel.text != "-" && resultLabel.text != "*" && resultLabel.text != "/" {
            firstValue = Int(resultLabel.text!)!
        }
            
        switch sender {
            case sumOpButton:
                resultLabel.text = "+"
                operation = Calculator.Operation.sum
            case subtractOpButton:
                resultLabel.text = "-"
                operation = Calculator.Operation.subtract
            case timesOpButton:
                resultLabel.text = "*"
                operation = Calculator.Operation.times
            case divideOpButton:
                resultLabel.text = "/"
                operation = Calculator.Operation.divide
            default:
                return
            }
        
        calculating = true
    }

    /// Método acionado quando o botão = é tocado.
    @objc func makeOperation() {
        resultLabel.text  = String(calculator.perform(operation: operation, firstValue: firstValue, secondValue: secondValue))
        firstValue = 0
        secondValue = 0
        calculating = false
    }
}
