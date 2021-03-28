module Authenticated
  include AuthenticationManagement
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end
end
