extension Encodable {
    var convertData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
