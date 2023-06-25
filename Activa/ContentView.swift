//
//  ContentView.swift
//  Activa
//
//  Created by TheDen on 14/6/2023.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var selectedTime1 = 1
    @State private var selectedTime2 = 1
    @State private var isStartTimeSelected = false
    @State private var buttonIcon = "play"
    @State private var buttonText = "Start"
    @State private var currentInterval = "One"
    @State private var remainingTime = 0
    @State private var shouldRepeatTimers = false
    @State private var isTimerOneActive = false
    let timerInterval = 1.0  // Interval in seconds for updating the remaining time
    @State private var timer: Timer?
    let soundPlayer = AVPlayer()
    let soundURL = Bundle.main.url(forResource: "ding", withExtension: "wav")
    @State private var isVStackVisible = false
    @State private var timerColor = Color.blue

    
    var body: some View {
        
        let intervals = Array(1...30)
        NavigationView {
                Form {
                    VStack {
                            Image("icon-512")
                                .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .padding(.top, 0)
                            .padding(.bottom, 10)
                        Text("Interval One")
                            .font(.title)
                            .fontWeight(.thin)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .border(Color.clear, width: 0)
                            .foregroundColor(Color.blue)
                            .padding(.bottom, 0)
                        Picker(selection: $selectedTime1, label: Text("Time Interval")) {
                            ForEach(intervals, id: \.self) { interval in
                                if interval == 1 {
                                    Text("\(interval) min")
                                } else {
                                    Text("\(interval) mins")
                                }
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 90) // Adjust the height as desired
                        .padding(.bottom, 10)
                        .padding(.top, 0)
                        .font(.system(size: 14, weight: .thin))
                        .padding(0)
                        Text("Interval Two")
                            .font(.title)
                            .fontWeight(.thin)
                            .padding(.top, 10)
                            .padding(.bottom, 0)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .border(Color.clear, width: 0)
                            .foregroundColor(Color.green)
                        Picker(selection: $selectedTime2, label: Text("Time Interval")) {
                            ForEach(intervals, id: \.self) { interval in
                                if interval == 1 {
                                    Text("\(interval) min")
                                } else {
                                    Text("\(interval) mins")
                                }                                     }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 90) // Adjust the height as desired
                        .font(.system(size: 14, weight: .thin))
                        .padding(.bottom, 10)
                        .padding(.top, 0)

                        Toggle("Repeat Intervals", isOn: $shouldRepeatTimers)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 10)
                            .padding(.top, 0)
                            .font(.system(size: 14, weight: .thin))
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        Button(action: {
                            if buttonText == "Start" {
                                startTimer()
                            } else if buttonText == "Stop" {
                                stopTimer()
                                
                            }
                            // Perform any actions you want when the start time button is tapped
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: buttonIcon)
                                Text(buttonText)
     
                            }
                            .font(.title2)
                            .font(.system(size: 14, weight: .thin))
                            .padding()
                            .foregroundColor(.blue)
                            .background(
                                Capsule()
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                        
                    }
                    if isStartTimeSelected {
                            VStack {
                                Text("Interval \(currentInterval)")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 5)
                                    .foregroundColor(timerColor)
                                    .font(.system(size: 14, weight: .regular))

                                //.disabled(Hide)
                                Text("\(remainingTime) seconds")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(size: 14, weight: .regular))

                            } .padding(.top, 10)
                            .padding(.bottom, 10)
                        }
                } .padding(.top, -10)
                .padding(.bottom, -10)
                .edgesIgnoringSafeArea(.bottom)
                .padding(.vertical, -20)
            }
            .navigationBarHidden(true) // Hide the navigation bar
            .navigationViewStyle(StackNavigationViewStyle())
            .overlay(
                  Color.clear
                      .frame(width: 1, height: 1) // adjust the size as needed
                      .onAppear {
                          UIScrollView.appearance().bounces = false
                      })
        }
        
    
    func startTimer() {
        isStartTimeSelected = true
        buttonIcon = "hourglass"
        buttonText = "Stop"
        remainingTime = selectedTime1 * 60
        currentInterval = "One"
        timerColor = Color.blue
        isTimerOneActive = true
        
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            remainingTime -= Int(timerInterval)
            
            if remainingTime == -1 {
                remainingTime = 0
                
            }
            
            if remainingTime <= 0 {
                timer.invalidate()
                playSound()
                currentInterval = "Two"
                timerColor = Color.green
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.remainingTime = self.selectedTime2 * 60
                    self.timer = Timer.scheduledTimer(withTimeInterval: self.timerInterval, repeats: true) { timer in
                        self.remainingTime -= Int(self.timerInterval)
                        
                        if self.remainingTime == -1 {
                            self.remainingTime = 0
                        }
                        
                        if remainingTime <= 0 {
                            if isTimerOneActive {
                                if shouldRepeatTimers {
                                    stopTimer()
                                    playSound()
                                    startTimer() // Start the timers again
                                } else {
                                    stopTimer()
                                    playSound()
                                    buttonText = "Start"
                                    buttonIcon = "play"
                                }
                            } else {
                                stopTimer()
                            }
                        }
                            
                    }
                }
            }
        }
        isStartTimeSelected = true
        
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isStartTimeSelected = false
        buttonText = "Start"
        buttonIcon = "play"
        remainingTime = 0
        currentInterval = "One"
        timerColor = Color.blue
        isTimerOneActive = false
    }
    
    func playSound() {
        guard let url = soundURL else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        soundPlayer.replaceCurrentItem(with: playerItem)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            soundPlayer.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}
