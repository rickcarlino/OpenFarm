# frozen_string_literal: true

require 'spec_helper'
svg = File.read('./spec/fixtures/cantaloupe.svg')

describe Api::V1::IconsController, type: :controller do
  include ApiHelpers

  let(:user) { sign_in(user = FactoryGirl.create(:user)) && user }
  let(:icon) { FactoryGirl.create(:icon, user: user) }

  describe 'create' do
    it 'makes icons' do
      sign_in user
      ATTRS = { name: 'My icon.',
                description: 'lorem ipsum',
                svg: svg }.freeze
      data = { attributes: ATTRS }
      post 'create', data: data, format: :json
      expect(response.status).to eq(200)
      resp = json['data']['attributes']
      expect(resp['description']).to eq(ATTRS[:description])
      expect(resp['name']).to eq(ATTRS[:name])
      expect(resp['svg'].first(40)).to eq(svg.first(40))
    end

    it 'ignores short queries' do
      get 'index', filter: 'no', format: :json
      expect(json['data']).to be_kind_of(Array)
      expect(json['data'].length).to eq(0)
    end

    it 'views a specific icon' do
      get 'show', id: icon._id.to_s, format: :json
      expect(json['data']['id']).to eq(icon._id.to_s)
    end
  end
end
