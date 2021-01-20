struct RESTTransactionsResult: Decodable {
    var transaction: RESTTransaction?

    enum ResultType: String, Decodable {
        case statement = "STATEMENT"
        case transaction = "TRANSACTION"
        case category = "CATEGORY"
        case budget = "BUDGET"
        case goal = "GOAL"
        case suggestion = "SUGGESTION"
        case unknown

        static var decodeFallbackValue: ResultType = .unknown
    }

    var type: ResultType
}
