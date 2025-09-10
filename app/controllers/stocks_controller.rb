class StocksController < ApplicationController
  before_action :authenticate_user!
  before_action :stock_belongs_to_current_user?, only: %i[ index show new create edit update destroy ]
  before_action :set_stock, only: %i[ show edit update destroy ]

  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.where(user_id: current_user.id)
    @stock_summary = calculate_stock_summary
    @stocks_with_details = calculate_stocks_details(@stocks)
  end

  # GET /stocks/1 or /stocks/1.json
  def show
    # Sort products: first ones without out_price, then by out_price ascending
    @products = @stock.products.order(Arel.sql('CASE WHEN out_price IS NULL THEN 0 ELSE 1 END, out_price ASC'))
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
    @stock.user = current_user
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks or /stocks.json
  def create
    @stock = Stock.new(stock_params)
    @stock.user = current_user

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stocks_path, notice: 'Stock was successfully created.' } # rubocop:disable Rails/I18nLocaleTexts
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to stocks_path, notice: 'Stock was successfully updated.', status: :see_other } # rubocop:disable Rails/I18nLocaleTexts
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy!

    respond_to do |format|
      format.html { redirect_to stocks_path, notice: 'Stock was successfully destroyed.', status: :see_other } # rubocop:disable Rails/I18nLocaleTexts
      format.json { head :no_content }
    end
  end

  private
    # Calculate financial details for each stock
    def calculate_stocks_details(stocks)
      stocks.map do |stock|
        details = {}
        details[:stock] = stock
        details[:total_p] = 0
        details[:total_s] = 0
        details[:total_products] = stock.products.count
        details[:products_with_out_price] = 0

        stock.products.each do |product|
          details[:total_p] += product.in_price if product.in_price.present?
          if product.out_price.present?
            details[:total_s] += product.out_price
            details[:products_with_out_price] += 1
          end
        end

        details[:profit] = details[:total_s] - details[:total_p]
        details
      end
    end

    # Calculate summary of all stocks
    def calculate_stock_summary
      summary = {
        total_in_price: 0,
        total_out_price: 0,
        total_products_count: 0,
        total_sold_products_count: 0
      }

      @stocks.each do |stock|
        stock.products.each do |product|
          summary[:total_products_count] += 1
          summary[:total_in_price] += product.in_price if product.in_price.present?

          if product.out_price.present?
            summary[:total_out_price] += product.out_price
            summary[:total_sold_products_count] += 1
          end
        end
      end

      summary[:total_profit] = summary[:total_out_price] - summary[:total_in_price]
      summary
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      begin
        @stock = Stock.where(user_id: current_user.id).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to root_path, alert: "You don't have access to this stock" # rubocop:disable Rails/I18nLocaleTexts
      end
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.expect(stock: [ :description, :stock_date ])
    end

    def stock_belongs_to_current_user?
      stock_id = params[:id]
      return true if action_name == 'index' || action_name == 'new' || action_name == 'create'
      return true if stock_id.blank?

      # If the stock doesn't belong to current user, redirect to root
      unless Stock.exists?(id: stock_id, user_id: current_user.id)
        redirect_to root_path, alert: "You don't have access to this stock" # rubocop:disable Rails/I18nLocaleTexts
        return false
      end

      true
    end
end
