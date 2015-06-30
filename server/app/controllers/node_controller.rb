class NodeController < ApplicationController
	def index
		@nodes = Node.all
	end
end