require "spec_helper"

describe Xmlr do
  it "has a version number" do
    expect(Xmlr::VERSION).not_to be nil
  end

  describe 'xmlr' do
    include Doctype
    context 'no args single tag' do
      subject { hoge }
      it do
        is_expected.to eq "<hoge />"
      end
    end

    context 'with args single tag' do
      subject { hoge id: :my_id, class: [:class1, :class2] }
      it do
        is_expected.to eq %(<hoge id="my_id" class="class1 class2" />)
      end
    end
  end
end
