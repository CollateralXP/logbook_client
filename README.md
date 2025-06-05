# LogbookClient

A Ruby SDK for the CXP LogBook service, providing a simple interface to store, search, and retrieve HTTP request/response documents for debugging and monitoring purposes.

LogbookClient allows you to:

- Store HTTP request/response pairs as searchable documents
- Retrieve documents by collection and search terms
- Organize logs with custom reference IDs and searchable metadata
- Monitor API health and connectivity

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logbook_client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install logbook_client

## Usage

### Configuration

First, configure the client with your API credentials:

```ruby
LogbookClient.configure do |config|
  config.api_url = 'https://logbook.collateralxp.com/api'
  config.api_token = 'your_api_token_here'
  config.searchable_terms_separator = '--$/#--' # optional, default value
end
```

### Creating and Storing Documents

Create a document to store HTTP request/response data:

```ruby
# Create a document with request/response data
document = LogbookClient::Document.new(
  reference_id: { integration_id: '123', log_type: 'incoming' },
  searchable_terms: { user_id: '456', action: 'payment' },
  request: {
    uri: 'https://api.example.com/payments',
    headers: { 'Content-Type' => 'application/json' },
    payload: { amount: 100, currency: 'USD' }
  },
  response: {
    code: 200,
    payload: { status: 'success', transaction_id: 'txn_789' }
  }
)

# Store the document in a collection
collection_id = 'payments-collection'
LogbookClient.put_document(collection_id, document)
```

### Searching Documents

Search for documents using various criteria:

```ruby
# Search with specific terms
search_term = 'user_id:456,action:payment'
documents = LogbookClient.get_documents(collection_id, search_term)

# Search with pagination
documents = LogbookClient.get_documents(
  collection_id,
  search_term,
  page: 2,
  per_page: 50
)

# Search all documents in a collection
all_documents = LogbookClient.get_documents(collection_id)
```

### Retrieving Specific Documents

Get a specific document by its ID:

```ruby
document_id = 'f423f069-fb4e-423e-960f-69dd11037320'
document = LogbookClient.get_document(collection_id, document_id)
```

### Health Check

Check the API connectivity:

```ruby
health_status = LogbookClient.health
# Returns: { status: 'ok', message: '...' }
```

### Helper Methods

The gem provides utility methods for working with search terms and reference IDs:

```ruby
# Convert search term string to hash
search_hash = LogbookClient.search_term_to_hash('user_id:456,action:payment')
# => { user_id: '456', action: 'payment' }

# Convert reference ID to hash
ref_hash = LogbookClient.reference_id_to_hash('user_id:456--$/#--action:payment')
# => { user_id: '456', action: 'payment' }

# Convert hash to reference ID
ref_id = LogbookClient.to_reference_id({ user_id: '456', action: 'payment' })
# => 'user_id:456--$/#--action:payment'

# Convert to searchable terms array
terms = LogbookClient.to_searchable_terms({ user_id: '456', action: 'payment' })
# => ['user_id:456', 'action:payment']
```

### Error Handling

The client raises specific errors for different scenarios:

```ruby
begin
  LogbookClient.get_documents('invalid-collection', 'search_term')
rescue LogbookClient::Api::InvalidRequestError => e
  puts "Request failed: #{e.message}"
  puts "Errors: #{e.errors}"
rescue LogbookClient::Api::InvalidSearchTermError => e
  puts "Invalid search term: #{e.message}"
rescue LogbookClient::Api::InvalidDocumentError => e
  puts "Invalid document: #{e.message}"
end
```

### Instrumentation

The client supports ActiveSupport notifications for monitoring:

```ruby
ActiveSupport::Notifications.subscribe('logbook_client') do |name, start, finish, id, payload|
  puts "LogBook API call: #{payload[:method]} #{payload[:url]} - #{finish - start}s"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/logbook_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/logbook_client/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the LogbookClient project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/logbook_client/blob/main/CODE_OF_CONDUCT.md).
