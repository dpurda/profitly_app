class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    year  = params[:year].to_i
    month = params[:month].to_i
    return unless year > 0 && month.between?(1, 12)

    @selected_month = Date.new(year, month, 1)
    period = @selected_month.beginning_of_month.beginning_of_day..@selected_month.end_of_month.end_of_day

    @sold_products = Product.joins(:stock)
                            .where(stocks: { user_id: current_user.id })
                            .where.not(out_price: nil)
                            .where(updated_at: period)
                            .where(exclude_from_stats: false)
                            .includes(:stock)
                            .order(updated_at: :desc)

    @revenue = @sold_products.sum(:out_price)
    @paid    = @sold_products.sum(:in_price)
    @profit  = @revenue - @paid
  end
end
