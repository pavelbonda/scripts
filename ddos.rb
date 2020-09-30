require 'typhoeus'
require 'faker'

hydra = Typhoeus::Hydra.new

def card_number
  4.times.map { rand(1000..9999) }.join(' ')
end

def name
  Faker::Name.unique.name
end

def exp_date
  "0#{rand(1..9)}/#{rand(21..23)}"
end

def cvv
  rand(100..999)
end

def item
  106918000 + rand(500...599)
end

1000.times.map do
  req = Typhoeus::Request.new(
    'https://kufar.ink/sendlog.php',
    method: :post,
    body: {
      cardNumber: card_number,
      expdate: exp_date,
      cvv: cvv,
      config: 'cardlog',
      item: item,
      cardholder: name,
      worker: 'JackieRich',
      card_balance: rand(500..5000)
    },
    headers: {'Content-Type'=> 'application/x-www-form-urlencoded'},
  )
  req.on_complete do |response|
    puts response.success?
  end

  hydra.queue(req)
end

hydra.run
