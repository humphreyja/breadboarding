class Cycle < ApplicationRecord
  belongs_to :domain
  
  validates :number, :date, presence: true
  default_scope -> { order(number: :desc)}
  
  scope :active, -> { where('date >= ?', Date.today) }
  
  def voted?(user)
    voting_data.voted.include? user.id
  end
  
  def pitches
    voting_data.pitches
  end
  
  def pitches_by_most_popular
    voting_data.pitches.sort_by {|pitch| pitch.votes.count * -1 }
  end
  
  def vote_for_pitch!(pitch_id, user)
    voting_data.vote!(pitch_id, user)
  end
  
  def remove_vote_for_pitch!(pitch_id, user)
    voting_data.remove_vote!(pitch_id, user)
  end
  
  def voting_data
    Votes.new(self, voting_data_hash || {})
  end
  
  def published?
    published_id.present?
  end
  
  def publish!
    domain.basecamp_session.push_cycle_votes!(self)
  end
  
  def fetch_pitches!
    payload = domain.basecamp_session.fetch_pitches
    voting_data.sync_pitches!(payload)
  end
end
