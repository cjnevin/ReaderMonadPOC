// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



import Core


extension WorldError {
    public enum prism {
        public static let database = Prism<WorldError, FileIOError>(
            preview: { if case .database(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .database(x1) })
        public static let disk = Prism<WorldError, FileIOError>(
            preview: { if case .disk(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .disk(x1) })
        public static let download = Prism<WorldError, DownloadError>(
            preview: { if case .download(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .download(x1) })
    }
}

public extension Prism where Part == WorldError {
	var database: Prism<Whole, FileIOError> {
		return self • WorldError.prism.database
	}
	var disk: Prism<Whole, FileIOError> {
		return self • WorldError.prism.disk
	}
	var download: Prism<Whole, DownloadError> {
		return self • WorldError.prism.download
	}
}

