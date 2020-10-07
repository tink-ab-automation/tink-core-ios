import Foundation

/// The credentials model represents users connected providers from where financial data is accessed.
public struct Credentials: Identifiable {
    /// A unique identifier of a `Credentials`.
    public typealias ID = Identifier<Credentials>

    /// The unique identifier of the credentials.
    public let id: ID

    /// The provider (financial institution) that the credentials is connected to.
    public let providerID: Provider.ID

    /// Indicates how Tink authenticates the user to a financial institution.
    public enum Kind {
        /// An unknown kind of credentials.
        case unknown

        /// The user will authenticate the credentials with a password.
        case password

        /// The user will authenticate the credentials with Mobile BankID.
        case mobileBankID

        /// The user will authenticate the credentials with a Key Fob.
        case keyfob

        /// Fraud
        case fraud

        /// The user will authenticate the credentials with a third party app.
        case thirdPartyAuthentication

        public var sortOrder: Int {
            switch self {
            case .mobileBankID:
                return 1
            case .password:
                return 2
            case .thirdPartyAuthentication:
                return 3
            case .keyfob:
                return 4
            case .fraud:
                return 5
            case .unknown:
                return 6
            }
        }
    }

    /// Indicates how Tink authenticates the user to the financial institution.
    public let kind: Credentials.Kind

    /// The status indicates the state of a credentials.
    public enum Status {
        /// An unknown credentials status.
        case unknown

        /// The credentials was just created.
        case created

        /// The credentials is in the process of authenticating.
        case authenticating

        /// The credentials is done authenticating and is updating accounts and transactions.
        case updating

        /// The credentials has finished authenticating and updating accounts and transactions.
        case updated

        /// There was a temporary error, see `statusPayload` for text describing the error.
        case temporaryError

        /// There was an authentication error, see `statusPayload` for text describing the error.
        case authenticationError

        /// There was a permanent error, see `statusPayload` for text describing the error.
        case permanentError

        /// The credentials is awaiting authentication with Mobile BankID.
        /// - Note: Will be deprecated and replaced with `awaitingThirdPartyAppAuthentication`
        case awaitingMobileBankIDAuthentication

        /// The credentials is awaiting supplemental information.
        ///
        /// If the authentication flow requires multiple steps with input from the user, as for example a SMS OTP authentication flow,
        /// the client should expect the `awaitingSupplementalInformation` status on the credential.
        ///
        /// Create a `Form` with this credentials to let the user supplement the required information.
        case awaitingSupplementalInformation

        /// The credentials has been disabled.
        case disabled

        /// The credentials is awaiting authentication with a third party app.
        ///
        /// If a provider is using third party services in their authentication flow, the client
        /// should expect the `awaitingThirdPartyAppAuthentication` status on the credentials.
        /// In order for the aggregation of data to be successful, the system expects the third
        /// party authentication flow to be successful as well.
        ///
        /// To handle this status, check `thirdPartyAppAuthentication` to get a deeplink url to the third party app and open it so the user can authenticate.
        /// If the app can't open the deeplink, ask the user to to download or upgrade the app from the AppStore.
        case awaitingThirdPartyAppAuthentication

        /// The credentials' session has expired, check `sessionExpiryDate` to see when it expired.
        case sessionExpired
    }

    /// The status indicates the state of a credentials. For some states there are actions which need to be performed on the credentials.
    public let status: Status

    /// A user-friendly message connected to the status. Could be an error message or text describing what is currently going on in the refresh process.
    public let statusPayload: String

    /// A timestamp of when the credentials' status was last modified.
    public let statusUpdated: Date?

    /// A timestamp of when the credentials was the last time in status `.updated`.
    public let updated: Date?

    /// This is a key-value map of Field name and value found on the Provider to which the credentials belongs to.
    public let fields: [String: String]

    /// A key-value structure to handle if status of credentials are `Credential.Status.awaitingSupplementalInformation`.
    public let supplementalInformationFields: [Provider.FieldSpecification]

    /// Information about the third party authentication app.
    ///
    /// The ThirdPartyAppAuthentication contains specific deeplink urls and configuration for the third party app.
    public struct ThirdPartyAppAuthentication {
        /// Title of the app to be downloaded.
        public let downloadTitle: String?

