import Foundation

struct Point{
    let x: Double
    let y: Double
    
    // método calculo de distancia entre dois pontos
    func distance(from point: Point) -> Double{        
        let pointX = pow(point.x - self.x, 2)
        let pointY = pow(point.y - self.y, 2)
        
        return sqrt(Double(pointX + pointY)).roundTo(places: 2)
    }
}

struct Triangle{
    //(vertex1, vertex2, vertex3) stored properties
    let vertex1: Point
    let vertex2: Point
    let vertex3: Point
    
    // kind -> Enumerador (equilateral, isocelesm scalene)
    enum Kind{
        case equilateral
        case isosceles
        case scalene
    }
    
    var kind: Kind{
        //calcula distancia entre AB AC BC
        let AB = abs(vertex1.distance(from: vertex2))
        let AC = abs(vertex1.distance(from: vertex3))
        let BC = abs(vertex2.distance(from: vertex3))
        
        //compara o tamanhos dos lados e retorna o tipo
        if(AB == AC && AB == BC){
            return .equilateral
        }
        if(AB != AC && AB != BC && AC != BC){
            return .scalene
        }
        return .isosceles
    }
}

extension Double{
    func roundTo(places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//A(2,7), B(2,3), C(5,3)
//A(2,3), B(2,1), C(4,1)
//A(5,7), B(10,9), C (5.768, 12.33)
let result1 = Triangle(vertex1:Point(x:2,y:7),vertex2:Point(x:2,y:3),vertex3:Point(x:5,y:3)).kind
let result2 = Triangle(vertex1:Point(x:2,y:3),vertex2:Point(x:2,y:1),vertex3:Point(x:4,y:1)).kind
let result3 = Triangle(vertex1:Point(x:5,y:7),vertex2:Point(x:10,y:9),vertex3:Point(x:5.768,y:12.33)).kind

print("Resultado do 1º triangulo: \(result1)")
print("Resultado do 2º triangulo: \(result2)")
print("Resultado do 3º triangulo: \(result3)")

