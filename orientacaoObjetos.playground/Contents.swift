import UIKit

class Animal {
    var name: String
    var age: Int
    var weight: Double
    var carnivore: Bool?
    
    init(name: String, age: Int, weight: Double) {
        self.name = name
        self.age = age
        self.weight = weight
    }
}

extension Animal {
    func animalIsCarnivore(carnivore: Bool) {
        self.carnivore = carnivore
    }
}

enum ZooFood: String {
    case beef
    case chicken
    case fruits
    case vegetables
}

class StockZooFood {
    var stockZooFood: [ZooFood: Int] = [:]
    
    func addFoodToStock(typeFood: ZooFood, quantity: Int) async -> Int {
        stockZooFood.updateValue(quantity, forKey: typeFood)
        guard let newQuantity = stockZooFood[typeFood]?.hashValue else {
            return 0
        }
        return newQuantity
    }
    
    func getFoodFromStock(typeFood: ZooFood) async -> Int {
        guard let quantityInStock = stockZooFood.first(where: { $0.key == typeFood }) else {
            return 0
        }
        return quantityInStock.value
    }
}

class AnimalZoo: Animal {
    var wasFed: Bool? = false
    
    func hasAlreadyBeenFed() -> Bool {
        wasFed ?? false
    }
}

class Zoo {
    let animal: [AnimalZoo]
    var stockFood: StockZooFood
    
    init(animal: [AnimalZoo], stockFood: StockZooFood = StockZooFood()) {
        self.animal = animal
        self.stockFood = stockFood
    }
}

let lion: AnimalZoo = .init(name: "Lion", age: 3, weight: 50.2)
let crocodile: AnimalZoo = .init(name: "Crocodile", age: 10, weight: 150.9)
let zebra: AnimalZoo = .init(name: "Zebra", age: 7, weight: 97.6)
let ape: AnimalZoo = .init(name: "Ape", age: 19, weight: 39.7)

lion.animalIsCarnivore(carnivore: true)
crocodile.animalIsCarnivore(carnivore: true)

let zoo = Zoo(animal: [lion, crocodile, zebra, ape])

await zoo.stockFood.addFoodToStock(typeFood: .beef, quantity: 10)
await zoo.stockFood.addFoodToStock(typeFood: .fruits, quantity: 50)
await zoo.stockFood.addFoodToStock(typeFood: .chicken, quantity: 20)
await zoo.stockFood.addFoodToStock(typeFood: .vegetables, quantity: 30)

var beef = await zoo.stockFood.getFoodFromStock(typeFood: .beef)
var fruits = await zoo.stockFood.getFoodFromStock(typeFood: .fruits)
var chicken = await zoo.stockFood.getFoodFromStock(typeFood: .chicken)
var vegetables = await zoo.stockFood.getFoodFromStock(typeFood: .vegetables)

zoo.animal.forEach { print($0.wasFed) }

zoo.animal.forEach { animal in
    if !animal.hasAlreadyBeenFed() {
        if animal.carnivore ?? false {
            switch animal.name {
                case "Lion":
                    beef - 10
                case "Crocodile":
                    chicken - 10
                default:
                    break
            }
        } else {
            switch animal.name {
                case "Zebra":
                    vegetables - 10
                case "Ape":
                    fruits - 10
                default:
                    break
            }
        }
        animal.wasFed = true
    }
}

zoo.animal.forEach { print($0.wasFed) }
