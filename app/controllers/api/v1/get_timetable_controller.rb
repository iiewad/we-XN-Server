class Api::V1::GetTimetableController < ApplicationController
  require 'rexml/document'
  include REXML
  include Api::V1::GetTimetableHelper

  def get_term
    termQuery = request_term
    xmldoc = Nokogiri::XML(termQuery)
    termQuery = JSON.parse(xmldoc.child.child)

    render :json => {
      status: 'success',
      message: '请求成功',
      data: termQuery["Response"]
    }
  end
end
