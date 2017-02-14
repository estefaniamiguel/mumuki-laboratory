#TODO may use mumukit slug
module WithSlug
  extend ActiveSupport::Concern

  included do
    validates_presence_of :slug
    validates_uniqueness_of :slug
  end

  def import!
    import_from_json! Mumukit::Bridge::Bibliotheca.new(Rails.configuration.bibliotheca_api_url).send(self.class.name.underscore, slug)
  end

  def slug_parts
    org, repo = slug.split('/')
    {organization: org, repository: repo}
  end

  module ClassMethods
    def import!(slug)
      transaction do
        item = find_or_initialize_by(slug: slug)
        item.save(validate: false)
        item.import!
      end
    end

    def by_slug_parts!(args)
      find_by!(slug: Mumukit::Auth::Slug.from_options(args).to_s)
    end
  end
end
