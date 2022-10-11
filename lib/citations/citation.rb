# frozen_string_literal: true

class Citation
  class << self
    def set_root
      fragments = caller[0].split(%r{/})
      @root = fragments[0, fragments.size - 1].join('/')
    end

    def create(name, links)
      @encyclopedia ||= {}
      @encyclopedia[name.to_sym] ||= {}
      @encyclopedia[name.to_sym][:links] = links
      @encyclopedia[name.to_sym][:references] = []
    end

    def add(name)
      puts @root
      full_path = caller[0]
      puts full_path
      relative_path = full_path.sub(@root, '').gsub(/['`]/, '')
      @encyclopedia[name.to_sym][:references] = @encyclopedia[name.to_sym][:references] + [relative_path]
    end

    attr_reader :encyclopedia, :root
  end
end
