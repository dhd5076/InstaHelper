//
//  ScanBarcodeView.swift
//  InstaHelper
//
//  Created by Dylan Dunn on 8/16/20.
//  Copyright © 2020 Dylan Dunn. All rights reserved.
//
import CodeScanner
import CoreImage.CIFilterBuiltins
import SwiftUI
import EANBarcodeGenerator

struct ScanBarcodeView: View {
    @State private var isShowingScanner = false
    @State private var barcodeValue = "0000000000000"
    @State private var itemName = ""
    
    
    let context = CIContext()
    let filter = CIFilter.barcodeGenerator()
    
    func generateQRData(str: String) -> Data {
         let filter = CIFilter(name: "CIEANBarcodeGenerator")
         filter?.setValue(str, forKey: "inputMessage")
         let transform = CGAffineTransform(scaleX: 5, y: 5)
        print(str)


         let image = filter?.outputImage?.transformed(by: transform)
         let uiImage = UIImage(ciImage: image!)

         return uiImage.pngData()!
    }
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: self.generateQRData(str: barcodeValue)) ?? UIImage(named: "noImage1")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            Text(barcodeValue)
            VStack(alignment: .leading) {
                Text("Item Name")
                    .font(.headline)
                TextField("Bananas, Milk, etc.", text: $itemName)               .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            Button(action: {
                print("Hello World")
            }) {
                Text("Add To List")
            }
            .font(.title)
            .padding(12)
            .background(Color.green)
            .accentColor(.white)
            .cornerRadius(12)
            .offset(x: 0, y: -12)
            Spacer()
            Button(action: {
                self.isShowingScanner = true;
            }) {
                Text("Scan Barcode")
                    .font(.largeTitle)
                    .padding(12)
                    .background(Color.gray)
                    .accentColor(.white)
                    .cornerRadius(12)
                    .offset(x: 0, y: -12)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.ean8, .ean13], simulatedData: "5901234123457", completion: self.handleScan)
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        print("Hello World")
        switch(result) {
        case .success(let code):
            barcodeValue = code
            print(code)
        case .failure(let error):
            barcodeValue = error.localizedDescription
            print(error.localizedDescription)
        }
    }
}

struct ScanBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        ScanBarcodeView()
    }
}
