module Api::ApiHelper
  def request_helper(params, uri_str)
    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
    xmldoc = Nokogiri::XML(res.body)
    JSON.parse(xmldoc.child.child)
  end

  def request_hunau_api_login(id, password)
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.login_path
    params = { id: id, password: password, ak: ENV['HUNAU_API_PARAMS_AK'], BDUserID: ENV['HUNAU_API_PARAMS_BDUSERID'] }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def render_error_code(errors = {})
    errors = errors.nil? ? {} : errors
    emsg    = ''
    details = []

    displayed_error_type, displayed_error_fields = errors.sort.to_h.first

    ecode = find_error_code(displayed_error_type, displayed_error_fields.try(:first))
    displayed_error_fields.to_a.each do |field|
      details << { type: find_error_code(displayed_error_type, field), msg: field }
    end

    { code: ecode, msg: emsg, errors: details }
  end

  def find_error_code(etype = '', field = '')
    field = field.to_s.split(',').first
    field_code = Settings.error_code.error_fields[field.to_s.downcase.split(' ').join('_')].to_i
    "#{etype.to_i},#{field_code}"
  end
end
