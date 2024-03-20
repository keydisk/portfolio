//
//  ContentView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import SwiftUI
import MapKit
import Combine

public struct ContentViewConstValue {
    
    static let scrollLabel = "ContentViewScrollLabel"
    static let topScrollPosition = "topScrollPosition"
}


struct EmptyView: View {
    
    var body: some View {
        
        VStack(content: {
            Spacer()
            HStack {
                Spacer()
                Text("검색된 리스트가 없습니다.")
                Spacer()
            }
            Spacer()
        })
    }
}

struct RoundedBackground: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        RoundedRectangle(cornerRadius: cornerRadius).path(in: rect)
    }
}

struct SelectSearchType: View {
    
    let viewModel: MainViewModel
    @Binding var selectType: SearchTarget
    
    /// 아이콘
    func getIconFromSearchType(_ type: SearchTarget) -> Image {
        
        switch type {
        case .isbn:
            return Image(systemName: "barcode.viewfinder")
        case .title:
            return Image(systemName: "textformat.subscript")
        case .publisher:
            return Image(systemName: "printer")
        case .person:
            return Image(systemName: "person.bubble")
        }
    }
    
    var body: some View {
        HStack {
            
            ForEach(SearchTarget.searchList, content: {model in
                
                ZStack {
                    VStack {
                        self.getIconFromSearchType(model.metaData)
                        Text("\(model.metaData.printText)").foregroundColor(.gray).font(.spoqaMedium(fontSize: 13))
                    }
                    .onTapGesture {
                        // 선택된 아이콘 처리
                        self.viewModel.setSelectTarget(model.metaData)
                    }
                    
                    RoundedBackground(cornerRadius: 10)
                        .stroke(model.metaData == selectType ? Color.black : Color.clear, lineWidth: 1)
                        .scaledToFit().padding(10)
                }
            })
            
            Spacer()
        }//.frame(maxWidth: .infinity, alignment: .leading)//.frame(height: 40)
    }
}

/// 메인 뷰
struct ContentView: View {
    
    @StateObject var viewModel = MainViewModel()
    @State private var isFocus: Bool = false
    @State private var showAppleLogin: Bool = false
    
    var listHeight: CGFloat = 0
    var cancelList = Set<AnyCancellable>()
    var cancel: AnyCancellable?
    @State var showSearchType = false
    
    private func drawSortingOption(_ option: SortingType) -> some View {
        
        var title = ""
        
        if option == .accuracy {
            title = "정확도순"
        } else {
            title = "최신순"
        }
        
        return Text(title).onTapGesture {
            
            self.viewModel.selectSorting(option)
        }.foregroundColor(self.setSortingTextColor(self.viewModel.sortingOption == option))
    }
    
    var body: some View {
//        GeometryReader {geo in
//            
//        }
        
        ZStack {
            VStack(spacing: 0) {
                
                Text("검색 타겟").modifier(HorizontalTextModifier(isTitle: true, align: .leading, edges: (.horizontal, 10) ))
                SelectSearchType(viewModel: self.viewModel, selectType: self.$viewModel.target)
                
                HStack(spacing: 0) {
                    
                    RoundTextField(round: 10, text: self.$viewModel.searchText, keyboardFocus: $isFocus, placeHolder: "insert text", edge: EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5)).frame(height: 40)
                }.padding(.horizontal, 10)
                
                HStack(spacing: 0) {
                    Text("\(self.viewModel.pageModel.totalCnt)").foregroundColor(.blue)
                    Text("개의 검색 결과").font(.spoqaRegular(fontSize: 15))
                    Spacer()
                    self.drawSortingOption(.accuracy)
                    self.drawSortingOption(.latest).padding(.leading, 10)
                }.padding(10)
                
                VStack(spacing: 0) {
                    
                    if self.viewModel.list.count == 0 {
                        
                        EmptyView()
                    } else {
                        BookList(listModels: self.$viewModel.list, refreshList: self.$viewModel.refreshList, viewModel: self.viewModel).padding(.top, 10.0)
                    }
                }.accessibilityLabel(ContentViewConstValue.scrollLabel)
                
                NavigationLink(destination: BookInfoDetailView(model: self.viewModel.selectBookModel.value), isActive: self.$viewModel.moveDetailView, label: {}).hidden()
                
                Spacer()
            }
//                .sheet(isPresented: $showSearchType, content: {
//
//                    SelectSearchType(viewModel: self.viewModel)
//                })
            .sheet(isPresented: $showAppleLogin, content: {
                
                LoginView()
            })
        }
    }
    
    /// 검색 옵션 선택
    private func selectSorting(_ type: SortingType) {
        
        self.viewModel.sortingOption = type
    }
    
    private func setSortingTextColor(_ selected: Bool) -> Color {
        
        selected ? .black : .gray
    }
}

#Preview {
    ContentView()
}
