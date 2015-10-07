//
//  JsonSerailizer.swift
//
//
//  Created by Michael Seemann on 05.10.15.
//
//

import Foundation

enum JsonWriterError: ErrorType {
    case NSJSONSerializationError
}

public class JsonWriter {
    
    var outputStream: NSOutputStream
    var objectWritten = false
    
    public init (outputStream: NSOutputStream) {
        self.outputStream = outputStream
    }
    
    public func writeArrayStart() {
        openStreamIfNeeded()
        write("[")
    }
   
    public func writeArrayEnd() {
        openStreamIfNeeded()
        write("]")
    }
    
    public func writeObject(theObject: AnyObject) throws {
        openStreamIfNeeded()
        if(objectWritten){
            write(",\r\n")
            objectWritten = false
        }
        
        var err: NSError?
        
        NSJSONSerialization.writeJSONObject(theObject, toStream: self.outputStream, options: NSJSONWritingOptions(rawValue: 0), error: &err)
        
        if(err != nil){
            throw JsonWriterError.NSJSONSerializationError
        }
        
        objectWritten = true
    }
    
    func openStreamIfNeeded(){
        if(outputStream.streamStatus != NSStreamStatus.Open){
            outputStream.open()
        }
    }
    
    func write(theString: String) {
        let data = stringToData(theString)
        outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    
    func stringToData(theString: String) -> NSData {
        return theString.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}