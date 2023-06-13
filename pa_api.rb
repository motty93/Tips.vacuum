require 'vacuum'
require 'dotenv'

class PaApiService
  attr_accessor :asin_code, :vacuum

  def initialize(args = {})
    @asin_code = args[:asin_code]
    @vacuum = Vacuum.new(
      marketplace: 'JP',
      access_key: access_key,
      secret_key: secret_key,
      partner_tag: partner_tag,
    )

    super
  end

  def perform
    items = vacuum.get_items(item_ids: [asin_code], resources: ['Offers.Summaries.OfferCount']).to_h
    if items.key?('Errors')
      p 'pa-apiでデータを取得することができません'
    end

    count = items.dig('ItemsResult', 'Items', 0, 'Offers', 'Summaries', 0, 'OfferCount')
    count.nil? ? 0 : count
  end

  private

  def access_key
    ENV.fetch('ACCESS_KEY', nil)
  end

  def secret_key
    ENV.fetch('ACCESS_KEY', nil)
  end

  def partner_tag
    ENV.fetch('PARTNER_TAG', nil)
  end
end

pa_api = PaApiService.new
p pa_api.perform(asin_code: 'ASDFSDGERW')
