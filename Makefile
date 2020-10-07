TAG := $(shell git describe --tags)

zip:
	find src | egrep '\.(json)$$' | zip -@ pubpatterns.zip -j

release:
	gh release create ${TAG} 'pubpatterns.zip' -t 'pubpatterns ${TAG}'
