require 'grit'
require 'fusefs'

class Grit::Blob
	def find(path)
		path == '' or path == nil or nil
	end
end

class Grit::Tree
	def find(path)
		case path
			when /^\/?$/, nil
				self
			when /^\/?([^\/]+)$/
				contents.find{|t| t.basename == $1}
			when /^\/?([^\/]+)\/(.*)$/
				contents.find{|t| t.basename == $1}.find($2)
			else
				p path
		end
	end

	def ls(path)
		find(path).contents.map(&:basename)
	end
end

class GitFS < FuseFS::FuseDir
	def initialize(repo_path)
		@repo = Grit::Repo.new(repo_path)
	end

	def contents(path)
		case path
			when '/branch'
				@repo.branches.map(&:name)
			when '/tag'
				@repo.tags.map(&:name)
			when '/'
				['branch', 'tag']
			when /^\/(branch|tag)\/([^\/]+)(\/.*)?$/
				@repo.tree($2).ls($3)
			else
				[]
		end
	end

	def directory?(path)
		case path
			when '/', '/branch', '/tag'
				true
			when /^\/branch\/([^\/]+)$/
				@repo.branches.find{|t| t.name == $1}
			when /^\/tag\/([^\/]+)$/
				@repo.tags.find{|t| t.name == $1}
			when /^\/(branch|tag)\/([^\/]+)\/(.*)/
				Grit::Tree === @repo.tree($2).find($3)
			else
				false
		end
	end

	def file?(path)
		case path
			when /^\/(branch|tag)\/([^\/]+)\/(.*)/
				p (r = @repo.tree($2)).contents.map(&:basename)
				p $3
				Grit::Blob === @repo.tree($2).find($3)
			else
				false
		end
	end

	def size(path)
		read_file(path).size
	end

	def read_file(path)
		path =~ /^\/(branch|tag)\/([^\/]+)\/(.*)/
		@repo.tree($2).find($3).data
	end
end
