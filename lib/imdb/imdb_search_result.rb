class Imdb
  class SearchResult
    attr_reader :name, :url, :id

    def initialize(name, url)
      @name = name
      @url = url
      @id = url.split("/").last
    end
  end
end
