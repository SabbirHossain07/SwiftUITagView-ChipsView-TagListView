//
//  Home.swift
//  Tagging
//
//  Created by Sopnil Sohan on 14/10/21.
//

import SwiftUI

struct Home: View {
    
    @State var text: String = ""
    @State var tags: [Tag] = []
    @State var showAlert: Bool = false
    
    var body: some View {
        
        VStack {
            
            Text("Filter \nMenus")
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            //Custom Tag View...
            TagView(maxLimit: 150, tags: $tags)
            //Default Height...
                .frame(height: 280)
                .padding(.top, 20)
            
            //TextField...
            TextField("Your Tag", text: $text)
                .font(.title3)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )
            //Setting only Textfield as Dark...
                .environment(\.colorScheme, .dark)
                .padding(.vertical, 18)
            
            //Add Button..
            Button {
                
                addTag(tags: tags, text: text, fontSize: 16, maxLimit: 150) {alert, tag in
                    
                    if alert{
                        //showing alert..
                        showAlert.toggle()
                    }else {
                        //adding Tag..
                        tags.append(tag)
                        text = ""
                    }
                }
                
            } label: {
                Text("Add tag")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.indigo)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 45)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            //Disabling Button....
            .disabled(text == "")
            .opacity(text == "" ? 0.6 : 1)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            
            Color.indigo.ignoresSafeArea()
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag Limit Exceeded try to delete some tags !!!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
