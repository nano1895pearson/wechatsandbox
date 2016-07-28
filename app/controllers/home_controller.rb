class HomeController < ApplicationController
  require 'nokogiri'
  skip_before_action :verify_authenticity_token
  def index
    @signature = generate_signature
  end

  def get_verify
    render plain: wechat_requeset_isvalid ? params[:echostr] : ''
  end

  def post_verify
    xml = Nokogiri.XML(request.body.read)
    puts xml.inspect
    from = xml.xpath("//FromUserName").text
    to = xml.xpath("//ToUserName").text
    response = "<xml>" \
           "<ToUserName><![CDATA[#{from}]]></ToUserName>" \
           "<FromUserName><![CDATA[#{to}]]></FromUserName>" \
           "<CreateTime>#{Time.now.to_i}</CreateTime>" \
           "<MsgType><![CDATA[text]]></MsgType>" \
           "<Content><![CDATA[Hello]]></Content>" \
         "</xml>"
    render text: response
  end

  private

  def wechat_request_isvalid
    require 'digest/sha1'

    signature = params[:signature]
    timestamp = params[:timestamp]
    nonce = params[:nonce]
    token = "abcdefghijklmnop"
    tmp_str = [token, timestamp, nonce].sort.join
    hash_str = Digest::SHA1.hexdigest(tmp_str)
    hash_str == signature
  end

  def generate_signature
    require 'digest/sha1'
    # 1. Retrieve access token or get new one if current one expired
    # => GET https://api.wechat.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET
    # => access_token = response[:access_token]

    # 2. Obtain jsapi_ticket via HTTP GET method by using access_token obtained before
    # => GET https://api.wechat.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=jsapi.
    # => ticket = response[:ticket]

    # 3. Elements needed for signature generation
    # => 3a. Ticket generated from step 2
    # => 3b. Random string of length 16 (don't know if required but that was the length in the docs)
    # => 3c. Timestamp `Time.now.to_i`
    # => 3d. Current url (exluding fragment identifiers)

    # 4. Compose string to be hashed by sha1
    # => str = "jsapi_ticket=#{3a}&noncestr=#{3b}&timestamp#{3c}&url=#{3d}"

    # 5. Hash the string with sha1
    # => signature = Digest::SHA1.hexdigest(str)

    # 6. Variables needed for wx config
    # => 6a. timestamp
    # => 6b. noncestr
    # => 6c. signature

    ticket = 'kgt8ON7yVITDhtdwci0qeb-3YzH5dopFzTn8duKXpNV8dG0bu-eW_JQJnn1Ry6WpkL6Iwc3Vj7w6S5cYedXrhg'
    noncestr = 'abcdefgh'
    timestamp = "1469732684"
    url = 'http://wechatsandbox.herokuapp.com'

    str = "jsapi_ticket=#{ticket}&noncestr=#{noncestr}&timestamp#{timestamp}&url=#{url}"
    signature = Digest::SHA1.hexdigest(str)
  end
end