        /// Detailed message about app to be downloaded.
        public let downloadMessage: String?

        /// Title of the app to be upgraded.
        public let upgradeTitle: String?

        /// Detailed message about app to be upgraded.
        public let upgradeMessage: String?

        /// URL to AppStore where the app can be downloaded on iOS.
        public let appStoreURL: URL?

        /// Base scheme of the app on iOS.
        public let scheme: String?

        /// URL that the app should open on iOS. Can be of another scheme than app scheme.
        public let deepLinkURL: URL?

        /// A Boolean value indicating if the deeplink URL has an autostart token.
        public var hasAutoStartToken: Bool {
            deepLinkURL?.query?.contains("autostartToken") ?? false
        }

        /// Creates a ThirdPartyAppAuthentication model.
        /// - Parameters:
        ///   - downloadTitle: Title of the app to be downloaded.
        ///   - downloadMessage: Detailed message about app to be downloaded.
        ///   - upgradeTitle: Title of the app to be upgraded.
        ///   - upgradeMessage: Detailed message about app to be upgraded.
        ///   - appStoreURL: URL to AppStore where the app can be downloaded on iOS.
        ///   - scheme: Base scheme of the app on iOS.
        ///   - deepLinkURL: URL that the app should open on iOS. Can be of another scheme than app scheme.
        public init(
            downloadTitle: String?,
            downloadMessage: String?,
            upgradeTitle: String?,
            upgradeMessage: String?,
            appStoreURL: URL?,
            scheme: String?,
            deepLinkURL: URL?
        ) {
            self.downloadTitle = downloadTitle
            self.downloadMessage = downloadMessage
            self.upgradeTitle = upgradeTitle
            self.upgradeMessage = upgradeMessage
            self.appStoreURL = appStoreURL
            self.scheme = scheme
            self.deepLinkURL = deepLinkURL
        }
    }

    /// Information about the third party authentication flow.
    public let thirdPartyAppAuthentication: ThirdPartyAppAuthentication?

    /// Indicates when the session of credentials with access type `Provider.AccessType.openBanking` will expire. After this date automatic refreshes will not be possible without new authentication from the user.
    public let sessionExpiryDate: Date?

    /// Creates a credentials model.
    /// - Parameters:
    ///   - id: The unique identifier of the credentials.
    ///   - providerID: The provider (financial institution) that the credentials is connected to.
    ///   - kind: Indicates how Tink authenticates the user to the financial institution.
    ///   - status: The status indicates the state of a credentials. For some states there are actions which need to be performed on the credentials.
    ///   - statusPayload: A user-friendly message connected to the status. Could be an error message or text describing what is currently going on in the refresh process.
    ///   - statusUpdated: A timestamp of when the credentials' status was last modified.
    ///   - updated: A timestamp of when the credentials was the last time in status `.updated`.
    ///   - fields: This is a key-value map of Field name and value found on the Provider to which the credentials belongs to.
    ///   - supplementalInformationFields: A key-value structure to handle if status of credentials are `Credential.Status.awaitingSupplementalInformation`.
    ///   - thirdPartyAppAuthentication: Information about the third party authentication flow.
    ///   - sessionExpiryDate: Indicates when the session of credentials with access type `Provider.AccessType.openBanking` will expire. After this date automatic refreshes will not be possible without new authentication from the user.
    public init(
        id: Credentials.ID,
        providerID: Provider.ID,
        kind: Credentials.Kind,
        status: Credentials.Status,
        statusPayload: String,
        statusUpdated: Date?,
        updated: Date?,
        fields: [String: String],
        supplementalInformationFields: [Provider.FieldSpecification],
        thirdPartyAppAuthentication: Credentials.ThirdPartyAppAuthentication?,
        sessionExpiryDate: Date?
    ) {
        self.id = id
        self.providerID = providerID
        self.kind = kind
        self.status = status
        self.statusPayload = statusPayload
        self.statusUpdated = statusUpdated
        self.updated = updated
        self.fields = fields
        self.supplementalInformationFields = supplementalInformationFields
        self.thirdPartyAppAuthentication = thirdPartyAppAuthentication
        self.sessionExpiryDate = sessionExpiryDate
    }
}
