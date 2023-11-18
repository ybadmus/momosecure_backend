# frozen_string_literal: true

module Pagination
  def optional_paginate(collection)
    return collection if params[:page].blank?

    if collection.instance_of?(Array)
      return Kaminari.paginate_array(collection).page(params[:page]) if params[:limit].blank?

      Kaminari.paginate_array(collection).page(params[:page]).per(params[:limit])
    else
      return collection.page(params[:page]) if params[:limit].blank?

      collection.page(params[:page]).per(params[:limit])
    end
  end

  protected

  def pagination(object)
    pagination_object = {
      current_page: object.try(:current_page) || 1,
      next_page: object.try(:next_page),
      previous_page: object.try(:prev_page),
      limit_per_page: object.try(:limit_value)
    }

    unless object.is_a?(Kaminari::PaginatableWithoutCount)
      pagination_object[:total_pages] = object.try(:total_pages) || 1
      pagination_object[:total_entries] = object.try(:total_count) || object.count
    end

    pagination_object
  end
end
