import Foundation
import SwiftData

struct PracticeCase: Identifiable, Hashable {
    let id: String
    let prompt: String
    let expectedIdea: String
    let relatedScientificName: String
}

enum StarterContent {
    static let sourceNote = "Iraq-focused example. Confirm the current product, leaflet, and local availability with the supervising pharmacist. Suggested references: Gudea and Iraq Drug Guide 2024–2025."

    static let cases: [PracticeCase] = [
        .init(id: "asthma-propranolol", prompt: "A patient with asthma is using propranolol. What should you be careful about?", expectedIdea: "Non-selective beta blockers may worsen bronchospasm. Confirm with the pharmacist.", relatedScientificName: "Propranolol"),
        .init(id: "warfarin-bleeding", prompt: "A patient taking an anticoagulant reports unusual bleeding. What is the safest training response?", expectedIdea: "Treat unusual bleeding as urgent and ask the pharmacist immediately. Do not make a treatment decision.", relatedScientificName: "Warfarin"),
        .init(id: "insulin-low-sugar", prompt: "A person using insulin describes sweating and shakiness. What should the student do?", expectedIdea: "These may be warning signs of low blood glucose. Ask the pharmacist immediately and do not independently advise treatment.", relatedScientificName: "Insulin")
    ]

    @MainActor
    static func importIfNeeded(into context: ModelContext) throws -> Int {
        let existing = try context.fetch(FetchDescriptor<Drug>())
        let existingIDs = Set(existing.compactMap(\.starterSeedID))
        let additions = seedDrugs.filter { seed in
            guard let seedID = seed.starterSeedID else { return false }
            return !existingIDs.contains(seedID)
        }
        additions.forEach { context.insert($0) }
        try context.save()
        return additions.count
    }

    @MainActor
    static func markImportedContentVerified(in context: ModelContext) throws {
        let drugs = try context.fetch(FetchDescriptor<Drug>())
        for drug in drugs where drug.starterSeedID != nil {
            drug.verificationStatus = .pharmacistVerified
        }
        try context.save()
    }

