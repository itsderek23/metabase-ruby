# frozen_string_literal: true

module Metabase
  module Endpoint
    module Dataset

      COUNT_QUERY = "select count(id) from owners"

      LISTINGS_QUERY = 'select 
  owners.id, owners.last_city_login, owners.confirmed_at,
  owners.email, 
  owners.first_name, owners.last_name,
  owners.company, owners.telephone, 
  owners.created_at as "owners_created_at",
  (select created_at from listings where owner_id = owners.id order by created_at limit 1) as listing_created_at,
  (select transunion_id from listings where owner_id = owners.id order by created_at limit 1) as listing_transunion_id,
  (select syndication_expires_on from listings where owner_id = owners.id order by created_at limit 1) as listing_syndication_expires_on,
  (select partial from listings where owner_id = owners.id order by created_at limit 1) as listing_partial,
  (select length(description) from listings where owner_id = owners.id order by created_at limit 1) as listing_description_length,
  (select available_date from listings where owner_id = owners.id order by created_at limit 1) as listing_available_date,  
  (select count(*) from listings where owner_id = owners.id) as listings_count,
  (select zip from listings where owner_id = owners.id limit 1) as listing_zip,
  (select rent_amount from listings where owner_id = owners.id limit 1) as listing_rent_amount,
  (select count(*) from rental_requests where listing_id IN (select id from listings where listings.owner_id = owners.id)) as rental_requests_count,
  (select count(*) from photos where listing_id = (select listings.id from listings where owner_id = owners.id order by created_at limit 1))  as photos_count,
  (select created_at from rental_requests where listing_id IN (select id from listings where listings.owner_id = owners.id) order by created_at limit 1) as rental_request_created_at,
  (select count(*) from payments where rental_request_id IN (select id from rental_requests  where listing_id IN (select id from listings where listings.owner_id = owners.id)) ) as payments_count,
  process, properties, rental_application_answer, vacancy_answer 
from owners left join owner_onboardings on owners.id = owner_onboardings.owner_id'

      # can't export entire query - https://discourse.metabase.com/t/where-to-get-api-query-schema-specification/5483/5

      # Execute a query and retrieve the results in the usual format.
      #
      # @param params [Hash] Query string
      # @return [Array<Hash>] Parsed response JSON
      # @see https://github.com/metabase/metabase/blob/master/docs/api-documentation.md#post-apidatasetexport-format
      def query_dataset(query = {
        database: 3,
        native: {query: LISTINGS_QUERY},
        type: "native"}, format: :csv)
        post("/api/dataset", query)
      end

      # # Fetch the card.
      # #
      # # @param card_id [Integer, String] Card ID
      # # @param params [Hash] Query string
      # # @return [Hash] Parsed response JSON
      # # @see https://github.com/metabase/metabase/blob/master/docs/api-documentation.md#get-apicardid
      # def card(card_id, **params)
      #   get("/api/card/#{card_id}", params)
      # end

      # # Fetch query results of the card with metadata.
      # #
      # # @param card_id [Integer, String] Card ID
      # # @param params [Hash] Request body
      # # @return [Hash] Parsed response JSON
      # # @see https://github.com/metabase/metabase/blob/master/docs/api-documentation.md#post-apicardcard-idquery
      # def query_card_with_metadata(card_id, **params)
      #   post("/api/card/#{card_id}/query", params)
      # end

      # # Fetch query results of the card.
      # #
      # # @param card_id [Integer, String] Card ID
      # # @param format [Symbol, String] Export format (csv, json, xlsx)
      # # @param params [Hash] Request body
      # # @return [Array<Hash>, String] Query results
      # # @see https://github.com/metabase/metabase/blob/master/docs/api-documentation.md#post-apicardcard-idqueryexport-format
      # def query_card(card_id, format: :json, **params)
      #   post("/api/card/#{card_id}/query/#{format}", params)
      # end
    end
  end
end
