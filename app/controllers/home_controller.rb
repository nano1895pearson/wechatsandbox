class HomeController < ApplicationController
  def index
  end

  def verify
    if verify_wechat_request
      @echo_str = params[:echostr]
    else
      @echo_str = ''
    end
  end

  private

  def verify_wechat_request
    require 'digest/sha1'

    signature = params[:signature]
    timestamp = params[:timestamp]
    nonce = params[:nonce]

    puts "signature -> #{signature}"
    puts "timestamp -> #{timestamp}"
    puts "nonce -> #{nonce}"

    token = "abcdefghijklmnop"

    tmp_str = [token, timestamp, nonce].sort.join
    puts "tmp_str -> #{tmp_str}"

    hash_str = Digest::SHA1.hexdigest tmp_str
    puts "hash_str -> #{hash_str}"

    puts "#{hash_str} = #{signature} -> #{hash_str == signature}"

    return hash_str == signature
  end
end
