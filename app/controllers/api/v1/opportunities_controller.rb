class Api::V1::OpportunitiesController < ApplicationController

    def index
        limit = params.fetch(:limit, 20).to_i
        limit = [[limit, 1].max, 100].min

        scope = current_or_demo_user
            .opportunities
            .includes(:company)
            .order(id: :desc)
        
        if params[:cursor].present?
            scope = scope.where("id < ?", params[:cursor].to_i)
        end

        rows = scope.limit(limit + 1).to_a
        has_more = rows.length > limit
        data = has_more ? rows.first(limit) : rows
        next_cursor = has_more ? data.last.id : nil 
        
        render json: {
            data: data,
            meta: {
                limit: limit, 
                has_more: has_more,
                next_cursor: next_cursor
            }
        }
    end
end