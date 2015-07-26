require 'features_helper'

describe 'Visit home' do
  it 'is successfull' do
    visit '/'
    expect(page.body).to have_content 'constXife'
  end
end
