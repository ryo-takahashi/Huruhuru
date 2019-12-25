extension String {
    var removedSpacing: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
