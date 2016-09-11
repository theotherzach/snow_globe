class NotifiesTaxCloud

  attr_accessor :payment

  def initialize(payment)
    @payment = payment
    @success = false
  end

  def tax_calculator
    @tax_calculator ||= purchase.price_calculator.tax_calculator
  end

  def valid_amount?
    tax_calculator.tax_amount == payment.paid_taxes
  end

  def run
    if valid_amount?
      result = tax_calculator.authorized_with_capture(payment.reference)
      @success = (result == "OK")
    else
      raise TaxValidityException.new(
          payment_id: payment.id, expected_taxes: tax_calculator.tax_amount,
          paid_taxes: payment.paid_taxes)
    end
  end

end
