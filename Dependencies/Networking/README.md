# Networking Package

The `Networking` package includes the following:
* An simple `RemoteResourceFetching` interface that abstracts the loading of remote resources
* A `NetworkingError` type that represents the two classes of failure that are possible when loading remote resources
* An `AppleNetworking` interface representing the data-loading interface of `Foundation.URLSession`
* A fully tested implementation of the `RemoteResourceFetching` interface in `AppleRemoteResourceFetcher`  
