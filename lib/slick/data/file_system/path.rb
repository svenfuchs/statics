module Slick::Data::FileSystem
  class Path
    attr_accessor :path, :attributes

    def initialize(path)
      @path = path
    end

    def read
      { :title => title_from_path, :created_at => ctime, :updated_at => mtime }
    end

    def file?
      File.file?(path)
    end

    def directory?
      File.directory?(directory)
    end

    def directory
      file? ? path.gsub(File.extname(path), '') : path
    end

    def file?
      File.file?(path)
    end

    def basename
      File.basename(path)
    end

    def extname
      File.extname(path)
    end

    def ctime
      File.ctime(path)
    end

    def mtime
      File.mtime(path)
    end
  end
end
