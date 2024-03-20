//
//  StoreDetailView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI
import Kingfisher

/// 책 상세
struct BookInfoDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var moveBuyWebView = false
    
    var prtinModel: BookModel {
        
        self.model ?? BookModel(authors: [], contents: "-", datetime: Date().toString(format: "yyyy-MM-dd"), isbn: "-", price: 0, publisher: "", salePrice: 0, status: "", thumbnail: "", title: "-", translators: [], url: "")
    }
    
    var model: BookModel?
    @ObservedObject var viewModel = DetailViewModel()
    
    var body: some View {
        
        GeometryReader {geo in
            
            VStack(spacing: 0) {
                
                ScrollView(.vertical) {
                    
                    Text("제목 : " + self.prtinModel.title).modifier(HorizontalTextModifier(isTitle: true, align: .leading, edges: (.horizontal, 10)))
                    
                    HStack {
                        Spacer()
                        KFImage(URL(string: self.prtinModel.thumbnail )).cornerRadius(10)
                        Spacer()
                    }.padding(.horizontal, 10)
                    
                    Text(self.prtinModel.author).modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.horizontal, 10)))
                    if self.prtinModel.printTranslators.count > 0 {
                        Text("역자 : " + self.prtinModel.printTranslators).modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.horizontal, 10)))
                    }
                    
                    Text("출판사 : " + self.prtinModel.publisher).modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.horizontal, 10)))
                    Text(self.prtinModel.printDate).modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.horizontal, 10)))
                    
                    Text("요약").modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.top, 10))).padding(.horizontal, 10)
                    Text(self.prtinModel.contents).modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.horizontal, 10)) )
                    
                    Spacer()
                }
                
                Text(self.prtinModel.printPrice)
                Text("구입").modifier(HorizontalTextModifier(isTitle: false, align: .center, textColor: .white, edges: (.horizontal, 10)) ).onTapGesture {
                    
                    self.moveBuyWebView = true
                }.frame(height: 50).background(Color.blue)
                
                NavigationLink(destination: CommonWebView(url: self.prtinModel.url), isActive: self.$moveBuyWebView, label: {}).hidden()
                
            }
        }.navigationBarBackButtonHidden(true)
            .navigationTitle(self.prtinModel.title)
            .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label:  {
                    Image(systemName: "arrowshape.backward")
                    Text("뒤로가기").foregroundColor(.black)
                }
                
            })
        })
    }
}

#Preview {
    
    BookInfoDetailView(model: BookModel(authors: [], contents: "-", datetime: Date().toString(format: "yyyy-MM-dd"), isbn: "-", price: 0, publisher: "", salePrice: 0, status: "", thumbnail: "", title: "-", translators: [], url: ""))
}
