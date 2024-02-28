import SwiftUI

// dessert struct
struct Dessert: Identifiable, Decodable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
    
    var id: String { idMeal }
}

// for unwrapping the API data
// API data gets returned in meals[data] fashion,
// this removes that top layer and makes the rest accessible
struct DessertList: Decodable {
    var meals: [Dessert]
}

// API CALL
func dessertAPICall() async throws -> [Dessert] {
    let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let dessertList = try JSONDecoder().decode(DessertList.self, from: data)
        
        return dessertList.meals
        
    } catch {
        print("Error:", error)
        throw error
    }
}
// END API CALL


struct ContentView: View {
    
    // initialize array of desserts
    @State private var desserts: [Dessert] = []
    
    var body: some View {
        NavigationView{
            List {
                ForEach(desserts) { dessert in
                    CardView(dessertName: dessert.strMeal, dessertThumbnail: dessert.strMealThumb, dessertID: dessert.idMeal)
                }
            }
            .onAppear {
                // call to fetch
                fetchDesserts()
            }
            .navigationTitle("Desserts")
        }
    }
    
    // function to call api call and populate Dessert array
    func fetchDesserts() {
        Task {
            do {
                desserts = try await dessertAPICall()
                //print(desserts)
            } catch {
                print("Error fetching desserts:", error)
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
