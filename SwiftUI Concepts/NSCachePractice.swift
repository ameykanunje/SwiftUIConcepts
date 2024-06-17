//
//  NSCache.swift
//  SwiftUI Concepts
//
//  Created by Amey Kanunje on 6/16/24.
//

import SwiftUI


class CacheManager{
    static let instance = CacheManager()
    private init(){} //if we dont use this we can still create another instance of it.
    //this is a computed property
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>() //doing this to make changes before returning it.
        cache.countLimit = 100
        cache.totalCostLimit = 1024*1024*100 //100mb
        return cache
    }()
    
    func add(image : UIImage, name : String) -> String{
        imageCache.setObject(image, forKey: name as NSString)
        return "Added to cache"
    }
    
    func remove(name: String) -> String{
        imageCache.removeObject(forKey: name as NSString)
        return "Removed from Cache"
    }
    
    func getImage(name: String) -> UIImage?{
        return imageCache.object(forKey: name as NSString)
    }
    
}

class CacheViewModel : ObservableObject{
    
    @Published var startingImage: UIImage? = nil
    @Published var previousImage: UIImage? = nil
    let imageName : String = "Architecture"
    let manager = CacheManager.instance
    @Published var infoMessage : String = ""
    
    init(){
        getImageFromAssetsFolder()
    }
    
    func getImageFromAssetsFolder(){
        startingImage = UIImage(named: imageName)
    }
    
    func saveToCache(){
        guard let image = startingImage else{return}
        infoMessage = manager.add(image: image, name: imageName)
    }
    
    func removeFromCache(){
        infoMessage = manager.remove(name: imageName)
    }
    
    func getFromCache(){
        previousImage = manager.getImage(name: imageName)
//        if let returnedImage = manager.getImage(name: imageName){
//            previousImage = returnedImage
//            infoMessage = "Found in Cache"
//        }else{
//            infoMessage = "Not Found in Cache"
//        }
        
    }
    
}


struct NSCachePractice: View {
    @StateObject var vm = CacheViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                if let startingImage = vm.startingImage{
                    Image(uiImage: startingImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                }
                Text(vm.infoMessage)
                HStack {
                    Button(action: {
                        vm.saveToCache()
                        
                    }, label: {
                        Text("Saved to Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                })
                    Button(action: {
                        vm.removeFromCache()
                    }, label: {
                        Text("Delete From Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                })
                }
                Button(action: {
                    vm.getFromCache()

                }, label: {
                    Text("Get From Cache")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
            })
                if let startingImage = vm.previousImage{
                    Image(uiImage: startingImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                }
                
                
                Spacer()
            }
            .navigationTitle("Caching")
            
        }
    }
}

#Preview {
    NSCachePractice()
}
