# frozen_string_literal: true

module LogbookClient
  class Configuration
    include ActiveModel::Model

    attr_accessor :api_token, :api_url
  end
end
