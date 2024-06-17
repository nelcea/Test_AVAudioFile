//
//  AudioFunctions.swift
//  Test_AVAudioFile
//
//  Created by Eric Bariaux on 16/06/2024.
//

import Foundation

import AVFoundation

let sampleRate: Double = 8000
let samples: [Int16] = {
    var s = [Int16]()
    for i in 0..<16000 {
        s.append(Int16(sinf(Float(i) / 2) * Float(Int16.max)))
    }
    return s
}()

fileprivate func writeFile(audioFormat: AVAudioFormat, pcmBuffer: AVAudioPCMBuffer) {
    guard let audioFile = try? AVAudioFile(forWriting: URL(fileURLWithPath: "generated.wav"), settings: audioFormat.settings) else {
        fatalError("Error initializing AVAudioFile")
    }
    
    do {
        try audioFile.write(from: pcmBuffer)
    } catch {
        print(error.localizedDescription)
    }
}

func intFormatNoCommonFormat() {
    guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: false) else {
        print("Error creating audio format")
        return
    }
    
    guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: 16000) else {
        print("Error creating PCM buffer")
        return
    }
    
    pcmBuffer.frameLength = 16000
  
    let channels = UnsafeBufferPointer(start: pcmBuffer.int16ChannelData, count: Int(pcmBuffer.format.channelCount))

    let data = samples.withUnsafeBufferPointer( { Data(buffer: $0 )})

    UnsafeMutableRawPointer(channels[0]).withMemoryRebound(to: UInt8.self, capacity: data.count) {
        (bytes: UnsafeMutablePointer<UInt8>) in
        data.copyBytes(to: bytes, count: data.count)
    }
    
    writeFile(audioFormat: audioFormat, pcmBuffer: pcmBuffer)
}

func floatFormatNoCommonFormat() {
    guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false) else {
        print("Error creating audio format")
        return
    }
    
    guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: 16000) else {
        print("Error creating PCM buffer")
        return
    }
    
    pcmBuffer.frameLength = 16000

    let f32Array = samples.map({Float32($0) / Float32(Int16.max)})

    let channels = UnsafeBufferPointer(start: pcmBuffer.floatChannelData, count: Int(pcmBuffer.format.channelCount))

    let data = f32Array.withUnsafeBufferPointer( { Data(buffer: $0 )})
    
    UnsafeMutableRawPointer(channels[0]).withMemoryRebound(to: UInt8.self, capacity: data.count) {
        (bytes: UnsafeMutablePointer<UInt8>) in
        data.copyBytes(to: bytes, count: data.count)
    }

    writeFile(audioFormat: audioFormat, pcmBuffer: pcmBuffer)
}

func intFormatUsingCommonFormat() {
    guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: false) else {
        print("Error creating audio format")
        return
    }
    
    guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: 16000) else {
        print("Error creating PCM buffer")
        return
    }
    
    pcmBuffer.frameLength = 16000
  
    let channels = UnsafeBufferPointer(start: pcmBuffer.int16ChannelData, count: Int(pcmBuffer.format.channelCount))

    let data = samples.withUnsafeBufferPointer( { Data(buffer: $0 )})

    UnsafeMutableRawPointer(channels[0]).withMemoryRebound(to: UInt8.self, capacity: data.count) {
        (bytes: UnsafeMutablePointer<UInt8>) in
        data.copyBytes(to: bytes, count: data.count)
    }
    
    guard let recordingAudioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: false) else {
        print("Error creating recording audio format")
        return
    }
    
    guard let audioFile = try? AVAudioFile(forWriting: URL(fileURLWithPath: "generated_int16.wav"), settings: recordingAudioFormat.settings, commonFormat: .pcmFormatInt16, interleaved: false) else {
        fatalError("Error initializing AVAudioFile")
    }
    
    do {
        try audioFile.write(from: pcmBuffer)
    } catch {
        print(error.localizedDescription)
    }
}
