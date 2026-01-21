//
//  AgentContext.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/01/2026.
//
// Represents the necessary app variables, models or references that callback functions need for the MCP tools to cause changes in the app.

struct AgentContext {
    let pantry: PantryViewModel // access users' current pantry data, propogate changes to the pantry
    let donation: DonationViewModel // access data around foodbanks, and propogate updates to these needs
}
