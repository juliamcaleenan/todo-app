module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug
    class_attribute :slug_column
  end

  def generate_slug
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))
    obj = self.class.find_by(slug: the_slug)
    x = 2
    while obj && obj != self
      the_slug = to_slug(self.send(self.class.slug_column.to_sym)) + "-" + x.to_s
      obj = self.class.find_by(slug: the_slug)
      x += 1
    end
    self.slug = the_slug
  end

  def to_slug(name)
    name.downcase.strip.gsub(/[^\w-]/,'-').gsub(/-+/,'-')
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def sluggable_column(column_name)
      self.slug_column = column_name
    end
  end
end