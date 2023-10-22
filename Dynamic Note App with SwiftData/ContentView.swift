//
//  ContentView.swift
//  Dynamic Note App with SwiftData
//
//  Created by Berkay Yaşar on 21.10.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var items: [NoteData]
    
    @State private var taskText = ""
    @State private var editorText = ""
    @State private var colors: [String] = ["red", "yellow", "green", "blue", "purple", "orange", "brown"]
    @State private var selectedColor: String = "red"
    @State private var show = false
    @Namespace private var namespace
    @State private var offset = CGSize.zero
    @State private var originalOffset = CGSize.zero
    @State private var showtheview = false
    @State private var scale: CGFloat = 1.0
    
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("Notes").font(.title).bold()
                List{
                    ForEach(items) { item in
                        HStack{
                            Circle().frame(width: 20, height: 20).foregroundStyle(getColorFromString(colorName: item.color)!)
                            VStack(alignment: .leading) {
                                Text(item.title).bold()
                                Text(item.body).opacity(0.5)
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        for index in indexSet{
                            deleteItem(item: items[index])
                        }
                    })
                }.background(Color.white)
            }
            
            if !show {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .matchedGeometryEffect(id: "add", in: namespace)
                        .frame(width: 80, height: 80)
                    Image(systemName: "plus")
                        .offset(x: -25, y: -25)
                        .matchedGeometryEffect(id: "add", in: namespace)
                        .foregroundStyle(.white).font(.title)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
                .onTapGesture {
                    withAnimation(.spring(dampingFraction: 0.7)){
                        show.toggle()
                    }
                    withAnimation(.easeIn(duration: 0.1).delay(0.3)) {
                        showtheview = true
                    }
                    taskText = ""
                    editorText = ""
                    selectedColor = "red"
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .matchedGeometryEffect(id: "add", in: namespace)
                        .frame(width: 300, height: 250)
                        .foregroundStyle(Color.black)
                    
                    if showtheview {
                        VStack {
                            HStack {
                                TextField("Task Title", text: $taskText)
                                    .padding(.leading, 5)
                                    .frame(width: 150, height: 40)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                Spacer()
                                Button(action: {
                                    showtheview = false
                                    withAnimation(.spring(dampingFraction: 0.7)){
                                        show.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "xmark").foregroundStyle(.black)
                                        .frame(width: 40, height: 40)
                                        .background(.white, in: Circle())
                                })
                            }
                            
                            TextEditor(text: $editorText)
                                .frame(width: 270, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            HStack {
                                ForEach(colors, id: \.self) { color in
                                    Circle().frame(width: 30, height: 30)
                                        .foregroundStyle(getColorFromString(colorName: color)!).opacity(0.8)
                                        .overlay {
                                            if color == selectedColor  {
                                                Circle().stroke(lineWidth: 2).foregroundStyle(.white)
                                            }
                                        }
                                        .onTapGesture {
                                            selectedColor = color
                                        }
                                }
                            }
                            Button {
                                showtheview = false
                                addItem(title: taskText, body: editorText, color: selectedColor)
                                taskText = ""
                                editorText = ""
                                selectedColor = "red"
                                withAnimation(.spring(dampingFraction: 0.7)){
                                    show.toggle()
                                }
                            } label: {
                                Text("Save")
                                    .font(.title3)
                                    .foregroundStyle(.black)
                                    .frame(width: 200, height: 40)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                            
                        }
                        .padding()
                        .frame(width: 300, height: 250)
                    }
                }
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = CGSize(width: originalOffset.width + gesture.translation.width, height: originalOffset.height + gesture.translation.height)
                            let distance = sqrt(pow(gesture.translation.width , 2) + pow(gesture.translation.height, 2))
                            scale = max(1.0 - distance / 1000, 0.5)
                        }
                        .onEnded{ gesture in
                            let distance = sqrt(pow(gesture.translation.width , 2) + pow(gesture.translation.height, 2))
                            if distance > 100 {
                                showtheview = false
                                withAnimation(.spring(dampingFraction: 0.7)){
                                    show.toggle()
                                    scale = 1.0
                                }
                            } else {
                                withAnimation{
                                    offset = CGSize.zero
                                    originalOffset = CGSize.zero
                                    scale = 1.0
                                }
                            }
                        }
                )
                
            }
            
        }
        .onChange(of: show) {
            offset = CGSize.zero
            originalOffset = CGSize.zero
        }
    }
    
    func addItem(title: String, body: String, color: String) {
        let newitem = NoteData(title: title, body: body, color: color)
        // Add item to the data context
        context.insert(newitem)
    }
    
    func deleteItem(item: NoteData) {
        context.delete(item)
    }
    
    func updateItem(item: NoteData) {
        //Edit
        item.title = "Update Test Item"
        //Save
        try? context.save()
    }
    
    func getColorFromString(colorName: String) -> Color? {
        switch colorName {
        case "orange":
            return .orange
        case "purple":
            return .purple
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "brown":
            return .brown
            // Diğer renkler buraya eklenir
        default:
            return nil
        }
    }
    
    func getStringFromColor(_ color: Color) -> String? {
        if color == .black {
            return "orange"
        } else if color == .orange {
            return "purple"
        } else if color == .red {
            return "red"
        } else if color == .green {
            return "green"
        } else if color == .blue {
            return "blue"
        } else if color == .yellow {
            return "yellow"
        } else if color == .brown {
            return "brown"
        // Diğer renkler buraya eklenir
        } else {
            return nil // Tanınmayan bir renk durumunda nil döner
        }
    }

    
}

#Preview {
    ContentView()
}

