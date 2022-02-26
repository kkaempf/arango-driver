require_relative 'spec_helper'

describe Arango::Request do
  it 'can format headers' do
    class AReq < Arango::Request
      header 'If-Match'
    end
    r = AReq.new(server: Object.new, headers: { if_match: true })
    expect(r.formatted_headers).to eq({ 'If-Match' => true })
  end

  it 'can format params' do
    class BReq < Arango::Request
      param :is_system
    end
    r = BReq.new(server: Object.new, params: { is_system: true })
    expect(r.formatted_params).to eq({ 'isSystem' => true })
  end

  it 'can format the body' do
    class CReq < Arango::Request
      body :is_system
    end
    r = CReq.new(server: Object.new, body: { is_system: true })
    expect(r.formatted_body).to eq({ 'isSystem' => true })
  end

  it 'can format the body with a nested body' do
    class DReq < Arango::Request
      body :is_system do
        key :is_system
      end
    end
    r = DReq.new(server: Object.new, body: { is_system: { is_system: true }})
    expect(r.formatted_body).to eq({ 'isSystem' => { 'isSystem' => true }})
  end

  it 'can format the uri' do
    class EReq < Arango::Request
      uri_template '{/db_context*}/_api/{is_system}'
    end
    r = EReq.new(server: OpenStruct.new(driver_instance: OpenStruct.new(base_uri: '/test')), args: { is_system: true })
    expect(r.formatted_uri).to eq('/test/_api/true')
    r = EReq.new(server: OpenStruct.new(driver_instance: OpenStruct.new(base_uri: '/test')), args: { db: 'data', is_system: true })
    expect(r.formatted_uri).to eq('/test/_db/data/_api/true')
  end

  it 'can valiadate headers' do
    class FReq < Arango::Request
      header 'If-Match', :required
    end
    r = FReq.new(server: Object.new, headers: { if_match: true })
    expect(r.formatted_headers).to eq({ 'If-Match' => true })
    expect { FReq.new(server: Object.new, headers: { if_match: nil }) }.to raise_error Arango::Error
    expect { FReq.new(server: Object.new, headers: {}) }.to raise_error Arango::Error
    expect { FReq.new(server: Object.new) }.to raise_error Arango::Error
  end

  it 'can validate params' do
    class GReq < Arango::Request
      param :is_system, :required
    end
    r = GReq.new(server: Object.new, params: { is_system: true })
    expect(r.formatted_params).to eq({ 'isSystem' => true })
    expect { GReq.new(server: Object.new, params: { is_system: nil }) }.to raise_error Arango::Error
    expect { GReq.new(server: Object.new, params: {}) }.to raise_error Arango::Error
    expect { GReq.new(server: Object.new) }.to raise_error Arango::Error
  end

  it 'can validate the body' do
    class HReq < Arango::Request
      body :is_system, :required
    end
    r = HReq.new(server: Object.new, body: { is_system: true })
    expect(r.formatted_body).to eq({ 'isSystem' => true })
    expect(HReq.new(server: Object.new, body: { is_system: nil }).formatted_body).to eq({ 'isSystem' => nil })
    expect { HReq.new(server: Object.new, body: {}) }.to raise_error Arango::Error
    expect { HReq.new(server: Object.new) }.to raise_error Arango::Error
  end

  it 'can validate the body with a nested body' do
    class IReq < Arango::Request
      body :is_system, :required do
        key :is_system, :required
      end
    end
    r = IReq.new(server: Object.new, body: { is_system: { is_system: true }})
    expect(r.formatted_body).to eq({ 'isSystem' => { 'isSystem' => true }})
    expect(IReq.new(server: Object.new, body: { is_system: { is_system: nil }}).formatted_body).to eq({ 'isSystem' => { 'isSystem' => nil }})
    expect { IReq.new(server: Object.new, body: { is_system: {}}) }.to raise_error Arango::Error
    expect { IReq.new(server: Object.new, body: {}) }.to raise_error Arango::Error
    expect { IReq.new(server: Object.new) }.to raise_error Arango::Error
  end

  it 'benchmarking' do
    puts
    Benchmark.ips do |x|
      class AReq < Arango::Request
        header 'If-Match'
      end
      class BReq < Arango::Request
        param :is_system
      end
      class CReq < Arango::Request
        body :is_system
      end
      class DReq < Arango::Request
        body :is_system do
          key :is_system
        end
      end
      class EReq < Arango::Request
        uri_template '{/db_context*}/_api/{is_system}'
      end
      class AllReq < Arango::Request
        uri_template '{/db_context*}/_api/{is_system}'
        header 'If-Match'
        param :is_system
        body :is_system do
          key :is_system
        end
      end
      x.report("request header") { AReq.new(server: Object.new, headers: { if_match: true }).formatted_headers }
      x.report("request param") { BReq.new(server: Object.new, params: { is_system: true }).formatted_params }
      x.report("request body") { CReq.new(server: Object.new, body: { is_system: true }).formatted_body }
      x.report("request nested body") { DReq.new(server: Object.new, body: { is_system: { is_system: true }}).formatted_headers }
      x.report("request uri") { EReq.new(server: OpenStruct.new(driver_instance: OpenStruct.new(base_uri: '/test')), args: { is_system: true }).formatted_headers }
      x.report("request all") do
        r = AllReq.new(server: OpenStruct.new(driver_instance: OpenStruct.new(base_uri: '/test')), args: { is_system: true }, headers: { if_match: true },
                       params: { is_system: true }, body: { is_system: { is_system: true }})
        r.formatted_headers
        r.formatted_params
        r.formatted_body
        r.formatted_uri
      end
    end
  end
end
