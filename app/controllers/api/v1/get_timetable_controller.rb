class Api::V1::GetTimetableController < ApplicationController
  require 'rexml/document'
  include REXML
  include Api::V1::GetTimetableHelper

  def get_timetable
    queryParams = {
      Id: params['Id'],
      Term: params['Term'],
      weeks: params['weeks'],
      vid: ENV['HUNAU_API_PARAMS_AK']
    }

    tableQuery = request_timetable(queryParams)
    xmldoc = Nokogiri::XML(tableQuery)
    tableQuery = JSON.parse(xmldoc.child.child)

    render :json => {
      status: 'success',
      message: '请求成功',
      data: tableQuery["Response"]
    }
  end

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
