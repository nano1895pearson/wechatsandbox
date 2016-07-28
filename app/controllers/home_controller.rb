class HomeController < ApplicationController
  def index
  end

  def verify
    render plain: wechat_request_isvalid ? params[:echostr] : ''
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
end
