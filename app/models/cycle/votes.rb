class Cycle::Votes
  attr_reader :voted, :pitches
  def initialize(cycle, votes_hash)
    @cycle = cycle
    @voted = votes_hash['voted'] || [] # [user_id]
    @pitches = (votes_hash['pitches'] || []).map { |pitch_hash| ::Cycle::Pitch.new(pitch_hash) }
  end
  
  def vote!(pitch_id, user)
    unless voted.include? user.id
      voted << user.id
    end
    
    @pitches = @pitches.map do |pitch|
      if pitch.id == pitch_id
        pitch.vote(user.id)
      else
        pitch
      end
    end
    
    save!
  end
  
  def remove_vote!(pitch_id, user)    
    @pitches = @pitches.map do |pitch|
      if pitch.id == pitch_id
        pitch.remove_vote(user.id)
      else
        pitch
      end
    end
    
    save!
  end
  
  def sync_pitches!(pitches_api_payload)
    @pitches = pitches_api_payload.map do |pitch_api_payload|
      pitch = @pitches.find { |pitch| pitch.id == pitch_api_payload['id'] }
      pitch ||= ::Cycle::Pitch.new_from_api(pitch_api_payload)
      pitch
    end
    
    save!
  end
  
  def save!
    payload = {
      'voted' => @voted,
      'pitches' => @pitches.map { |pitch| pitch.to_hash }
    }
    
    @cycle.voting_data_hash = payload
    @cycle.save!
  end
end