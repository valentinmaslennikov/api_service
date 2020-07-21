# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/param/version'
require 'date'
require 'time'
# require 'byebug'

module FixParam
  class InvalidParameterError < StandardError
    attr_accessor :param, :options
  end

  def param(name, type, options = {})
    name = name.to_s

    return unless params.member?(name) || options.key?(:default) || options[:required]

    begin
      params[name] = coerce(params[name], type, options)
      if params[name].nil? && options.key?(:default)
        params[name] = (options[:default].call if options[:default].respond_to?(:call)) || options[:default]
      end
      params[name] = options[:transform].to_proc.call(params[name]) if params[name] && options[:transform]
      validate!(params[name], options)
      params[name]
    rescue InvalidParameterError => e
      if options[:raise] || (begin
                                 settings.raise_sinatra_param_exceptions
                             rescue StandardError
                               false
                               end)
        e.param = name
        e.options = options
        raise e
      end
      error = options[:message] || e.to_s

      if content_type&.match(mime_type(:json))
        error = { message: error, errors: { name => e.message } }.to_json
      else
        content_type 'text/plain'
      end

      halt 422, error
    end
  end

    private

  def coerce(param, type, options = {})
    return nil if param.nil?
    return param if begin
                         param.is_a?(type)
                    rescue StandardError
                      false
                       end
    return Integer(param, 10) if type == Integer
    return Float(param) if type == Float
    return String(param) if type == String
    return Date.parse(param) if type == Date
    return Time.parse(param) if type == Time
    return DateTime.parse(param) if type == DateTime
    return Array(param.split(options[:delimiter] || ',')) if type == Array
    return Hash[param.split(options[:delimiter] || ',').map { |c| c.split(options[:separator] || ':') }] if type == Hash

    if [TrueClass, FalseClass, Boolean].include? type
      coerced = if /^(false|f|no|n|0)$/i === param.to_s
                  false
                else
                  /^(true|t|yes|y|1)$/i === param.to_s ? true : nil
end
      raise ArgumentError if coerced.nil?

      return coerced
    end
    nil
  rescue ArgumentError
    raise InvalidParameterError, "'#{param}' is not a valid #{type}"
  end

  def validate!(param, options)
    options.each do |key, value|
      case key
      when :required
        raise InvalidParameterError, 'Parameter is required' if value && param.nil?
      when :blank
        raise InvalidParameterError, 'Parameter cannot be blank' if !value && case param
                                                                              when String
                                                                                !(/\S/ === param)
                                                                              when Array, Hash
                                                                                param.empty?
                                                                              else
                                                                                param.nil?
        end
      when :format
        unless param.is_a?(String)
          raise InvalidParameterError, 'Parameter must be a string if using the format validation'
        end
        raise InvalidParameterError, "Parameter must match format #{value}" unless param =~ value
      when :is
        raise InvalidParameterError, "Parameter must be #{value}" unless param === value
      when :in, :within, :range
        raise InvalidParameterError, "Parameter must be within #{value}" unless param.nil? || case value
                                                                                              when Range
                                                                                                value.include?(param)
                                                                                              else
                                                                                                Array(value).include?(param)
        end
      when :min
        raise InvalidParameterError, "Parameter cannot be less than #{value}" unless param.nil? || value <= param
      when :max
        raise InvalidParameterError, "Parameter cannot be greater than #{value}" unless param.nil? || value >= param
      when :min_length
        unless param.nil? || value <= param.length
          raise InvalidParameterError, "Parameter cannot have length less than #{value}"
        end
      when :max_length
        unless param.nil? || value >= param.length
          raise InvalidParameterError, "Parameter cannot have length greater than #{value}"
        end
      end
    end
  end
  end
