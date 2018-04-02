class Api::V1::GetEnergyController < ApplicationController
  require 'rexml/document'
  include REXML

  include Api::V1::GetEnergyHelper
  def get_energy_query
    energyParams = {}
    energyParams['userId'] = params['userId']
    energyParams['Room'] = params['Room']
    energyParams['Time'] = params['Time']

    queryType = params['QueryType']
    energyQuery = getEnergyQuery(energyParams, queryType)

    xmldoc = Nokogiri::XML(energyQuery)
    energyQuery = JSON.parse(xmldoc.child.child)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: energyQuery
    }
  end

end
