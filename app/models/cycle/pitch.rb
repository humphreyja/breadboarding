class Cycle::Pitch
  include ActiveModel::Model
  attr_reader :id, :title, :body, :link, :votes
  def initialize(pitch_hash)
    @id = pitch_hash['id']
    @title = pitch_hash['title']
    @body = pitch_hash['body']
    @link = pitch_hash['link']
    @votes = pitch_hash['votes'] # [user_id]
  end
  
  def vote(user_id)
    return self if @votes.include? user_id
    
    @votes << user_id
    
    self
  end
  
  def voted?(user_id)
    @votes.include? user_id
  end
  
  def remove_vote(user_id)
    return self unless @votes.include? user_id
    
    @votes.delete(user_id)
    
    self
  end
  
  def self.new_from_api(pitch_api_payload)
    pitch_hash = {
      'id' => pitch_api_payload['id'],
      'title' => pitch_api_payload['subject'],
      'body' => pitch_api_payload['content'],
      'link' => pitch_api_payload['app_url'],
      'votes' => []
    }
    new(pitch_hash)
  end
  
  def to_hash
    {
      'id' => @id,
      'title' => @title,
      'body' => @body,
      'link' => @link,
      'votes' => @votes
    }
  end
  
  def to_basecamp_content
    """
    <li>
      #{@votes.count} - <strong><a href='#{@link}' target='_blank'>#{@title}</a></strong>
    </li>
    """
  end
end