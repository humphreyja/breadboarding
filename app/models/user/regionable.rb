module User::Regionable
  extend ActiveSupport::Concern

  included do
    attr_writer :time_zone
  end
  
  def time_zone
    @time_zone ||= Time.zone
  end
end