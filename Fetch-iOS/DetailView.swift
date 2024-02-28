import SwiftUI

// struct to store needed data for display
// not the most elegant solution I would imagine, but data from API always
// has 20 slots for ingredients and measures so it works for all
struct DessertInfo: Decodable {
    // instructions
    var strInstructions: String
    // ingredients
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    // measures
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
}

// for unwrapping the API data
struct mealInfo: Decodable {
    var meals: [DessertInfo]
}

struct DetailView: View {
    
    // initialize storage for dessert clicked on
    // d(essert)Information
    @State private var dInformation: DessertInfo?
    
    // vars passed in from transition
    var dessertName: String
    var dessertThumbnail: String
    var dessertID: String
    
    // API CALL
    func detailsAPIcall() async throws -> DessertInfo {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(dessertID)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // decode API data into dessertInfo struct above
            let mealInfo = try JSONDecoder().decode(mealInfo.self, from: data)
            
            //print(mealInfo.meals[0])
            return mealInfo.meals[0]
        } catch {
            print("Error:", error)
            throw error
        }
    }
    // END API CALL
    
    // Call API and store
    func fetchInfo() {
        Task {
            do {
                dInformation = try await detailsAPIcall()
            } catch {
                print("Error fetching details:", error)
            }
        }
    }

    var body: some View {
        
        NavigationView {
            // if dInformation has been initialized
            if let dInformation = dInformation {
                VStack {

                    List {
                            
                        AsyncImage(url: URL(string: dessertThumbnail)) { image in image.resizable() } placeholder: { Color.gray } .frame(width: 128, height: 128) .clipShape(RoundedRectangle(cornerRadius: 10)) .background(Color.white) .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                        Section(header: Text("Ingredients")) {
                            ForEach(1...20, id: \.self) { i in
                                ydcPrevention(dessertInfo: dInformation, ingIndex: i, meaIndex: i)
                            }
                        }
                        Section(header: Text("Instructions")) {
                            Text(dInformation.strInstructions)
                        }
                        
                    }
                    
                }
                
            } else {
                ProgressView()
                // call to fetch info
                .onAppear {
                    fetchInfo()
                }
            }
        }
        .navigationTitle(dessertName)
        
    }
    
    // function to create all the ingredient/mesurement pairs
    // previously, was 20 hardcoded if statements.  this is much better.
    @ViewBuilder
    func ydcPrevention(dessertInfo: DessertInfo, ingIndex: Int, meaIndex: Int) -> some View {
        let ingredientKey = "strIngredient\(ingIndex)"
        let measureKey = "strMeasure\(meaIndex)"
        
        let mirror = Mirror(reflecting: dessertInfo)
        
        if let ingredient = mirror.children.first(where: { $0.label == ingredientKey })?.value as? String,
            !ingredient.isEmpty,
            let measure = mirror.children.first(where: { $0.label == measureKey })?.value as? String {
            
                Text("\(ingredient): \(measure)")
            
        } else {
            // data is null or empty (" ")
            EmptyView()
        }
    }
    
}
