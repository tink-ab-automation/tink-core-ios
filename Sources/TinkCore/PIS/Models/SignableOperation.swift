import Foundation

/// SignableOperation object with the status of the transfer.
public struct SignableOperation {
    /// A unique identifier of a `SignableOperation`.
    public typealias ID = Identifier<SignableOperation>

    public enum Status {
        case awaitingCredentials
        case awaitingThirdPartyAppAuthentication
        case created
        case executing
        case executed
        case failed
        case cancelled
        case unknown
    }

    public enum Kind {
        case transfer
    }

    /// The timestamp of the creation of the operation.
    public let created: Date?
    /// The ID of the Credentials used to make the operation.
    public let credentialsID: Credentials.ID?
    /// The unique identifier of this operation.
    public let id: ID?
    /// The transfer status. The value of this field changes during payment initiation according to `/resources/payments/payment-status-transitions`
    public let status: Status
    /// A message with additional information regarding the current status of the transfer.
    public let statusMessage: String?
    /// The type of operation.
    public let kind: Kind
    /// The ID of the actual transfer.
    public let transferID: Transfer.ID?
    /// The timestamp of the last update of the operation.
    public let updated: Date?
    /// The ID of the user making the operation.
    let userID: User.ID?
}
