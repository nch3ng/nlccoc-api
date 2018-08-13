namespace :token do
  desc 'Check expiry'
  task check: :environment do
    expiry = ENV['TOKEN_EXPIRY'].to_i
    @tokens = Token.all
    @tokens.each do |token|
      diff = Time.current - token.created_at
      minutes_passed = (diff/1.minutes).round

      if expiry < minutes_passed
        puts 'delete ' + token.inspect
        token.delete
      end
    end
  end
end