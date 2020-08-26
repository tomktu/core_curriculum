# ask user for the loan amount, APR, and loan duration
# convert APR to monthly interest rate
# convert loan duration to months
# calculate monthly payment
# output monthly payment back to user

def prompt(message)
  puts "=> #{message}"
end

def integer?(input)
  input.to_i.to_s == input
end

def float?(input)
  input.to_f.to_s == input
end

def valid_number?(input)
  integer?(input) || float?(input)
end

prompt("Hi! Welcome to your friendly neighborhood Mortage Calculator.")

loop do
  loan_amount = nil
  loop do
    prompt("Please enter the total amount of your loan: \n(For example, enter 80000 for an $80,000 loan.)")
    loan_amount = gets.chomp

    if valid_number?(loan_amount)
      break
    else
      prompt("Hmm...that doesn't look like a valid number. Please try again.")
    end
  end

  apr = nil
  loop do
    prompt("Please enter the Annual Percentage Rate (APR) of your loan: \n(For example, enter 12.5 for an APR of 12.5%)")
    apr = gets.chomp

    if valid_number?(apr)
      break
    else
      prompt("Hmm...that doesn't look like a valid number. Please try again.")
    end
  end

  loan_duration = nil
  loop do
    prompt("Please enter the duration of the loan in months: \n(For example, enter 12 if the loan is 1 year.)")
    loan_duration = gets.chomp

    if integer?(loan_duration)
      break
    else
      prompt("Hmm...that doesn't look like a valid integer. Please try again.")
    end
  end

  prompt("Thank you! Calculating the monthly payment for a $#{loan_amount} loan with an APR of #{apr}% and loan duration of #{loan_duration} months...")

  monthly_interest_rate = apr.to_f / 12 / 100
  loan_amount = loan_amount.to_f
  loan_duration = loan_duration.to_i

  monthly_payment = loan_amount * (monthly_interest_rate / (1 - (1 + monthly_interest_rate)**(-loan_duration)))

  prompt("Your monthly payment is $#{monthly_payment.round(2)}.")

  prompt("Do you want to make another calculation? (Enter Y to make another calculation)")
  answer = gets.chomp.downcase
  break unless answer == 'y'
end
