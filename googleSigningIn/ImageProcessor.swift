//
//  ImageProcessor.swift
//  googleSigningIn
//
//  Created by Andrey Rybalkin on 20.03.2023.
//

import Foundation
import UIKit

class ImageProcessor {
    
    
    func averageColors(of image: UIImage?) -> [UIColor]? {
        guard let image else { return nil }
        let segmentSize = 16
        
        guard let resizedImage = resize(image: image, to: CGSize(width: 256, height: 256)) else {
            return nil
        }
        
        var colors: [UIColor] = []
        
        for y in 0..<segmentSize {
            for x in 0..<segmentSize {
                let rect = CGRect(x: x * segmentSize, y: y * segmentSize, width: segmentSize, height: segmentSize)
                if let averageColor = calculateAverageColor(in: resizedImage, rect: rect) {
                    colors.append(averageColor)
                }
            }
        }
        
        return colors
    }
    
    func resize(image: UIImage, to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func calculateAverageColor(in image: UIImage, rect: CGRect) -> UIColor? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        
        let width = Int(rect.width)
        let height = Int(rect.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: height * bytesPerRow)
        let context = CGContext(data: rawData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = bytesPerRow * y + bytesPerPixel * x
                let red = Int(rawData[offset])
                let green = Int(rawData[offset + 1])
                let blue = Int(rawData[offset + 2])
                
                totalRed += red
                totalGreen += green
                totalBlue += blue
            }
        }
        
        rawData.deallocate()
        
        let count = width * height
        let averageRed = totalRed / count
        let averageGreen = totalGreen / count
        let averageBlue = totalBlue / count
        
        return UIColor(red: CGFloat(averageRed) / 255.0, green: CGFloat(averageGreen) / 255.0, blue: CGFloat(averageBlue) / 255.0, alpha: 1.0)
    }
}
