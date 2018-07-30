describe 'POST /api/auth/register' do
  it 'registers a user with first name, last name, email, and password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(true)
    expect(json['msg']).to eq('You are successfully registered')
    expect(json['token']).to be_present
  end

  it 'failed to register a user with an exist email' do
    user = create(:user, email: 'jonhdoe1000@test.com')
    post '/api/auth/register', :params => { email: 'jonhdoe1000@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('The email is registered')
  end

  it 'failed to register a user without an email' do
    post '/api/auth/register', :params => { password: '12345678', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Email is needed')
  end

  it 'failed to register a user without password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Password is needed')
  end

  it 'failed to register a user without a first name' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', last_name: 'Doe' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('First name is needed')
  end

  it 'failed to register a user without a last name' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Last name is needed')
  end

  it 'failed to register a user with an invalid email' do
    post '/api/auth/register', :params => { email: 'jonhdoetest.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Bad email format')
  end

  it 'failed to register a user when password is too short' do
    post '/api/auth/register', :params => { email: 'jonhdoe20012@test.com', password: '1234567', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Password has to be at least 8 characters long')
  end
end

describe 'POST /api/auth/login' do

  before(:all) do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
  end

  it 'login an user with email, and password' do
    post '/api/auth/login', :params => { email: 'jonhdoe@test.com', password: '12345678' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(true)
    expect(json['msg']).to eq('You are successfully logged in')
    expect(json['token']).to be_present
  end

  it 'failed to login an user with email, and wrong password' do
    
    post '/api/auth/login', :params => { email: 'jonhdoe@test.com', password: '1234567' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('The password is wrong')
  end
  it 'failed to login an user with an invalid email' do
    post '/api/auth/login', :params => { email: 'jonhdoetest.com', password: '12345678' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('This email is not registered')
  end
end
describe 'GET /api/auth/check-state' do

  before(:all) do
    post '/api/auth/login', :params => { email: 'jonhdoe@test.com', password: '12345678' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    @token = json['token']
  end

  it 'state is valid if the token is valid passing x-access-token' do 
    get '/api/auth/check-state', :headers => { "x-access-token": @token }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(true)
    expect(json['msg']).to eq('You\'re authorized')
    decoded_token = json['decoded_token'].first
    expect(decoded_token['email']).to eq('jonhdoe@test.com')
    expect(decoded_token['name']).to eq('John Doe')

    alg = json['decoded_token'].second['alg']
    expect(alg).to eq('HS256')
  end

  it 'state is valid if the token is valid passing Bearer token' do 
    get '/api/auth/check-state', :headers => { "Authorization": "Bearer #{@token}" }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['success']).to eq(true)
    expect(json['msg']).to eq('You\'re authorized')
    decoded_token = json['decoded_token'].first
    expect(decoded_token['email']).to eq('jonhdoe@test.com')
    expect(decoded_token['name']).to eq('John Doe')

    alg = json['decoded_token'].second['alg']
    expect(alg).to eq('HS256')
  end
end