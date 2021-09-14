class BasecampSession < ApplicationRecord
  include Fetchable, Pushable
  belongs_to :domain
  belongs_to :user
  
  def fetch_request_token_url
    client.auth_code.authorize_url(redirect_uri: Rails.application.routes.url_helpers.basecamp_authorization_callback_url)
  end
  
  def fetch_access_token!(verifier)
    oauth_access_token = client.auth_code.get_token(verifier, redirect_uri: Rails.application.routes.url_helpers.basecamp_authorization_callback_url)
    
    save_token_details(oauth_access_token)
  end
  
  def access_token
    OAuth2::AccessToken.from_hash(
      client,
      access_token: token
    )
  end
  
  def client
    OAuth2::Client.new(
      ENV['BASECAMP_CLIENT_ID'],
      ENV['BASECAMP_SECRET'], 
      site: 'https://launchpad.37signals.com',
      authorize_url: 'https://launchpad.37signals.com/authorization/new',
      token_url: 'https://launchpad.37signals.com/authorization/token'
    )
  end
  
  def api_url
    "https://3.basecampapi.com/#{account_id}"
  end
  
  def request!(verb, url, body: nil, headers: {})
    headers.merge!({ accept: 'application/json' })
    headers.merge!({ 'Content-Type': 'application/json' }) if verb != :get
    options = { headers: headers }
    options[:body] = body.to_json if body
    access_token.request(verb, url, options)
  end
  
  private
  
    def save_token_details(oauth_access_token)
      self.token = oauth_access_token.token
      self.authenticated = true
      self.user = Current.user
      save!
    end
end
