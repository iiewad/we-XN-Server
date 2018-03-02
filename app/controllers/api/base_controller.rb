class Api::BaseController < ApplicationController
  # include ApiHelper
  # before_action :sanitize

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActionController::RoutingError,     with: :not_found
  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActionController::UnknownFormat,    with: :not_found

  def bad_request(errors = [])
    @errors ||= if errors.is_a? Array
                  errors
                else
                  [errors.to_s]
                end

    Rails.logger.error "BadRequest: #{errors}"
    render 'api/base/error_message'
  end

end

