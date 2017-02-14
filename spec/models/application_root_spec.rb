require 'spec_helper'

describe ApplicationRoot do
  it { expect(ApplicationRoot.office.url).to eq 'http://office.mumuki.io' }
end
