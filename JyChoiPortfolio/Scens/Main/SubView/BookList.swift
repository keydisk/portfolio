//
//  BookList.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI
import Combine
import Kingfisher

/// 지점 정보 셀
struct BookInfoCell: View {
    
    @Binding var model: BookModel
    
    /// 화면에 출력하는 텍스트
    private func printText(text: String, align: Alignment, font: Font, textColor: Color) -> some View {
        
        HStack(spacing: 0) {
            
            if align == .trailing || align == .center {
                Spacer()
            }
            
            Text(text).font(font).foregroundColor(textColor)
            
            if align == .leading || align == .center {
                Spacer()
            }
        }.padding(.horizontal, 10)
    }
    
    @State var imgSize: CGSize = .zero
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            KFImage(URL(string: model.thumbnail)).applyDefaultBookImg("emptyImg").frame(width: 100).aspectRatio(contentMode: .fit).cornerRadius(10).clipped()
            
            VStack(spacing: 0) {
                
                self.printText(text: model.title, align: .leading, font: .defaultFont, textColor: .black)
                self.printText(text: model.printAuthor, align: .leading, font: .defaultFont, textColor: .black)
                self.printText(text: model.status, align: .leading, font: .defaultFont, textColor: .black)
                Spacer()
                self.printText(text: model.printPrice, align: .trailing, font: .defaultFont, textColor: .black)
                self.printText(text: model.printDate, align: .trailing, font: .defaultFont, textColor: .orange)
            }.padding(.leading, 10)
            Spacer()
            
        }.padding(10).id("id\(model.index)")
    }
}

/// 지점 리스트
struct BookList: View {
    
    /// 리스트 모델이 변경되면 반영해주기 위해서 사용
    @Binding var listModels: [BookModel]
    let viewModel: MainViewModel
    private var offsetY: CGFloat = 0
    
    init(listModels: Binding<[BookModel]>, viewModel: MainViewModel) {
        
        self.viewModel   = viewModel
        self._listModels  = listModels
    }
    
    var index: Int = 0
    var body: some View {
        
        ScrollViewReader { proxy in
        
            List(self.$listModels) { model in
                BookInfoCell(model: model).onAppear(perform: {
                    
                    self.viewModel.nextPage(model.wrappedValue)
                }).onTapGesture {
                    
                    self.viewModel.selectBookModel.send(model.wrappedValue)
                }.listRowInsets(EdgeInsets() )
            }.onReceive(self.viewModel.pageTop, perform: {move in
                
                guard move else {
                    return
                }
                
                withAnimation(.default, {
                    proxy.scrollTo("id1", anchor: .top)
                })
                
            }).listStyle(.plain)
                .gesture(
                DragGesture().onChanged({gesture in
                    
                    guard self.viewModel.showKeyboard else {
                        return
                    }
                    
                    UIApplication.shared.endEditing()
                })
            )
        }
        
    }
}