    static var seedDrugs: [Drug] {
        [
            drug("paracetamol", "Paracetamol", "Panadol", .otc, "Analgesic / antipyretic", "Tablet", "500 mg", "Pain and fever", "Follow the product label and pharmacist instructions.", "Nausea; rash", "Too much paracetamol can cause serious liver injury.", "Check all combination products to avoid duplicate paracetamol."),
            drug("amoxicillin-clavulanate", "Amoxicillin + clavulanic acid", "Augmentin", .antibiotics, "Penicillin antibiotic", "Tablet / suspension", "625 mg", "Susceptible bacterial infections", "Use only as prescribed and complete the prescribed course.", "Diarrhea; nausea", "Ask about penicillin allergy. Severe allergic symptoms require urgent help.", "Take exactly as prescribed and confirm preparation instructions with the pharmacist.", flags: [.children, .severeSymptoms]),
            drug("salbutamol", "Salbutamol", "Ventolin", .respiratory, "SABA", "Metered-dose inhaler", "100 micrograms/dose", "Relief of bronchospasm", "Use the inhaler technique shown by the pharmacist.", "Tremor; fast heartbeat", "Worsening breathing or unusually frequent use needs immediate pharmacist assessment.", "Ask the pharmacist to check your inhaler technique.", flags: [.children, .severeSymptoms]),
            drug("metformin", "Metformin", "Glucophage", .endocrine, "Biguanides", "Tablet", "500 mg", "Type 2 diabetes", "Take as prescribed; modified-release products must be identified correctly.", "Nausea; diarrhea", "Kidney function and severe illness matter; do not independently advise stopping or restarting.", "Taking it with food may reduce stomach upset; confirm the exact product instructions."),
            drug("amlodipine", "Amlodipine", "Norvasc", .cardiovascular, "Calcium channel blockers", "Tablet", "5 mg", "Hypertension and angina", "Take consistently as prescribed.", "Ankle swelling; flushing; headache", "Severe dizziness, fainting, or chest pain needs prompt pharmacist assessment.", "Take at the same time each day and report troublesome ankle swelling."),
            drug("bisoprolol", "Bisoprolol", "Concor", .cardiovascular, "Beta blockers", "Tablet", "5 mg", "Selected cardiovascular conditions", "Take as prescribed; do not stop suddenly without professional advice.", "Slow pulse; fatigue; dizziness", "Bradycardia, asthma history, and abrupt withdrawal require pharmacist review.", "Do not stop it suddenly; ask the pharmacist if you feel faint or unusually breathless.", flags: [.severeSymptoms]),
            drug("atorvastatin", "Atorvastatin", "Lipitor", .cardiovascular, "Statins", "Tablet", "20 mg", "Reduction of elevated cholesterol and cardiovascular risk", "Take as prescribed.", "Muscle aches; digestive upset", "Unexplained severe muscle pain, weakness, or pregnancy requires immediate pharmacist review.", "Report unexplained muscle pain and check before using it during pregnancy.", flags: [.pregnancy, .severeSymptoms]),
            drug("omeprazole", "Omeprazole", "Losec", .gastrointestinal, "Proton pump inhibitors", "Capsule", "20 mg", "Acid-related conditions", "Timing and swallowing instructions depend on the product.", "Headache; abdominal discomfort", "Persistent alarm symptoms or prolonged unsupervised use need pharmacist assessment.", "Follow the product timing instructions and ask if symptoms persist."),
            drug("diclofenac", "Diclofenac", "Voltaren", .musculoskeletal, "NSAIDs", "Tablet / gel", "50 mg", "Pain and inflammation", "Directions differ greatly between oral and topical products.", "Stomach upset; local skin irritation", "Bleeding risk, kidney disease, cardiovascular disease, and pregnancy require pharmacist review.", "Use the correct dosage form and ask before combining it with other pain medicines.", flags: [.pregnancy, .severeSymptoms]),
            drug("cetirizine", "Cetirizine", "Zyrtec", .respiratory, "Antihistamines", "Tablet / oral solution", "10 mg", "Allergic symptoms", "Take according to the product directions.", "Drowsiness; dry mouth", "Drowsiness can affect driving; pediatric dosing must be confirmed.", "See how it affects alertness before driving and confirm child doses with the pharmacist.", flags: [.children]),
            drug("furosemide", "Furosemide", "Lasix", .cardiovascular, "Diuretics", "Tablet", "40 mg", "Conditions requiring diuresis", "Take only as prescribed; timing is individualized.", "Increased urination; dizziness", "Dehydration, electrolyte disturbance, fainting, or severe weakness require pharmacist review.", "Rise slowly and report severe dizziness, weakness, or dehydration symptoms.", flags: [.severeSymptoms]),
            drug("clopidogrel", "Clopidogrel", "Plavix", .cardiovascular, "Antiplatelets", "Tablet", "75 mg", "Prevention of selected thrombotic events", "Take consistently as prescribed.", "Bruising; bleeding", "Unusual bleeding, black stools, or planned procedures require immediate pharmacist review.", "Do not stop it on your own and report unusual bleeding immediately.", flags: [.anticoagulant, .severeSymptoms])
        ]
    }

    private static func drug(
        _ seedID: String,
        _ scientific: String,
        _ trade: String,
        _ chapter: Chapter,
        _ drugClass: String,
        _ form: String,
        _ strength: String,
        _ indication: String,
        _ howToTake: String,
        _ sideEffects: String,
        _ warning: String,
        _ counseling: String,
        flags: [SafetyFlag] = []
    ) -> Drug {
        Drug(
            scientificName: scientific,
            tradeNames: [trade],
            chapter: chapter,
            drugClass: drugClass,
            dosageForms: form.components(separatedBy: " / "),
            strengths: [strength],
            indications: [indication],
            howToTake: howToTake,
            commonSideEffects: sideEffects.components(separatedBy: "; "),
            warnings: [warning],
            counselingSentence: counseling,
            timesSeen: 0,
            lastSeenDate: nil,
            safetyFlags: flags,
            starterSeedID: seedID,
            sourceNote: sourceNote,
            verificationStatus: .pendingPharmacist
        )
    }
}
