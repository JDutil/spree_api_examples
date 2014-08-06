require_relative '../base'

module Examples
  module ReturnAuthorizations
    class ReceiveAuthorization

      def self.run(client)
        # TODO: Update spree_sample:load to provide sample rmas and shipped orders to run this against
        # NOTE: Need to use a shipped orders number.
        response = client.get('/api/orders/R763442970')
        order = JSON.parse(response.body)

        response = client.post("/api/orders/#{order['number']}/return_authorizations",
          {
            return_authorization: {
              amount: order["total"],
              order_id: order["id"]
            }
          }
        )
        return_authorization = JSON.parse(response.body)
        puts return_authorization.inspect

        if response.status == 201
          client.succeeded 'Return has been successfully authorized.'
        else
          client.failed 'Return failed to authorize.'
        end

        response = client.put("/api/orders/#{order['number']}/return_authorizations/#{return_authorization['id']}/receive")

        if response.status == 201
          return_authorization = JSON.parse(response.body)
          client.succeeded 'Return has been successfully received.'
        else
          client.failed 'Return failed to receive.'
        end
      end

    end
  end
end

Examples.run(Examples::ReturnAuthorizations::ReceiveAuthorization)
