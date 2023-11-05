//
//  ComplexScrollView.swift
//  Rocket-iOS17
//
//  Created by mohsen mokhtari on 11/5/23.
//

import SwiftUI

struct ComplexScrollView: View {
    @State private var allExpenses: [ScrollExpense] = []
    @State private var activeCard: UUID?
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Hello Mohsen")
                        .font(.largeTitle.bold())
                        .frame(height: 45)
                        .padding(.horizontal)

                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = rect.minY.rounded()


                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 0) {
                                ForEach(scrollcards) { card in
                                    ZStack {
                                        if minY == 77 {
                                            // Not Scroll
                                            CardView(card)
                                        } else {
                                            // Scrolled
                                            // showing Only selected Card
                                            if activeCard == card.id {
                                                CardView(card)
                                            } else {
                                                Rectangle()
                                                    .fill(.clear)
                                            }
                                        }
                                    }
                                        .containerRelativeFrame(.horizontal)
                                }
                            }
                                .scrollTargetLayout()
                        }
                            .scrollPosition(id: $activeCard)
                            .scrollTargetBehavior(.paging)
                            .scrollClipDisabled()
                            .scrollIndicators(.hidden)
                            .scrollDisabled(minY != 77)

                    }.frame(height: 125)
                }

                LazyVStack(spacing: 15) {
                    Menu {

                    } label: {
                        HStack(spacing: 4) {
                            Text("Filter By")
                            Image(systemName: "chevron.down")
                        }
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    ForEach(allExpenses) { expense in
                        ExpenseCardView(expense)
                    }
                }.padding()
                    .mask {
                    Rectangle()
                        .visualEffect { content, proxy in
                        content.offset(y: backgeoundLimitOffset(proxy))
                    }
                }
                    .background {
                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = min(rect.minY - 125, 0)
                        let progress = max(min(-minY / 25, 1),0)

                        RoundedRectangle(cornerRadius: 30 * progress, style: .continuous)
                            .fill(scheme == .dark ? .black : .white)
                            .visualEffect { content, proxy in
                            content.offset(y: backgeoundLimitOffset(proxy))

                        }
                    }
                }


            }.padding(.vertical)
        }
        .scrollTargetBehavior(CustomScrollBehavior())
            .scrollIndicators(.hidden)
            .task {
            if activeCard == nil {
                activeCard = scrollcards.first?.id
            }
        }.onChange(of: activeCard) { oldValue, newValue in
            withAnimation(.snappy) {
                allExpenses = scrollExpenses.shuffled()
            }
        }
    }

    private func backgeoundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        return minY < 100 ? -minY + 100 : 0
    }

    @ViewBuilder
    private func CardView(_ card: ScrollCard) -> some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let topValue: CGFloat = 77.0
            let offset = min(minY - 77, 0)
            let progress = max(min(-offset / topValue, 1), 0)
            let scale: CGFloat = 1 + progress
            ZStack {
                Rectangle()
                    .fill(card.bgColor)
                    .overlay(alignment: .leading) {
                    Circle()
                        .fill(card.bgColor)
                        .overlay {
                        Circle()
                            .fill(.white.opacity(0.2))
                    }
                        .scaleEffect(2, anchor: .topLeading)
                        .offset(x: -50, y: -40)
                }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .scaleEffect(scale, anchor: .bottom)

                VStack(alignment: .leading, spacing: 4) {
                    Spacer(minLength: 0)
                    Text("Current Balance")
                        .font(.callout)

                    Text(card.balance)
                        .font(.title.bold())
                }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .offset(y: progress * -25)
            }
                .offset(y: -offset)
                .offset(y: progress * -topValue)
        }
            .padding(.horizontal)
    }


    @ViewBuilder
    private func ExpenseCardView(_ expense: ScrollExpense) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.product)
                    .font(.callout)
                    .fontWeight(.bold)

                Text(expense.spendType)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer(minLength: 0)

            Text(expense.amountSpent)
                .fontWeight(.bold)
        }
            .padding(.horizontal)
            .padding(.vertical, 6)

    }
}

    // scrollWillEndDragging in UIKit
struct CustomScrollBehavior: ScrollTargetBehavior{
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 77 {
            target.rect = .zero
        }
    }
}

#Preview {
    ComplexScrollView()
}
