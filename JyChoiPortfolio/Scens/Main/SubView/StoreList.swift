//
//  StoreList.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI
import Combine

/// 지점 정보 셀
struct StoreCell: View {
    
    /// 테그 정보
    struct TagView<T>: View {
        
        var model: TagModel<T>
        
        var body: some View {
            HStack {
                Text(self.model.title).font(.spoqaMedium(fontSize: 13)).foregroundColor(.gray)
                if let index = self.model.metaData as? Int, index < 2 {
                    Rectangle().fill(Color.gray).frame(width: 1, alignment: .center).padding(.leading, 1).frame(height: 8)
                }
            }
        }
    }
    
    var model: StoreModel
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                Text(model.metaData.title).font(.spoqaMedium(fontSize: 15))
                Spacer()
            }.padding(.horizontal, 10)
            
            HStack(spacing: 0) {
                Text(model.address).font(.spoqaBold(fontSize: 12)).foregroundColor(.black)
                Spacer()
                Text(model.printDistance).font(.spoqaMedium(fontSize: 13)).foregroundColor(.blue)
            }.padding(.top, 5).padding(.horizontal, 10)
            
            HStack(spacing: 0) {
                ForEach(self.model.tagList, id: \.self, content: {tag in
                    
                    TagView<Bool>(model: tag).padding(.leading, (tag.metaData ? 3 : 0) )
                })
                Spacer()
            }.padding(.top, 5).padding(.horizontal, 10)
            
            HStack(spacing: 0) {
                Spacer()
                Text("최저 ").font(.spoqaMedium(fontSize: 13)).foregroundColor(.black)
                Text(self.model.printMinimumPrice).font(.spoqaMedium(fontSize: 13)).foregroundColor(.orange)
            }.padding(.top, 10).padding(.bottom, 10).padding(.horizontal, 10)
            
            Rectangle().fill(Color.lightGray).frame(height: 1)
        }.padding(.top, 10).background(Color.white)
    }
}

/// 지점 리스트
struct StoreList: View {
    
    let selectModel: PassthroughSubject<StoreModel, Never>
    
    @Binding var listModels: [StoreModel]
    @Binding var refreshList: Bool
    
    init(listModels: Binding<[StoreModel]>, refreshList: Binding<Bool>, selectModel: PassthroughSubject<StoreModel, Never>) {
        
        self.selectModel = selectModel
        
        self._listModels  = listModels
        self._refreshList = refreshList
    }
    
    var body: some View {
        
        List(self.listModels) { model in
            
            StoreCell(model: model).onTapGesture {
                
                self.selectModel.send(model)
            }.listRowInsets(EdgeInsets() ).listRowSeparator(.hidden)
        }.listStyle(.plain).refreshable {
            
            self.refreshList = true
        }
    }
}

