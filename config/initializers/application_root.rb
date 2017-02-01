class ApplicationRoot

  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def uri
    URI(@url)
  end

  def domain
    uri.domain
  end

  class << self

    def laboratory
      new Rails.configuration.base_url
    end

    def classroom
      new Rails.configuration.classroom_url
    end

    def office
      new Rails.configuration.office_url
    end

    def bibliotheca
      new Rails.configuration.bibliotheca_url
    end
  end

end
