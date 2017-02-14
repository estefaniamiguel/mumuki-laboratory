class Mumukit::Auth::Slug
  def self.any
    '_/_'.to_mumukit_slug
  end

  def to_options
    {first: first, second: second}
  end
end
