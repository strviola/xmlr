require "spec_helper"

describe XMLR do
  it "has a version number" do
    expect(Xmlr::VERSION).not_to be nil
  end

  describe 'xmlr' do
    include XMLR

    context 'no parameters start and end tag' do
      subject { strong { "WARNING: Too big size" } }
      it do
        is_expected.to eq <<~EOS
          <strong>
            WARNING: Too big size
          </strong>
        EOS
      end
    end

    context 'with parameters start and end tag' do
      subject do
        div style: "text-align: center;", class: [:wrapper, :body] do
          "This is body."
        end
      end
      it do
        is_expected.to eq <<~EOS
          <div style="text-align: center;" class="wrapper body">
            This is body.
          </div>
        EOS
      end
    end

    context 'no parameters single tag' do
      subject { br }
      it do
        is_expected.to eq "<br />"
      end
    end

    context 'with parameters single tag' do
      subject { hr id: "content-main--division", class: [:solid, :red] }
      it do
        is_expected.to eq %(<hr id="content-main--division" class="solid red" />)
      end
    end
  end
end
