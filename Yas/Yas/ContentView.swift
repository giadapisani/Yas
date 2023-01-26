//
//  ContentView.swift
//  Yas
//
//  Created by Giada Pisani on 29/12/22.
//

/* to do list app with core data hopefully*/


import SwiftUI

enum Priority : String, Identifiable, CaseIterable{
    var id: UUID{
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
extension Priority{
    var title: String{
        switch self{
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

struct ContentView: View {
    
    @State private var title : String = ""
    @State private var selectedPriority : Priority = .medium
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key : "dateCreated", ascending: false)]) private var allTask: FetchedResults<Task>
    
    private func saveTask(){
        do{
            let task = Task(context: viewContext)
            task.title        = title
            task.priority     = selectedPriority.rawValue
            task.dateCreated  = Date()
            try viewContext.save()
        }   catch {
              print(error.localizedDescription)
        }
    }
    
    //funzione per il picker che poi non ho usato
 /*   private func styleForPriority(_ value: String) -> Color{
        let priority = Priority(rawValue: value)
        
        switch priority{
        case .low:
            return Color.green
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        default:
            return Color.black
        }
    } */
    
    private func updateTask(_ task : Task){
        task.isFavorite = !task.isFavorite
        do{
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets : IndexSet){
        offsets.forEach { index in
            let task = allTask[index]
            viewContext.delete(task)
            do{
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //view
    var body: some View {
        NavigationView{
            
            VStack{
                //
                TextField("Enter your magic words here:", text: $title)
                    .textFieldStyle(.roundedBorder)
                //
             /*   Picker("Priority", selection: $selectedPriority){
                    ForEach(Priority.allCases){ priority in
                        Text(priority.title).tag(priority)
                    }
                }.pickerStyle(.segmented) */
                //
                Button("Save"){
                    saveTask()
                }
                 .padding(10)
                 .frame(maxWidth: .infinity)
                 .background(Color(hue: 0.828, saturation: 0.282, brightness: 0.824))
                 .foregroundColor(Color.white)
                 .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
                //
               
                    .font(.headline)
                    .fontWeight(.semibold)
                    
                //
                List{
                    Text("All your affirmations will be saved here ✨")
                        .font(.title)
                        .fontWeight(.semibold)
                    ForEach(allTask){ task in
                        HStack{
                           // Circle()
                            //    .fill(styleForPriority(task.priority!))
                          //      .frame(width: 15, height: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isFavorite ? "heart.fill" :  "heart")
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                    }.onDelete(perform: deleteTask)
                
                }
                .background(Color(hue: 0.646, saturation: 0.234, brightness: 0.98))

            .scrollContentBackground(.hidden)

                //
                
                
                
             Spacer()
            }
            .padding()
            .navigationTitle("Daily Affirmation")
            
        }
      
        
    }
        
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistentContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
    }
}
