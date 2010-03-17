module Slick::Builder
  class Blog < Section
    def build
      super
      build_contents
    end

    protected

      def build_contents
        section.contents.each do |content|
          data.merge!(:content => content)
          render("#{section.type}/show", "#{content.permalink}.html")
        end
      end
  end
end

