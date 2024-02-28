import SwiftUI

// Cards to display thumbnail image and name of dessert on main page

struct CardView: View {
    
    // passed in
    var dessertName: String
    var dessertThumbnail: String
    var dessertID: String

    var body: some View {
        // links to DetailView
        NavigationLink(destination: DetailView(dessertName: dessertName, dessertThumbnail: dessertThumbnail, dessertID: dessertID)) {
            VStack(alignment: .center) {
                Text(dessertName)
                    .font(.headline)
                    .padding(.bottom, 5)
                AsyncImage(url: URL(string: dessertThumbnail)) { image in image.resizable() } placeholder: { Color.gray } .frame(width: 128, height: 128) .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
/*
#Preview {
    CardView()
}
*/
