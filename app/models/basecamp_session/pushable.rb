module BasecampSession::Pushable
  def push_cycle_votes!(cycle)      
    content = """
      <ol>
        #{cycle.pitches_by_most_popular.map(&:to_basecamp_content).join('')}
      </ol>
    """
    
    payload = {
      subject: "Cycle #{cycle.number} Results",
      content: content,
      status: :active
    }
    
    publish_action = :post
    url = "#{api_url}/buckets/#{pitch_project_id}/message_boards/#{pitch_deck_id}/messages.json"
    if cycle.published?
      publish_action = :put
      url = "#{api_url}/buckets/#{pitch_project_id}/messages/#{cycle.published_id}.json"
    end

    response = request!(publish_action, url, body: payload)
    
    cycle.published_id = JSON.parse(response.body)['id']
    cycle.save!
    
  rescue OAuth2::Error => e
    if e.response.status == 404
      cycle.published_id = nil
      cycle.save!
      
      push_cycle_votes!(cycle)
    end
  end
end