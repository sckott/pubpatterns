pubpatterns
===========

[![Build Status](https://travis-ci.org/ropenscilabs/pubpatterns.svg?branch=master)](https://travis-ci.org/ropenscilabs/pubpatterns)

Use publisher URL patterns to generate full text links to scholarly articles.

These could be used in a variety of ways:

* If you're interested in a particular publisher, or a journal within a publisher, navigate directly to it.
* If start with a DOI, then match on DOI prefix to the publisher

## Spec

[spec.json](spec.json)

## Example

[example.json](example.json)

## Patterns

All `.json` files are in the [src/](src/) directory.

## Test suite

Tests are in [test/](test/) - will be run on Travis-CI on each change in this repo.

Tests are meant to make sure that URLs actually work. Failures will quickly
let us know we need to fix something.

## Contribute

Please do contribute! Fork, make a feature branch, add a `.json` file in `src/`,
add a test in `test/`, send a pull request to this repo. Thanks!

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
