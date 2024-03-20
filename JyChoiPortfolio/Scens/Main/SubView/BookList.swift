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
            
            KFImage(URL(string: model.thumbnail)).placeholder({
                Image(systemName: "books.vertical.fill")
            }).frame(width: 100).aspectRatio(contentMode: .fit).cornerRadius(10).clipped()
            
            VStack(spacing: 0) {
                
                self.printText(text: model.title, align: .leading, font: .spoqaMedium(fontSize: 18), textColor: .black)
                self.printText(text: model.author, align: .leading, font: .spoqaMedium(fontSize: 15), textColor: .black)
                self.printText(text: model.status, align: .leading, font: .spoqaMedium(fontSize: 15), textColor: .black)
                Spacer()
                self.printText(text: model.printPrice, align: .trailing, font: .spoqaMedium(fontSize: 15), textColor: .black)
                self.printText(text: model.printDate, align: .trailing, font: .spoqaMedium(fontSize: 15), textColor: .orange)
            }.padding(.leading, 10)
            Spacer()
            
        }.padding(10).id("id\(model.index)")
    }
}

/// 지점 리스트
struct BookList: View {
    
    /// 리스트 모델이 변경되면 반영해주기 위해서 사용
    @Binding var listModels: [BookModel]
    ///
    @Binding var refreshList: Bool
    let viewModel: MainViewModel
    private var offsetY: CGFloat = 0
    
    init(listModels: Binding<[BookModel]>, refreshList: Binding<Bool>, viewModel: MainViewModel) {
        
        self.viewModel   = viewModel
        self._listModels  = listModels
        self._refreshList = refreshList
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
                
                print("pageTop")
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
// iOS 15이상만 지원
//                .refreshable {
//                    self.refre
//                }
        }
        
    }
}

