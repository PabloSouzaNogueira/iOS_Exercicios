enum BankOperation{
    case withdrawl(value: Double)
    case deposit(from: String, value: Double)
}

enum BankAccountError: Error{
    case insuficientFunds(currentBalance: Double)
}

protocol BankAccountProtocol{
    init(number: String, holder:String)
    
    var balance: Double{ get }
    var statement: [BankOperation] {get}
    
    func withdrawl(value: Double) throws
    func deposit(value: Double, from account: String)
    func formattedStatement() -> String
}



class MyBank: BankAccountProtocol {
    private let number: String
    private let holder: String
    private(set) var balance: Double
    private(set) var statement: [BankOperation]
    
    required init(number: String, holder:String){
        self.number = number
        self.holder = holder
        self.balance = 0.0
        self.statement = []
    }
    
    func withdrawl(value: Double) throws{
        guard balance >= value else { throw BankAccountError.insuficientFunds(currentBalance: self.balance)}
        
        balance = balance - value;
        statement.append(.withdrawl(value: value))
    }
    func deposit(value: Double, from account: String){
        balance = balance + value;
        statement.append(.deposit(from: account, value: value))
    }
    func formattedStatement() -> String{
        var result = "Extrato da conta \(number) - titular \(holder):\n\n"
        for register in statement{
            switch register {
            case .deposit(let from, let value):
                result += ("DEP  \(value)    \(from)\n")
            case .withdrawl(let value):
                result += ("WTD  \(value)\n")
            }
        }
        return result;
    }
}

//Operações para testar o deposito, saque e extrato da conta.
let count = MyBank(number: "1123", holder: "Pablo")

count.deposit(value: 10, from: "123")

do {
try count.withdrawl(value: 11)
}catch BankAccountError.insuficientFunds {
    print ("Não existe saldo suficiente na conta para realizar a operação de saque.")
}

do {
    try count.withdrawl(value: 7)
}catch BankAccountError.insuficientFunds {
    print ("Não existe saldo suficiente na conta para realizar a operação de saque.")
}

count.deposit(value: 5, from: "123")

print(count.formattedStatement())
