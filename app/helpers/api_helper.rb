module ApiHelper

  # Null and empty values allowed
  def is_number_in_range?(number, min, max)
    number.nil? || number.empty? || (min..max).include?(number.to_i)
  end

  def render_422_error(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  def render_400_error(message)
    render json: { error: message }, status: :bad_request
  end
end