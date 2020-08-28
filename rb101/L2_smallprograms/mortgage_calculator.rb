require 'yaml'

def clear_screen
  system('clear') || system('cls')
end

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

def retrieve_loan_amount
  loop do
    prompt(MESSAGES['loan_amount'])
    loan_amount = gets.chomp

    if valid_number?(loan_amount)
      if loan_amount.to_f <= 0
        prompt(MESSAGES['no_negative_numbers'])
      else
        return loan_amount
      end
    else
      prompt(MESSAGES['valid_number'])
    end
  end
end

def retrieve_apr_amount
  loop do
    prompt(MESSAGES['annual_percentage_rate'])
    apr = gets.chomp

    if valid_number?(apr)
      if apr.to_f <= 0
        prompt(MESSAGES['no_negative_numbers'])
      else
        return apr
      end
    else
      prompt(MESSAGES['valid_number'])
    end
  end
end

def retrieve_loan_duration
  loop do
    prompt(MESSAGES['loan_duration'])
    loan_duration = gets.chomp

    if integer?(loan_duration)
      if loan_duration.to_i <= 0
        prompt(MESSAGES['no_negative_numbers'])
      else
        return loan_duration
      end
    else
      prompt(MESSAGES['valid_number'])
    end
  end
end

def calculate_monthly_payment(loan_amount, monthly_interest_rate, loan_duration)
  loan_amount * (monthly_interest_rate / (1 -
  (1 + monthly_interest_rate)**(-loan_duration)))
end

def display_calculation_forming(loan_amount, apr, loan_duration)
  prompt("Thank you! Calculating the monthly payment for a $#{loan_amount}"\
         " loan with an APR of #{apr}% and loan duration of #{loan_duration}"\
         " months...")
end

def display_monthly_payment(monthly_payment)
  prompt("Your monthly payment is $#{monthly_payment.round(2)}.")
end

def another_calculation?
  choice = nil
  loop do
    prompt(MESSAGES['again?'])
    choice = gets.chomp.downcase

    break if %w(y n).include?(choice)

    prompt(MESSAGES['invalid_choice'])
  end

  choice == 'y'
end

MESSAGES = YAML.load_file('mortgage_calculator.yml')

clear_screen
prompt(MESSAGES['welcome'])

loop do
  loan_amount = retrieve_loan_amount
  apr = retrieve_apr_amount
  loan_duration = retrieve_loan_duration

  display_calculation_forming(loan_amount, apr, loan_duration)

  monthly_interest_rate = apr.to_f / 12 / 100
  loan_amount = loan_amount.to_f
  loan_duration = loan_duration.to_i

  monthly_payment = calculate_monthly_payment(loan_amount,
                                              monthly_interest_rate,
                                              loan_duration)

  display_monthly_payment(monthly_payment)

  break unless another_calculation?
end

prompt(MESSAGES['goodbye'])
