//
//  UstiaCreditsView.swift
//  UstiaGo
//
//  Focus Credits & Daily Streak Bonus View
//

import SwiftUI

struct UstiaCreditsView: View {
    @State private var balance: Int = 100
    @State private var hasClaimedToday: Bool = false
    @State private var isClaiming: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "timer.circle.fill")
                                .font(.title2)
                                .foregroundColor(UstiaTheme.accentPrimary)
                            Text("Clarity Focus Credits")
                                .font(.headline)
                                .foregroundColor(UstiaTheme.textPrimary)
                            Spacer()
                            Text("\(balance) pts")
                                .font(.title3.bold())
                                .foregroundColor(UstiaTheme.textPrimary)
                        }

                        Text("Credits unlock advanced deep work soundscapes, ambient wind-down sessions, and AI focus pattern insights.")
                            .font(.subheadline)
                            .foregroundColor(UstiaTheme.textSecondary)

                        Divider()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily Focus Bonus")
                                    .font(.subheadline.bold())
                                    .foregroundColor(UstiaTheme.textPrimary)
                                Text("+10 credits for daily mindfulness")
                                    .font(.caption)
                                    .foregroundColor(UstiaTheme.textSecondary)
                            }
                            Spacer()
                            Button {
                                claimBonus()
                            } label: {
                                if isClaiming {
                                    ProgressView()
                                } else {
                                    Text(hasClaimedToday ? "Claimed Today" : "Claim +10")
                                        .font(.subheadline.bold())
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(hasClaimedToday || isClaiming)
                        }
                    }
                    .padding(.vertical, 6)
                } header: {
                    Text("Free Tier Quota")
                } footer: {
                    Text("All standard Pomodoro intervals, custom screen goals, and offline session logs are permanently free.")
                }

                Section("Pro Benefits") {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(UstiaTheme.accentWarm)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Lifetime Offline Access")
                                .font(.subheadline.bold())
                                .foregroundColor(UstiaTheme.textPrimary)
                            Text("Zero telemetry, zero ads, 100% private on-device data.")
                                .font(.caption)
                                .foregroundColor(UstiaTheme.textSecondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Focus Credits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                if let bal = try? await BuyservicesClient.shared.fetchBalance() {
                    balance = bal
                }
            }
        }
    }

    private func claimBonus() {
        guard !hasClaimedToday else { return }
        isClaiming = true
        _Concurrency.Task {
            if let newBal = try? await BuyservicesClient.shared.claimDailyBonus() {
                balance += newBal
            } else {
                balance += 10
            }
            hasClaimedToday = true
            isClaiming = false
        }
    }
}
