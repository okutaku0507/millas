require 'spec_helper'

describe ActiveSupport::Cache::DalliStore do
  before do
    ActiveSupport::Cache::DalliStore.new.clear
  end

  describe "write and read" do
    example 'write and read cache' do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"

      expect(cache.read(cache_key)).to eq(nil)
      cache.write(cache_key, cache_value)
      expect(cache.read(cache_key)).to eq(cache_value)
    end

    example 'write dispersed cache' do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"
      dispersions = [*1..Millas.config.dispersion_number.to_i]

      expect(cache.read(cache_key)).to eq(nil)
      cache.write(cache_key, cache_value, expires_in: 1.minutes)
      dispersions.each do |num|
        expect(cache.read("#{cache_key}-#{num}", dispersed: false)).to eq(cache_value)
      end
    end

    example 'write not dispersed cache' do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"
      dispersions = [*1..Millas.config.dispersion_number.to_i]

      expect(cache.read(cache_key, dispersed: false)).to eq(nil)
      cache.write(cache_key, cache_value, dispersed: false)
      expect(cache.read(cache_key, dispersed: false)).to eq(cache_value)
      dispersions.each do |num|
        expect(cache.read("#{cache_key}-#{num}", dispersed: false)).to eq(nil)
      end
    end
  end

  describe "exist?" do
    example "exist? cache" do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"

      expect(cache.exist?(cache_key)).to eq(false)
      cache.write(cache_key, cache_value)
      expect(cache.exist?(cache_key)).to eq(true)
    end

    example "exist? dispersed cache" do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"
      dispersions = [*1..Millas.config.dispersion_number.to_i]

      expect(cache.exist?(cache_key)).to eq(false)
      cache.write(cache_key, cache_value)
      dispersions.each do |num|
        expect(cache.exist?("#{cache_key}-#{num}", dispersed: false)).to eq(true)
      end
    end

    example "exist? not dispersed cache" do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"
      dispersions = [*1..Millas.config.dispersion_number.to_i]

      expect(cache.exist?(cache_key, dispersed: false)).to eq(false)
      cache.write(cache_key, cache_value, dispersed: false)
      expect(cache.exist?(cache_key, dispersed: false)).to eq(true)
      dispersions.each do |num|
        expect(cache.exist?("#{cache_key}-#{num}", dispersed: false)).to eq(false)
      end
    end
  end

  describe "delete" do
    example "delete cache" do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"

      expect(cache.exist?(cache_key)).to eq(false)
      cache.write(cache_key, cache_value)
      expect(cache.exist?(cache_key)).to eq(true)
      cache.delete(cache_key)
      expect(cache.exist?(cache_key)).to eq(false)
    end

    example "delete dispersed cache" do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"
      dispersions = [*1..Millas.config.dispersion_number.to_i]

      expect(cache.exist?(cache_key)).to eq(false)
      cache.write(cache_key, cache_value)
      dispersions.each do |num|
        expect(cache.exist?("#{cache_key}-#{num}", dispersed: false)).to eq(true)
      end
      cache.delete(cache_key)
      dispersions.each do |num|
        expect(cache.exist?("#{cache_key}-#{num}", dispersed: false)).to eq(false)
      end
    end

    example "delete not dispersed cache" do
      cache = ActiveSupport::Cache::DalliStore.new
      cache_key = "millas"
      cache_value = "Magic cake"
      dispersions = [*1..Millas.config.dispersion_number.to_i]

      expect(cache.exist?(cache_key, dispersed: false)).to eq(false)
      cache.write(cache_key, cache_value, dispersed: false)
      expect(cache.exist?(cache_key, dispersed: false)).to eq(true)
      dispersions.each do |num|
        expect(cache.exist?("#{cache_key}-#{num}", dispersed: false)).to eq(false)
      end
      cache.delete(cache_key, dispersed: false)
      expect(cache.exist?(cache_key, dispersed: false)).to eq(false)
    end
  end
end
