require "millas/version"
require 'active_support'
require 'active_support/cache/dalli_store'
require 'active_support/configurable'

module Millas
  def self.configure(&block)
    yield @config ||= Millas::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :dispersion_number, :perform_dispersing, :second_intervals
  end

  configure do |config|
    config.dispersion_number = 5
    config.perform_dispersing = true
    config.second_intervals = 60
  end
end

class ActiveSupport::Cache::DalliStore
  # monkey patch
  alias_method :__read__, :read
  alias_method :__write__, :write
  alias_method :"__exist?__", :exist?
  alias_method :__delete__, :delete
  private :__read__, :__write__, :"__exist?__", :__delete__

  def read(name, options = {})
    dispersed = options.delete(:dispersed)
    name = decorated_name(name) if dispersing?(dispersed)
    __read__(name, options)
  end

  def write(name, value, options = {})
    dispersed = options.delete(:dispersed)
    if dispersing?(dispersed)
      expires_in = options[:expires_in]
      dispersions.map do |n|
        options.merge!({ expires_in: advanced_expires_in(expires_in, n) }) if expires_in
        __write__(decorated_name(name, n), value, options)
      end.sample
    else
      __write__(name, value, options)
    end
  end

  def exist?(name, options = {})
    dispersed = options.delete(:dispersed)
    name = decorated_name(name) if dispersing?(dispersed)
    send("__exist?__", name, options)
  end

  def delete(name, options = {})
    dispersed = options.delete(:dispersed)
    if dispersing?(dispersed)
      dispersions.map do |n|
        __delete__(decorated_name(name, n), options)
      end.sample
    else
      __delete__(name, options)
    end
  end

  private
  def dispersion_number
    number = Millas.config.dispersion_number.try(:to_i)
    number = 1 if !number || number <= 0
    number
  end

  def dispersions
    [*1..dispersion_number]
  end

  def dispersing?(dispersed)
    b = Millas.config.perform_dispersing
    b = !!dispersed unless dispersed.nil?
    b
  end

  def second_intervals
    (Millas.config.second_intervals || 0).seconds
  end

  def decorated_name(name, num = nil)
    "#{name}-#{num || magic_number}"
  end

  def advanced_expires_in(expires_in, n)
    expires_in + second_intervals*(n-1)
  end

  def magic_number
    number = dispersion_number
    # quadratic function
    result = number**rand
    # feel good factor (max = 0.35)
    alpha = number/40.to_f
    max_alpha = 0.35
    result += if alpha < max_alpha
      alpha
    else
      max_alpha
    end
    # return opposite number of the maximum value
    number - result.floor + 1
  end
end
