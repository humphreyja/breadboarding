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
    
    publish_action_endpoint = ''
    publish_action = :post
    if cycle.published?
      publish_action_endpoint = "/#{cycle.published_id}"
      publish_action = :put
    end
    
    url = "#{api_url}/buckets/#{pitch_project_id}/message_boards/#{pitch_deck_id}/messages#{publish_action_endpoint}.json"
    response = request!(publish_action, url, body: payload)
    
    cycle.published_id = JSON.parse(response.body)['id']
    cycle.save!
  end
end