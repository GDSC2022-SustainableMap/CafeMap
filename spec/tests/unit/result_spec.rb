# frozen_string_literal: true

require_relative '../../helpers/spec_helper'

describe 'Unit test of Result value' do
  it 'should valid success status and message' do
    result = CafeMap::Response::ApiResult.new(status: :ok, message: 'cafemap:success')

    _(result.status).must_equal :ok
    _(result.message).must_equal 'cafemap:success'
  end

  it 'should valid failure status and message' do
    result = CafeMap::Response::ApiResult.new(status: :not_found, message: 'cafemap:failure')

    _(result.status).must_equal :not_found
    _(result.message).must_equal 'cafemap:failure'
  end

  it 'should report error for invalid status' do
    _(proc do
      CafeMap::Response::ApiResult.new(status: :stupid_status, message: 'cafemap:stupid_status')
    end).must_raise ArgumentError
  end
end
