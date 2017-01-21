require "spec_helper"

describe XMLR do
  it "has a version number" do
    expect(Xmlr::VERSION).not_to be nil
  end

  describe 'xmlr' do
    include XMLR

    before(:each) { reset }

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
        is_expected.to eq "<br />\n"
      end
    end

    context 'with parameters single tag' do
      subject { hr id: "content-main--division", class: [:solid, :red] }
      it do
        is_expected.to eq %Q(<hr id="content-main--division" class="solid red" />\n)
      end
    end

    context '#doctype' do
      subject { doctype }
      it { is_expected.to eq "<!DOCTYPE HTML>\n" }
    end

    context '#doctype and nest tag' do
      subject do
        doctype
        head do
          title do
            "Title"
          end
        end
        get
      end
      it do
        is_expected.to eq <<~EOS
          <!DOCTYPE HTML>
          <head>
            <title>
              Title
            </title>
          </head>
        EOS
      end
    end

    context 'nested tags' do
      subject do
        doctype
        html do
          head do
            meta "http-equiv" => "Content-type", content: %w(text-html; charset=utf-8)
            title do
              "XMLRサンプルファイル"
            end
          end
          body do
            div class: %w(wrapper content-main) do
              "XMLRへようこそ"
            end
          end
        end
        get
      end
      it do
        puts subject
        is_expected.to eq File.open('spec/sample_output/sample.html').read
      end
    end
  end
end
