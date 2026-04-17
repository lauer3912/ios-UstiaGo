//
//  SoundManager.swift
//  Clarity
//
//  Ambient sound playback using AVAudioEngine
//

import Foundation
import AVFoundation

// MARK: - Sound Type

enum ClaritySoundType: String, CaseIterable {
    case none = "none"
    case rain = "rain"
    case forest = "forest"
    case ocean = "ocean"
    case coffee = "coffee"
    case fire = "fire"
    case whiteNoise = "white"
    case brownNoise = "brown"
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .rain: return "Rain"
        case .forest: return "Forest"
        case .ocean: return "Ocean"
        case .coffee: return "Coffee Shop"
        case .fire: return "Fireplace"
        case .whiteNoise: return "White Noise"
        case .brownNoise: return "Brown Noise"
        }
    }
    
    var icon: String {
        switch self {
        case .none: return "speaker.slash"
        case .rain: return "cloud.rain"
        case .forest: return "leaf"
        case .ocean: return "water.waves"
        case .coffee: return "cup.and.saucer"
        case .fire: return "flame"
        case .whiteNoise: return "waveform"
        case .brownNoise: return "waveform.path"
        }
    }
}

// MARK: - Sound Manager

class ClaritySoundManager: ObservableObject {
    static let shared = ClaritySoundManager()
    
    @Published var currentSound: ClaritySoundType = .none
    @Published var isPlaying: Bool = false
    @Published var volume: Float = 0.5
    
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var noiseBuffer: AVAudioPCMBuffer?
    
    private init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        
        guard let engine = audioEngine, let player = playerNode else { return }
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        
        do {
            try engine.start()
        } catch {
            print("ClaritySoundManager: Failed to start audio engine - \(error)")
        }
    }
    
    func play(sound: ClaritySoundType) {
        stop()
        
        guard sound != .none else { return }
        
        currentSound = sound
        isPlaying = true
        
        // Generate noise buffer based on type
        generateNoiseBuffer(for: sound)
        
        guard let player = playerNode, let buffer = noiseBuffer else { return }
        
        player.scheduleBuffer(buffer, at: nil, options: .loops)
        player.play()
        
        player.volume = volume
    }
    
    func stop() {
        playerNode?.stop()
        isPlaying = false
        currentSound = .none
    }
    
    func toggle() {
        if isPlaying {
            stop()
        } else if currentSound != .none {
            play(sound: currentSound)
        }
    }
    
    func setVolume(_ newVolume: Float) {
        volume = max(0, min(1, newVolume))
        playerNode?.volume = volume
    }
    
    private func generateNoiseBuffer(for sound: ClaritySoundType) {
        let sampleRate: Double = 44100
        let duration: Double = 2.0 // 2 second loop
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return
        }
        
        buffer.frameLength = frameCount
        
        guard let leftChannel = buffer.floatChannelData?[0],
              let rightChannel = buffer.floatChannelData?[1] else {
            return
        }
        
        switch sound {
        case .none:
            break
            
        case .rain:
            // Rain: Pink noise with occasional droplet spikes
            var lastValue: Float = 0
            for i in 0..<Int(frameCount) {
                let white = Float.random(in: -1...1)
                lastValue = lastValue * 0.7 + white * 0.3 // Pink noise
                
                // Add occasional droplets
                if Float.random(in: 0...1) > 0.998 {
                    lastValue += Float.random(in: 0.3...0.8)
                }
                
                leftChannel[i] = lastValue * 0.4
                rightChannel[i] = lastValue * 0.4
            }
            
        case .forest:
            // Forest: Brown noise with bird-like chirps
            var lastValue: Float = 0
            for i in 0..<Int(frameCount) {
                let white = Float.random(in: -1...1)
                lastValue = lastValue * 0.95 + white * 0.05 // Very low frequency
                
                // Occasional chirps
                if Int.random(in: 0...Int(frameCount)) > Int(frameCount) - 50 {
                    let chirp = sin(Float(i) * 0.5) * Float.random(in: 0.2...0.5)
                    lastValue += chirp
                }
                
                leftChannel[i] = lastValue * 0.3
                rightChannel[i] = lastValue * 0.3
            }
            
        case .ocean:
            // Ocean: Filtered noise with wave rhythm
            var lastValue: Float = 0
            let waveFreq: Float = 0.1
            for i in 0..<Int(frameCount) {
                let white = Float.random(in: -1...1)
                lastValue = lastValue * 0.8 + white * 0.2
                
                let wave = (sin(Float(i) * waveFreq * 0.01) + 1) * 0.5
                let modulated = lastValue * (0.3 + wave * 0.4)
                
                leftChannel[i] = modulated * 0.5
                rightChannel[i] = modulated * 0.5
            }
            
        case .coffee:
            // Coffee shop: Brown noise with occasional clinks
            var lastValue: Float = 0
            for i in 0..<Int(frameCount) {
                let white = Float.random(in: -1...1)
                lastValue = lastValue * 0.9 + white * 0.1
                
                // Occasional cup clink
                if Float.random(in: 0...1) > 0.9995 {
                    lastValue += Float.random(in: 0.4...0.7)
                }
                
                leftChannel[i] = lastValue * 0.35
                rightChannel[i] = lastValue * 0.35
            }
            
        case .fire:
            // Fireplace: Crackling brown noise
            var lastValue: Float = 0
            for i in 0..<Int(frameCount) {
                let white = Float.random(in: -1...1)
                lastValue = lastValue * 0.85 + white * 0.15
                
                // Crackles
                if Float.random(in: 0...1) > 0.997 {
                    lastValue += Float.random(in: 0.5...1.0)
                }
                
                leftChannel[i] = lastValue * 0.4
                rightChannel[i] = lastValue * 0.4
            }
            
        case .whiteNoise:
            // White noise: Equal energy at all frequencies
            for i in 0..<Int(frameCount) {
                let sample = Float.random(in: -0.3...0.3)
                leftChannel[i] = sample
                rightChannel[i] = sample
            }
            
        case .brownNoise:
            // Brown noise: Increasing energy at lower frequencies
            var lastValue: Float = 0
            for i in 0..<Int(frameCount) {
                let white = Float.random(in: -1...1)
                lastValue = lastValue * 0.95 + white * 0.05
                
                leftChannel[i] = lastValue * 0.5
                rightChannel[i] = lastValue * 0.5
            }
        }
        
        noiseBuffer = buffer
    }
    
    deinit {
        stop()
        audioEngine?.stop()
    }
}
