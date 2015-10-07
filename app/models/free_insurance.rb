require 'builder'

class FreeInsurance < ActiveRecord::Base
  belongs_to :preorder


  validates_presence_of :user, :mobile, :id_num
  validates_length_of :mobile, is: 11, message: "需填写11位手机号，无需0086或者+86。"
  validates_uniqueness_of :mobile, message: "此手机已经领取过，请核实，谢谢。"
  validates_uniqueness_of :id_num, message: "此身份证已经领取过，请核实，谢谢。"
  validates_format_of :mobile, with: /^0?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$/, :multiline => true, message: "请确保您填写是有效手机号码。"
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :multiline => true, message: "请填写有效邮件地址。"
  validates_acceptance_of :all_terms, message: "请确认已经充分理解保险须知和条款。"

  private

  def self.search(user, mobile)
    if user&&mobile
      where(['user = ? AND mobile = ?', user.to_s, mobile.to_s])
    end
  end

  # To go MetLife API. It is SOAP WLD driver.

  # Generate user's birthday from ID card number. Temporarily No need.
  def birthday_from_id_card(fi)

  end

  # Generate the id to align MetLife API Key
  def self.generate_free_insurance_id
    return 'AiShanXing' + DateTime.current.in_time_zone('Beijing').to_s(:number) + ('0'..'9').to_a.shuffle[0..3].join
  end

  # Build xml file.
  def self.build_xml_of_free_insurance(fi, present_code)
    data = ''
    xml = ::Builder::XmlMarkup.new(target: data, indent: 0)
    # xml.instruct!
    xml.instruct! :xml, version: "1.0", encoding: "GBK"
    xml.Records {
      xml.Record {
        xml.Customer {
          xml.Key FreeInsurance.generate_free_insurance_id
          xml.FromSystem 'AiShanXing'
          xml.Name fi.user
          xml.Sex fi.gender ? 'Male' : 'Female'
          xml.Birthday fi.birthday.to_s
          xml.Document fi.id_num
          xml.DocumentType fi.id_type
          xml.Email fi.email
          xml.Mobile fi.mobile
          xml.ContactState {
            xml.Name fi.province
          }
          xml.ContactCity {
            xml.Name fi.city
          }
          xml.ContactAddress fi.address
          xml.Occupation {
            xml.Code '0001001'
          }
          xml.Description
        }
        xml.Task {
          xml.CallList {
            xml.Name ''
          }
          xml.Campaign {
            xml.Name ''
          }
        }
        xml.Activity {
          xml.Code ''
          xml.Present {
            xml.Code present_code
          }
          xml.TSR {
            xml.Code '805095'
          }
          xml.DonateTime Date.current.to_s(:db)
          xml.SMS '1'
          xml.FlightNo
          xml.ValidTime
        }
      }
    }

    return data
  end

  # Send the xml via SOAP
  def self.send_to_metlife(fi)
    pc = Array['PC0000000139', 'PC0000000151', 'PC0000000150', 'PC0000000167']
    # Connect to MetLife SOAP API via wsdl.
    client = Savon.client(wsdl: "http://icare.metlife.com.cn/services/YSW2ICareSave?wsdl", encoding: "GBK")
    
    msg = Hash.new

    pc.each do |present_code|
      msg[present_code] = FreeInsurance.build_xml_of_free_insurance(fi, present_code)
    end

    # # Debug the API performance.
    # puts 'XXXXXXXXXXXXXXXXXX'
    # msg.each do |m|
    #   puts m
    # end
    # puts 'XXXXXXXXXXXXXXXXXX'

    response = Hash.new
    
    msg.each do |key, message|
      response[key] = client.call(:do_request, message: { xml_input: message })
    end

    # # Debug the API performance.
    # puts 'XXXXXXXXXXXXXXXXXX'
    # response.each do |r|
    #   puts r
    # end
    # puts 'XXXXXXXXXXXXXXXXXX'

    return response
  end

  def self.response_from_metlife(response)
    if response.nil?
      return nil
    else
      result = Hash.new
      response.each do |key, response|
        response_body = Nokogiri::XML(response.hash[:envelope][:body][:do_request_response][:do_request_return])
        result[key] = [response_body.xpath("//FreeInsureNo").text]
      end
    end

    return result
  end
end
