module BasecampSession::Fetchable
  def fetch_pitches
    url = "#{api_url}/buckets/#{pitch_project_id}/message_boards/#{pitch_deck_id}/messages.json?category_id=#{pitch_category_id}"
    response = request!(:get, url)
    # response = MockResponse.new
    JSON.parse(response.body)
  end
  
  
  class MockResponse
    def body
      [
        {
          "id" => 90071992547416425,
          "status" => "active",
          "type" => "Message",
          "url" => "https://3.basecampapi.com/195539477/buckets/2085958498/messages/9007199254741622.json",
          "app_url" => "https://3.basecamp.com/195539477/buckets/2085958498/messages/9007199254741622",
          "comments_count" => 1,
          "comments_url" => "https://3.basecampapi.com/195539477/buckets/2085958498/recordings/9007199254741622/comments.json",
          "content" => "Users really could use this and it would cut down on our support tickets",
          "bookmark_url" => "https://3.basecampapi.com/195539477/my/bookmarks/BAh7CEkiCGdpZAY6BkVUSSI0Z2lkOi8vYmMzL1JlY29yZGluZy85MDA3MTk5MjU0NzQxNjIyP2V4cGlyZXNfaW4GOwBUSSIMcHVycG9zZQY7AFRJIg1yZWFkYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--422f61efafb9879901eef751ef7ef4822741fea9.json",
          "subscription_url" => "https://3.basecampapi.com/195539477/buckets/2085958498/recordings/9007199254741622/subscription.json",
          "subject" => "Add User Management to Settings page"
        },
        {
          "id" => 9007199254748283,
          "status" => "active",
          "type" => "Message",
          "url" => "https://3.basecampapi.com/195539477/buckets/2085958498/messages/9007199254741622.json",
          "app_url" => "https://3.basecamp.com/195539477/buckets/2085958498/messages/9007199254741622",
          "comments_count" => 1,
          "comments_url" => "https://3.basecampapi.com/195539477/buckets/2085958498/recordings/9007199254741622/comments.json",
          "content" => "Something about metrics",
          "bookmark_url" => "https://3.basecampapi.com/195539477/my/bookmarks/BAh7CEkiCGdpZAY6BkVUSSI0Z2lkOi8vYmMzL1JlY29yZGluZy85MDA3MTk5MjU0NzQxNjIyP2V4cGlyZXNfaW4GOwBUSSIMcHVycG9zZQY7AFRJIg1yZWFkYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--422f61efafb9879901eef751ef7ef4822741fea9.json",
          "subscription_url" => "https://3.basecampapi.com/195539477/buckets/2085958498/recordings/9007199254741622/subscription.json",
          "subject" => "Include Activity Metrics on Projects"
        },
        {
          "id" => 9007199250281873,
          "status" => "active",
          "type" => "Message",
          "url" => "https://3.basecampapi.com/195539477/buckets/2085958498/messages/9007199254741622.json",
          "app_url" => "https://3.basecamp.com/195539477/buckets/2085958498/messages/9007199254741622",
          "comments_count" => 1,
          "comments_url" => "https://3.basecampapi.com/195539477/buckets/2085958498/recordings/9007199254741622/comments.json",
          "content" => "Users would like to invite others to view their account",
          "bookmark_url" => "https://3.basecampapi.com/195539477/my/bookmarks/BAh7CEkiCGdpZAY6BkVUSSI0Z2lkOi8vYmMzL1JlY29yZGluZy85MDA3MTk5MjU0NzQxNjIyP2V4cGlyZXNfaW4GOwBUSSIMcHVycG9zZQY7AFRJIg1yZWFkYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--422f61efafb9879901eef751ef7ef4822741fea9.json",
          "subscription_url" => "https://3.basecampapi.com/195539477/buckets/2085958498/recordings/9007199254741622/subscription.json",
          "subject" => "Multi User Support"
        }
      ].to_json
    end
  end
end