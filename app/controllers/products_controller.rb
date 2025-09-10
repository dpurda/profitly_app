class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_stock_ownership, only: %i[ show new create edit update destroy ]
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.stock_id = params[:stock_id] if params[:stock_id]
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        if @product.stock_id.present?
          format.html { redirect_to stock_path(@product.stock), notice: 'Product was successfully created.' } # rubocop:disable Rails/I18nLocaleTexts
        else
          format.html { redirect_to @product, notice: 'Product was successfully created.' } # rubocop:disable Rails/I18nLocaleTexts
        end
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    # Check if trying to update stock_id to a stock not owned by current user
    if product_params[:stock_id].present? && !stock_belongs_to_current_user?(product_params[:stock_id])
      redirect_to stocks_path, alert: "You don't have permission to move products to this stock." # rubocop:disable Rails/I18nLocaleTexts
      return
    end

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to stock_path(@product.stock), notice: 'Product was successfully updated.' } # rubocop:disable Rails/I18nLocaleTexts
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to stock_path(@product.stock), notice: 'Product was successfully destroyed.' } # rubocop:disable Rails/I18nLocaleTexts
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.joins(:stock).where(stocks: { user_id: current_user.id }).find_by(id: params[:id])
      if @product.nil?
        redirect_to stocks_path, alert: "You don't have permission to access this product." # rubocop:disable Rails/I18nLocaleTexts
        nil
      end
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :description, :in_price, :out_price, :size, :prod_code, :stock_id ])
    end

    # Check if stock belongs to current user
    def stock_belongs_to_current_user?(stock_id)
      return false if stock_id.blank?
      Stock.exists?(id: stock_id, user_id: current_user.id)
    end

    # Before action to check if the stock belongs to current user
    def check_stock_ownership
      stock_id = params[:stock_id] || params.dig(:product, :stock_id)

      # For existing products, get the stock_id from the product if not in params
      if params[:id].present? && stock_id.blank?
        product = Product.find_by(id: params[:id])
        stock_id = product&.stock_id
      end

      # Redirect if stock doesn't belong to current user
      if stock_id.present? && !stock_belongs_to_current_user?(stock_id)
        redirect_to root_path, alert: "You don't have permission to access this stock." # rubocop:disable Rails/I18nLocaleTexts
        false
      end
    end
end
