describe 'POST /api/auth/register' do
  it 'registers a user with first name, last name, email, and password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '123456', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json['success']).to eq(true)
    expect(json['msg']).to eq('You are successfully registered')
    expect(json['token']).to be_present
  end

  it 'failed to register a user without an email' do
    post '/api/auth/register', :params => { password: '123456', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Email is needed')
  end

  it 'failed to register a user without password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Password is needed')
  end

  it 'failed to register a user without a first name' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '123456', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('First name is needed')
  end

  it 'failed to register a user without a last name' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '123456', first_name: 'John' }
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Last name is needed')
  end
end