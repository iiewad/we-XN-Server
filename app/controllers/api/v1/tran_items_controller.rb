class Api::V1::TranItemsController < ApplicationController
  def index
    tranItem = TranItem.select(:id, :trancode, :tranname)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: tranItem
    }
  end
end
