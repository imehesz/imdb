require File.join(File.dirname(__FILE__), %w(.. spec_helper))

describe Imdb do
  describe "constants" do
    it "should have an imdb movie base url" do
      Imdb::IMDB_MOVIE_BASE_URL.should eql("http://www.imdb.com/title/")
    end
    it "should have an imdb search base url" do
      Imdb::IMDB_SEARCH_BASE_URL.should eql("http://imdb.com/find?s=all&q=")
    end
  end

  describe ".find_movie_by_name" do
    before do
      @name = "The Godfather"
      @html = "<html></html>"
      @doc = Hpricot(@html)
      FakeWeb.register_uri('http://imdb.com/find?s=all&q=ratatouille', :file => site_file('search.ratatouille.html'))
      FakeWeb.register_uri('http://imdb.com/find?s=all&q=the%20godfather', :file => site_file('search.the_godfather.html'))
    end

    it "uses #search_url_for when making a search request" do
      url = 'url'
      Imdb.should_receive(:query_url).with(@name).and_return(url)
      Imdb.should_receive(:open).with(url).and_return(@html)
      Imdb.find_movie_by_name(@name)
    end

    it "parses the search result with Hpricot" do
      Imdb.stub!(:open => @html)
      Imdb.should_receive(:Hpricot).with(@html).and_return(@doc)
      Imdb.find_movie_by_name(@name)
    end

    it "URI escapes the generated url including the search term" do
      url = 'http://imdb.com/find?s=all&q=the godfather'
      URI.should_receive(:escape).with(url).and_return('name')
      Imdb.send(:query_url, @name)
    end

    describe "when movies exist" do
      it "creates a new search result with a name and url" do
        Imdb::SearchResult.should_receive(:new).with("Ratatouille (2007)", 'http://imdb.com/title/tt0382932/')
        Imdb.find_movie_by_name("Ratatouille")
      end

      it "creates two new search results" do
        Imdb::SearchResult.should_receive(:new).at_least(2).times
        Imdb.find_movie_by_name("The Godfather")
      end
    end
  end
end
