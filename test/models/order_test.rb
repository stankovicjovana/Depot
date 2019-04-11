require 'test_helper'

class OrderTest < ActiveSupport::TestCase
	include ActiveJob::TestHelper
	
	test "check routing number" do
		LineItem.delete_all
		Order.delete_all

		visit store_index_url
		assert_selector "#order_routing_number"

		fill_in "Routing #", with: "123456"
		fill_in "Account #", with: "987654"

		#perform any jobs that get enqueued inside the block
		perform_enqueued_jobs do
			click_button "Place Order"
		end

		#check that an order was created in the way we expect
		orders = Order.all
		assert_equal 1, orders.size

		order = orders.first

		assert_equal "Dave Thomas", order.name
		assert_equal "123 Main Street", order.address
		assert_equal "dave@example.com", order.email
		assert_equal "Check", order.pay_type
		assert_equal 1, order.line_items.size
		
		#check that the mail was sent
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["dave@example.com"], mail.to
		assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
		assert_equal "Pragmatic Store Order Confirmation", mail.subject
	end
end
