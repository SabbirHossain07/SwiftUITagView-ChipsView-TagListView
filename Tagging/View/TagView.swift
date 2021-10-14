//
//  TagView.swift
//  Tagging
//
//  Created by Sopnil Sohan on 14/10/21.
//

import SwiftUI

struct TagView: View {
    
    var maxLimit: Int
    @Binding var tags: [Tag]
    var title: String = "Add Some Tags"
    var fontSize: CGFloat = 16
    
    //Adding Geometry Effect to Tag...
    @Namespace var animation 
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(title)
                .font(.callout)
                .foregroundColor(Color.white)
            
            //ScrollView...
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    //Displaying Tags.....
                    ForEach(getRows(),id: \.self) {rows in
                        
                        HStack(spacing: 6) {
                            
                            ForEach(rows){ row in
                                
                                //row view...
                                RowView(tag: row)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
                .padding(.vertical)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.white.opacity(0.15),lineWidth: 1)
            )
            //animation...
            .animation(.easeInOut, value: tags)
            .overlay(
                //Limit...
                Text("\(getSize(tags: tags))/\(maxLimit)")
                    .font(.system(size: 13,weight: .semibold))
                    .foregroundColor(Color.white)
                    .padding(12),
                alignment: .bottomTrailing
            )
        }
        //Since onChange will perfome little late...
        
     //   .onChange(of: tags) { newValue in
    //    }

    }
    @ViewBuilder
    func RowView(tag: Tag)-> some View {
        Text(tag.text)
        //aplying same font size...
        //else size will very...
            .font(.system(size: fontSize))
        //adding capsul....
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
               Capsule()
                .fill(Color.white)
            )
            .foregroundColor(Color.indigo)
            .lineLimit(1)
        //Delete...
            .contentShape(Capsule())
            .contextMenu {
                Button("Delete") {
                    //deleting....
                    tags.remove(at: getIndex(tag: tag))
                }
            }
            .matchedGeometryEffect(id: tag.id, in: animation)
    }
    
    func getIndex(tag: Tag)->Int {
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        return index
    }
    //Basic Logic
    //Spliting the array when it exceeds the screen size...
    func getRows()->[[Tag]]{
        
        var rows: [[Tag]] = []
        var currentRows: [Tag] = []
        
        //Caluclating text width...
        var totalWidth: CGFloat = 0
        
        //For sefty extra 10...
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        tags.forEach { tag in
            //updating total width...
            
            //adding the capsule size into total width with spacing....
            //14 + 14 + 6 + 6...
            //extra 6 for safety...
            totalWidth += (tag.size + 40)
            
            //cheacking if totalwidth is greater then size...
            if totalWidth > screenWidth {
                //adding row in rows...
                //clearing the data...
                //chacking for long string...
                
                totalWidth = (!currentRows.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
                
                rows.append(currentRows)
                currentRows.removeAll()
                currentRows.append(tag)
            }else {
                currentRows.append(tag)
            }
            
        }
        //safe check...
        //if having any value stories it in rows...
        if !currentRows.isEmpty{
            rows.append(currentRows)
            currentRows.removeAll()
        }
        
        return rows
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func addTag(tags:[Tag],text: String,fontSize: CGFloat,maxLimit: Int,completion: @escaping (Bool,Tag)->()){
    
    //getting text size...
    let font = UIFont.systemFont(ofSize: fontSize)
    
    let attributes = [NSAttributedString.Key.font: font]
    
    let size = (text as NSString).size(withAttributes: attributes)
    
    let tag = Tag(text: text, size: size.width)
    
    if (getSize(tags: tags) + text.count) < maxLimit {
        completion(false, tag)
    }else{
        completion(true,tag)
    }
}

func getSize(tags: [Tag])->Int{
    var count: Int = 0
    
    tags.forEach {tag in
        count += tag.text.count
    }
    return count
}
