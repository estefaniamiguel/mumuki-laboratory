module WithSlug
  extend ActiveSupport::Concern

  included do
    validates_presence_of :slug
    validates_uniqueness_of :slug
  end

  def import!
    import_from_json! Mumukit::Bridge::Bibliotheca.new(Rails.configuration.bibliotheca_api_url).send(self.class.name.underscore, slug)
  end

  def to_route_params
    slug.to_mumukit_slug.to_options.merge(organization: Organization.current)
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
      find_by!(slug: Mumukit::Auth::Slug.join_s(args).to_s)
    end
  end
end
