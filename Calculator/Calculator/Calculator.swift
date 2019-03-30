import Foundation

struct Calculator {
    enum Operation {
        case sum
        case times
        case divide
        case subtract
    }

    /// Realiza uma operação matemática.
    /// - Parameter operation: Enum com a operação a ser realizada.
    /// - Parameter firstValue: Primeiro valor.
    /// - Parameter secondValue: Segundo valor.
    /// - Returns: Resultado do calculo.
    func perform(operation: Calculator.Operation,
                 firstValue: Int,
                 secondValue: Int) -> Int {
        
        switch operation {
            case Calculator.Operation.sum:
                 return firstValue + secondValue
            case Calculator.Operation.subtract:
                return firstValue - secondValue
            case Calculator.Operation.times:
                return firstValue * secondValue
            case Calculator.Operation.divide:
                return firstValue / secondValue
        }
    }
}
