pubpatterns
===========

[![Ruby](https://github.com/sckott/pubpatterns/workflows/Ruby/badge.svg)](https://github.com/sckott/pubpatterns/actions?query=workflow%3ARuby)

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

## Example patterns

* Instituto de Investigaciones Filologicas (<spec/iif.json>): can get full URL from Crossref metadata, but need to replace `/view/` with `/download/` - requires a HTTP request to Crossref API, then a regex sub
* ... more to come

## Test suite

Tests are in [test/](test/) - will be run on Travis-CI on each change in this repo.

Tests are meant to make sure that URLs actually work. Failures will quickly
let us know we need to fix something.

## Contribute

Please do contribute! Fork, make a feature branch, add a `.json` file in `src/`,
add a test in `test/`, send a pull request to this repo. Thanks!
