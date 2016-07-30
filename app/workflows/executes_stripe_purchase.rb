class ExecutesStripePurchase

  attr_accessor :payment, :stripe_token, :stripe_charge

  def initialize(payment, stripe_token)
    @payment = payment
    @stripe_token = StripeToken.new(stripe_token: stripe_token)
  end

  def run
    result = charge
    on_failure unless result
  end

  def charge
    Payment.transaction do
      return if payment.response_id.present?
      @stripe_charge = StripeCharge.new(token: stripe_token, payment: payment)
      @stripe_charge.charge
      payment.update!(@stripe_charge.payment_attributes)
      payment.succeeded?
    end
  end

  def unpurchase_tickets
    payment.tickets.each(&:waiting!)
  end

  def on_failure
    unpurchase_tickets
  end

end
