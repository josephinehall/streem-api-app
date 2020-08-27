# Streem API app

A Rails API for returning data from an ElasticSearch index.

## Installation

Copy `.env.example` to `.env` and fill in the application secrets.

Run `bundle install && rails s`.

Test a request with the following:

```
curl \
    -H "Authorization: Token sekret" \
    -G \
    --data-urlencode "query=scott morrison" \
    --data-urlencode "before=1567209600000" \
    --data-urlencode "after=1554037199999" \
    --data-urlencode "interval=1d" \
    http://localhost:3000/results
```

You should see a JSON response from the search index 🎉

## Design

This application consists of a route, a controller and a service object. The service object handles most of the work. I created it using the [Hanami::Interactor design](https://guides.hanamirb.org/architecture/interactors/), which I find to be a useful and lightweight method for building service objects.

The Search class has one public method, `call`. The request params are passed to it, formatted (and ideally validated - see below). I then use them to construct a search definition using the ElasticSearch Ruby DSL, specifying a boolean full-text `query_string` search within the specified timestamps, and then performing a double aggregation on the user-provided `interval` attribute, and by `medium`. The results of the search are passed back to the controller in the `@results` exposure. 

I have used this approach to move application logic out of the controller, into one dedicated class, and to make the search behaviour testable. 

Ideas for future improvement:

- Validate and coerce the request parameters with [dry_validation](https://dry-rb.org/gems/dry-validation/1.5/)
- Improve the tests

