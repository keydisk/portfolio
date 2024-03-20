//
//  BookMetaInfoView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/20/24.
//

import SwiftUI
import Kingfisher

///
struct BookMetaInfoView: View {
    
    let model: BookModel!
    @State var width: CGFloat = 100
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            KFImage(URL(string: self.model.thumbnail)).onSuccess({result in
                
                self.width = result.image.size.width
            }).resizable().padding(1)
            
            Text(self.model.title).font(.defaultFont).foregroundColor(.gray).padding(.top, 6).lineLimit(1)
            Text(self.model.printDateWithoutTitle).font(.defaultFont).foregroundColor(.gray).padding(.top, 5).lineLimit(1)
        }.frame(width: self.width).background(
            
            RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1)
        ).cornerRadius(5).padding(2)
    }
}

#Preview {
    BookMetaInfoView(model: BookModel(authors: [], contents: "-", datetime: Date().toString(format: "yyyy-MM-dd"), isbn: "-", price: 0, publisher: "", salePrice: 0, status: "", thumbnail: "", title: "-", translators: [], url: ""))
}
