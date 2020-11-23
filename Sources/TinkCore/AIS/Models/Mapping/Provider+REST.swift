import Foundation

extension Provider {
    init(restProvider: RESTProvider) {
        self.name = .init(restProvider.name)
        self.displayName = restProvider.displayName
        self.authenticationUserType = .init(restType: restProvider.authenticationUserType)
        self.kind = .init(restType: restProvider.type)
        self.status = Status(restStatus: restProvider.status)
        self.helpText = restProvider.passwordHelpText
        self.isPopular = restProvider.popular
        self.fields = restProvider.fields.map(Field.init)
        self.groupDisplayName = restProvider.groupDisplayName ?? restProvider.displayName
        self.image = restProvider.images.flatMap { URL(string: $0.icon ?? "") }
        self.displayDescription = restProvider.displayDescription ?? ""
        self.capabilities = .init(restCapabilities: restProvider.capabilities)
        self.marketCode = restProvider.market
        self.accessType = .init(restAccessType: restProvider.accessType)
        self.credentialsKind = .init(restCredentialType: restProvider.credentialsType)
        self.financialInstitution = FinancialInstitution(
            id: .init(restProvider.financialInstitutionId),
            name: restProvider.financialInstitutionName
        )
    }
}

extension Provider.AuthenticationUserType {
    init(restType: RESTProvider.AuthenticationUserType) {
        switch restType {
        case .business:
            self = .business
        case .personal:
            self = .personal
        case .corporate:
            self = .corporate
        case .unknown:
            self = .unknown
        }
    }
}

extension Provider.Kind {
    init(restType: RESTProvider.ModelType) {
        switch restType {
        case .bank:
            self = .bank
        case .creditCard:
            self = .creditCard
        case .broker:
            self = .broker
        case .other:
            self = .other
        case .test:
            self = .test
        case .unknown:
            self = .unknown
        }
    }
}

extension Provider.Status {
    init(restStatus: RESTProvider.Status) {
        switch restStatus {
        case .enabled:
            self = .enabled
        case .disabled:
            self = .disabled
        case .temporaryDisabled:
            self = .temporaryDisabled
        case .unknown:
            self = .unknown
        }
    }
}

extension Provider.Capabilities {
    init(restCapabilities: [RESTProvider.Capabilities]) {
        self = restCapabilities.reduce([]) { capability, restCapabilitiy in
            switch restCapabilitiy {
            case .unknown:
                return capability
            case .transfers:
                return capability.union(.transfers)
            case .mortgageAggregation:
                return capability.union(.mortgageAggregation)
            case .checkingAccounts:
                return capability.union(.checkingAccounts)
            case .savingsAccounts:
                return capability.union(.savingsAccounts)
            case .creditCards:
                return capability.union(.creditCards)
            case .investments:
                return capability.union(.investments)
            case .loans:
                return capability.union(.loans)
            case .payments:
                return capability.union(.payments)
            case .identityData:
                return capability.union(.identityData)
            case .einvoices:
                return capability
            case .createBeneficiaries:
                return capability.union(.createBeneficiaries)
            case .listBeneficiaries:
                return capability.union(.listBeneficiaries)
            }
        }
    }

    var restCapabilities: [RESTProvider.Capabilities] {
        var result: [RESTProvider.Capabilities] = []
        if contains(.transfers) {
            result.append(.transfers)
        }
        if contains(.mortgageAggregation) {
            result.append(.mortgageAggregation)
        }
        if contains(.checkingAccounts) {
            result.append(.checkingAccounts)
        }
        if contains(.savingsAccounts) {
            result.append(.savingsAccounts)
        }
        if contains(.creditCards) {
            result.append(.creditCards)
        }
        if contains(.investments) {
            result.append(.investments)
        }
        if contains(.loans) {
            result.append(.loans)
        }
        if contains(.payments) {
            result.append(.payments)
        }
        if contains(.identityData) {
            result.append(.identityData)
        }
        return result
    }
}

extension Provider.AccessType {
    init(restAccessType: RESTProvider.AccessType) {
        switch restAccessType {
        case .openBanking:
            self = .openBanking
        case .other:
            self = .other
        case .unknown:
            self = .unknown
        }
    }
}

extension Provider.Field {
    init(restField: RESTField) {
        self.description = restField._description
        self.hint = restField.hint
        self.maxLength = restField.maxLength
        self.minLength = restField.minLength
        self.isMasked = restField.masked ?? false
        self.isNumeric = restField.numeric ?? false
        self.isImmutable = restField.immutable ?? false
        self.isOptional = restField._optional ?? true
        self.name = restField.name
        self.initialValue = restField.value
        self.pattern = restField.pattern
        self.patternError = restField.patternError
        self.helpText = restField.helpText
    }
}
