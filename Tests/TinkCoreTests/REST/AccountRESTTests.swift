@testable import TinkCore
import XCTest

class AccountRESTTests: XCTestCase {
    func testAccountMapping() throws {
        let accountJSON = """
        {
            "accountNumber": "1078-646804708704",
            "availableCredit": 0.0,
            "balance": 47087.04,
            "bankId": "1078646804708704",
            "certainDate": 1586340000000,
            "credentialsId": "cf50dacd11e048bab676bd473a055973",
            "excluded": false,
            "favored": false,
            "id": "dc09299685b741d1b9320910d0b67c83",
            "name": "Savings Account tink",
            "ownership": 1.0,
            "payload": null,
            "type": "SAVINGS",
            "userId": "42091f906ffd4cccb2e6ba4afd7b5c71",
            "userModifiedExcluded": false,
            "userModifiedName": false,
            "userModifiedType": false,
            "identifiers": "[se://1078646804708704?name=testAccount]",
            "transferDestinations": [{
                "balance": 700.0,
                "displayBankName": "Nordea",
                "displayAccountNumber": "1120-700004704000",
                "uri": "se://1120700004704000?name=Checking+Account+tink",
                "images": {
                    "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                    "banner": null
                },
                "name": "Checking Account tink",
                "type": "CHECKING",
                "matchesMultiple": false
            }, {
                "balance": 0.0,
                "displayBankName": "Nordea",
                "displayAccountNumber": "1120-756005080320",
                "uri": "se://1120756005080320?name=Checking+Account+tink+zero+balance",
                "images": {
                    "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                    "banner": null
                },
                "name": "Checking Account tink zero balance",
                "type": "CHECKING",
                "matchesMultiple": false
            }, {
                "balance": 564.48,
                "displayBankName": "Nordea",
                "displayAccountNumber": "4515-564484030387",
                "uri": "se://4515564484030387?name=Checking+Account+tink+1",
                "images": {
                    "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                    "banner": null
                },
                "name": "Checking Account tink 1",
                "type": "CHECKING",
                "matchesMultiple": false
            }, {
                "uri": "se://.+",
                "matchesMultiple": true
            }, {
                "uri": "se-bg://.+",
                "matchesMultiple": true
            }, {
                "uri": "se-pg://.+",
                "matchesMultiple": true
            }],
            "details": null,
            "images": {
                "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                "banner": null
            },
            "holderName": null,
            "closed": false,
            "flags": "[]",
            "accountExclusion": "NONE",
            "currencyCode": "SEK",
            "currencyDenominatedBalance": {
                "unscaledValue": 4708704,
                "scale": 2,
                "currencyCode": "SEK"
            },
            "refreshed": 1591604583000,
            "financialInstitutionId": "f58e31ebaf625c15a9601aa4deac83d0"
        }
        """

        guard let data = accountJSON.data(using: .utf8) else {
            XCTFail("Failed to parse the JSON")
            return
        }

        let restAccount = try JSONDecoder().decode(RESTAccount.self, from: data)
        let account = Account(restAccount: restAccount)

        XCTAssertEqual(account.id.value, "dc09299685b741d1b9320910d0b67c83")
        XCTAssertEqual(account.accountNumber, "1078-646804708704")
        XCTAssertEqual(account.name, "Savings Account tink")
        XCTAssertEqual(account.credentialsID.value, "cf50dacd11e048bab676bd473a055973")
        XCTAssertEqual(account.financialInstitutionID?.value, "f58e31ebaf625c15a9601aa4deac83d0")
        XCTAssertEqual(account.balance, 47087.04)
        XCTAssertEqual(account.kind, .savings)
        XCTAssertEqual(account.ownership, 1.0)
    }

