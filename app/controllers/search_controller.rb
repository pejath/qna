# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @search_query = params[:query]
    @filters = params[:filters].try(:[], :filter)&.reject(&:empty?)

    @result = ThinkingSphinx.search @search_query, classes: @filters&.map(&:constantize)
  end
end
