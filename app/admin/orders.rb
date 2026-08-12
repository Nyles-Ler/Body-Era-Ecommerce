ActiveAdmin.register Order do
  permit_params :order_status

  actions :index,:show, :edit, :update

  remove_filter :stripe_checkout_session_id
  remove_filter :stripe_payment_intent_id

  filter :user
  filter :address
  filter :order_status
  filter :subtotal
  filter :tax_amount
  filter :total_amount
  filter :created_at

  form do |f|
  f.semantic_errors

  f.inputs "Order Status" do
    f.input :order_status,
            as: :select,
            collection: Order::STATUSES,
            include_blank: false
     end

  f.actions
  end

  show do
    attributes_table do
      row :id
      row :order_status
      row :created_at

      row "Customer" do |order|
        "#{order.user.first_name} #{order.user.last_name}"
      end

      row "Email" do |order|
        order.user.email
      end

      row "Phone Number" do |order|
        order.user.phone_number
      end

      row "Shipping Address" do |order|
        address = order.address

        if address
          "#{address.street_address}, #{address.city}, #{address.province}, #{address.postal_code}, #{address.country}"
        else
          "No address"
        end
      end
    end

    panel "Products Ordered" do
      table_for order.order_items do
        column "Product" do |item|
          item.product.name
        end

        column "Size" do |item|
          item.product_variant.size
        end

        column "Colour" do |item|
          item.product_variant.colour
        end

        column :quantity

        column "Unit Price" do |item|
          number_to_currency(item.unit_price)
        end

        column "Line Total" do |item|
          number_to_currency(item.line_total)
        end
      end
    end

    panel "Order Totals" do
      attributes_table_for order do
        row("Subtotal") do |o|
          number_to_currency(o.subtotal)
        end

        row("GST") do |o|
          number_to_currency(o.gst_amount)
        end

        row("PST") do |o|
          number_to_currency(o.pst_amount)
        end

        row("HST") do |o|
          number_to_currency(o.hst_amount)
        end

        row("Total Tax") do |o|
          number_to_currency(o.tax_amount)
        end

        row("Grand Total") do |o|
          number_to_currency(o.total_amount)
        end
      end
    end

    panel "Payment Information" do
      attributes_table_for order do
        row :stripe_checkout_session_id
        row :stripe_payment_intent_id
        row :paid_at
      end
    end
  end
end