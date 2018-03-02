ejson = render_error_code(errors)
json.code ejson[:code]
json.msg  ejson[:msg]

json.errors ejson[:errors] do |err|
  json.type err[:type]
  json.msg  err[:msg]
end
