class YoutubeService
  def video_info(id)
    params = { part: 'snippet,contentDetails,statistics',
               id: id }

    get_json('youtube/v3/videos', params)
  end

  def playlist_info(id, pageToken = nil)
    params = { part: 'contentDetails, snippet',
               maxResults: 50,
               pageToken: pageToken,
               playlistId: id }
    get_json('youtube/v3/playlistItems', params)
  end

  def next_page(id, response)
    playlist_info(id, response[:nextPageToken])
  end

  private

  def get_json(url, params)
    response = conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://www.googleapis.com') do |f|
      f.adapter Faraday.default_adapter
      f.params[:key] = ENV['YOUTUBE_API_KEY']
    end
  end
end
