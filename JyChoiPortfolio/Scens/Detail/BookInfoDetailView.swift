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
    
    enum SelectMetaInfo {
        
        case introduce
        case author
        case publisher
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var moveBuyWebView = false
    
    /// 메뉴 선택
    @State var selectMenu: SelectMetaInfo = .introduce
    
    /// 책 상세로 이동
    @State var moveBookDetail = false
    @State var selectBook: BookModel?
    
    var printModel: BookModel {
        
        self.model ?? BookModel(authors: [], contents: "-", datetime: Date().toString(format: "yyyy-MM-dd"), isbn: "-", price: 0, publisher: "", salePrice: 0, status: "", thumbnail: "", title: "-", translators: [], url: "")
    }
    
    var model: BookModel?
    
    @StateObject var viewModel = DetailViewModel()
    
    /// 책 상세로 이동
    private func selectBookModel(_ model: BookModel) {
        
        self.moveBookDetail.toggle()
        self.selectBook = model
    }
    
    var introduceView: some View {
        
        VStack {
            
            HStack {
                Text("저자").font(.spoqaMedium(fontSize: 14)).foregroundColor(.gray)
                Text(self.printModel.printAuthor).font(.spoqaMedium(fontSize: 14)).foregroundColor(.blue)
                
                if self.printModel.printTranslators.count > 0 {
                    
                    Rectangle().frame(width: 1, height: 8).foregroundColor(.gray).padding(.horizontal, 8)
                    
                    Text("역자").font(.spoqaMedium(fontSize: 14)).foregroundColor(.gray)
                    Text(self.printModel.printTranslators).font(.spoqaMedium(fontSize: 14)).foregroundColor(.blue)
                }
                
                Spacer()
            }
            
            HStack {
                Text("출판").font(.spoqaMedium(fontSize: 14)).foregroundColor(.gray)
                Text(self.printModel.publisher).font(.spoqaMedium(fontSize: 14)).foregroundColor(.blue)
                
                Rectangle().frame(width: 1, height: 8).foregroundColor(.gray).padding(.horizontal, 8)
                
                Text(self.printModel.printDate).font(.spoqaMedium(fontSize: 14)).foregroundColor(.black)
                
                Spacer()
            }
            
        }.opacity(self.selectMenu == .introduce ? 1.0 : 0.0)
    }
    
    var authorView: some View {
        
        VStack {
            HStack {
                Text(self.printModel.printAuthors).font(.spoqaMedium(fontSize: 14)).foregroundColor(.black)
                Spacer()
            }
        }.opacity(self.selectMenu == .author ? 1.0 : 0.0)
    }
    
    var pulisherView: some View {
        
        VStack {
            HStack {
                Text("출판").font(.spoqaMedium(fontSize: 14)).foregroundColor(.gray)
                Text(self.printModel.publisher).font(.spoqaMedium(fontSize: 14)).foregroundColor(.blue)
                Spacer()
            }
        }.opacity(self.selectMenu == .publisher  ? 1.0 : 0.0)
    }
    
    private func selectMetaInfo(_ type: SelectMetaInfo) {
        
        withAnimation {
            self.selectMenu = type
        }
    }
    
    private var seperatorLine: some View {
        Rectangle().fill(Color.gray).frame(height: 1).opacity(0.5)
    }
    
    var body: some View {
        
        GeometryReader {geo in
            
            VStack(spacing: 0) {
                
                ScrollView(.vertical) {
                    
                    HStack {
                        VStack {
                            Text(self.printModel.title).modifier(HorizontalTextModifier(isTitle: true, align: .leading, edges: (.horizontal, 10))).onTapGesture {
                                
                                self.viewModel.setClipboard(self.printModel.title)
                            }
                            Text(self.printModel.printAuthor).modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.horizontal, 10)))
                        }
                        Spacer()
                        KFImage(URL(string: self.printModel.thumbnail )).applyDefaultBookImg("emptyImg").cornerRadius(10)
                    }.padding(.horizontal, 10)
                    
                    self.seperatorLine
                    
                    HStack {
                        Spacer()
                        Text("소개").foregroundColor(self.selectMenu == .introduce ? Color.black : Color.gray).font(.spoqaRegular(fontSize: 20)).onTapGesture {
                            self.selectMetaInfo(.introduce)
                        }
                        Spacer()
                        Text("저자").foregroundColor(self.selectMenu == .author ? Color.black : Color.gray).font(.spoqaRegular(fontSize: 20)).onTapGesture {
                            self.selectMetaInfo(.author)
                        }
                        Spacer()
                        Text("출판사명").foregroundColor(self.selectMenu == .publisher ? Color.black : Color.gray).font(.spoqaRegular(fontSize: 20)).onTapGesture {
                            self.selectMetaInfo(.publisher)
                        }
                        Spacer()
                    }.frame(height: 40)
                    
                    self.seperatorLine
                    
                    ZStack {
                        self.introduceView
                        self.authorView
                        self.pulisherView
                    }.padding(.horizontal, 10)
                    
                    self.seperatorLine
                    
                    Text("요약").modifier(HorizontalTextModifier(isTitle: true, align: .leading, edges: (.top, 10))).padding(.horizontal, 10)
                    Text(self.printModel.printContents).modifier(HorizontalTextModifier(isTitle: false, align: .leading, edges: (.horizontal, 10)) )
                    
                    Spacer()
                    
                    if self.viewModel.sameAuthList.count > 0 {
                        
                        self.seperatorLine
                        Text("작가 다른책").modifier(HorizontalTextModifier(isTitle: true, align: .leading, edges: (.top, 10))).padding(.horizontal, 10)
                        
                        ScrollView(.horizontal, content: {
                            
                            HStack {
                                ForEach(self.viewModel.sameAuthList, content: { model in
                                    
                                    BookMetaInfoView(model: model).onTapGesture {
                                        
                                        self.selectBookModel(model)
                                    }
                                })
                            }
                            
                        })
                    }
                    
                    if self.viewModel.samePulisherList.count > 0 {
                        
                        self.seperatorLine
                        Text("출판사 다른책").modifier(HorizontalTextModifier(isTitle: true, align: .leading, edges: (.top, 10))).padding(.horizontal, 10)
                        
                        ScrollView(.horizontal, content: {
                            
                            HStack {
                                ForEach(self.viewModel.samePulisherList, content: { model in
                                    
                                    BookMetaInfoView(model: model).onTapGesture {
                                        
                                        self.selectBookModel(model)
                                    }
                                })
                            }
                            
                        })
                    }
                }
                
                self.seperatorLine
                Text(self.printModel.printPrice)
                Text("구입").modifier(HorizontalTextModifier(isTitle: false, align: .center, textColor: .white, edges: (.horizontal, 10)) ).frame(height: 50).background(Color.blue).onTapGesture {
                    
                    self.moveBuyWebView = true
                }
                
                NavigationLink(destination: WebView(url: self.printModel.url), isActive: self.$moveBuyWebView, label: {}).hidden()
                
                NavigationLink(destination: BookInfoDetailView(model: selectBook), isActive: $moveBookDetail, label: {}).hidden()
                
            }
        }.onAppear(perform: {
            
            self.viewModel.model = self.model
            self.viewModel.requestData()
            
        }).navigationBarBackButtonHidden(true)
            .navigationTitle(self.printModel.title)
            .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label:  {
                    Image(systemName: "arrowshape.backward")
                }.accentColor(.gray)
                
            })
        })
    }
}