    func testAccountMappingWithNewType() throws {
        let accountJSON = """
        {
            "accountNumber": "1078-646804708704",
            "availableCredit": 0.0,
            "balance": 47087.04,
            "bankId": "1078646804708704",
            "certainDate": 1586340000000,
            "credentialsId": "cf50dacd11e048bab676bd473a055973",
            "excluded": false,
            "favored": false,
            "id": "dc09299685b741d1b9320910d0b67c83",
            "name": "Savings Account tink",
            "ownership": 1.0,
            "payload": null,
            "type": "TEST",
            "userId": "42091f906ffd4cccb2e6ba4afd7b5c71",
            "userModifiedExcluded": false,
            "userModifiedName": false,
            "userModifiedType": false,
            "identifiers": "[se://1078646804708704?name=testAccount]",
            "transferDestinations": [{
                "balance": 700.0,
                "displayBankName": "Nordea",
                "displayAccountNumber": "1120-700004704000",
                "uri": "se://1120700004704000?name=Checking+Account+tink",
                "images": {
                    "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                    "banner": null
                },
                "name": "Checking Account tink",
                "type": "CHECKING",
                "matchesMultiple": false
            }, {
                "balance": 0.0,
                "displayBankName": "Nordea",
                "displayAccountNumber": "1120-756005080320",
                "uri": "se://1120756005080320?name=Checking+Account+tink+zero+balance",
                "images": {
                    "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                    "banner": null
                },
                "name": "Checking Account tink zero balance",
                "type": "CHECKING",
                "matchesMultiple": false
            }, {
                "balance": 564.48,
                "displayBankName": "Nordea",
                "displayAccountNumber": "4515-564484030387",
                "uri": "se://4515564484030387?name=Checking+Account+tink+1",
                "images": {
                    "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                    "banner": null
                },
                "name": "Checking Account tink 1",
                "type": "CHECKING",
                "matchesMultiple": false
            }, {
                "uri": "se://.+",
                "matchesMultiple": true
            }, {
                "uri": "se-bg://.+",
                "matchesMultiple": true
            }, {
                "uri": "se-pg://.+",
                "matchesMultiple": true
            }],
            "details": null,
            "images": {
                "icon": "https://cdn.tink.se/provider-images/placeholder.png",
                "banner": null
            },
            "holderName": null,
            "closed": false,
            "flags": "[]",
            "accountExclusion": "NONE",
            "currencyCode": "SEK",
            "currencyDenominatedBalance": {
                "unscaledValue": 4708704,
                "scale": 2,
                "currencyCode": "SEK"
            },
            "refreshed": 1591604583000,
            "financialInstitutionId": "f58e31ebaf625c15a9601aa4deac83d0"
        }
        """

        guard let data = accountJSON.data(using: .utf8) else {
            XCTFail("Failed to parse the JSON")
            return
        }

        let restAccount = try JSONDecoder().decode(RESTAccount.self, from: data)
        let account = Account(restAccount: restAccount)

        XCTAssertEqual(account.kind, .unknown)
    }

    func testAccountModelMapping() {
        let restTransferDestination = RESTTransferDestination(
            balance: 0.0,
            displayBankName: nil,
            displayAccountNumber: "FR30 2004 1010 0500 0263 0303 700",
            uri: "iban://FR3020041010050002630303700?name=Checking+Account+tink+zero+balance",
            name: "Checking Account tink zero balance",
            type: .checking,
            matchesMultiple: false
        )
        let restCurrencyDenominatedAmount = RESTCurrencyDenominatedAmount(
            unscaledValue: 6861,
            scale: 2,
            currencyCode: "EUR"
        )

        let restAccount = RESTAccount(
            accountNumber: "FR1420041010050015664355590",
            balance: 68.61,
            credentialsId: "8a9255f210874f3eb5aefd78d412f6fa",
            excluded: false,
            favored: true,
            id: "f7c4038dfb6f46109ecba4a6f079a418",
            name: "Checking Account tink 1",
            ownership: 1.0,
            type: .checking,
            identifiers: "[\"iban://FR1420041010050015664355590?name=testAccount\"]",
            transferDestinations: [restTransferDestination],
            details: nil,
            holderName: nil,
            closed: false,
            flags: "[]",
            accountExclusion: ._none,
            currencyDenominatedBalance: restCurrencyDenominatedAmount,
            refreshed: Date(),
            financialInstitutionId: "f58e31ebaf625c15a9601aa4deac83d0"
        )

        let account = Account(restAccount: restAccount)
        XCTAssertEqual(account.credentialsID.value, restAccount.credentialsId)
        XCTAssertEqual(account.id.value, restAccount.id)
        XCTAssertEqual(account.financialInstitutionID?.value, restAccount.financialInstitutionId)
        XCTAssertEqual(account.name, restAccount.name)
        XCTAssertEqual(account.accountNumber, restAccount.accountNumber)
        XCTAssertEqual(account.name, restAccount.name)
        XCTAssertEqual(account.kind, Account.Kind(restAccountType: restAccount.type))
        XCTAssertNil(account.details)
    }

}
