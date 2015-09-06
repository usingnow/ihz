require 'builder'

class FreeInsurance < ActiveRecord::Base
  validates_presence_of :user, :mobile, :id_num
  validates_length_of :mobile, is: 11, message: "需填写11位手机号，无需0086或者+86。"
  validates_uniqueness_of :mobile, message: "该手机已经领取过，请核实，谢谢。"
  validates_format_of :mobile, with: /^0?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$/, :multiline => true, message: "请确保您填写是有效手机号码。"
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :multiline => true, message: "请填写有效邮件地址。"

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
  def self.build_xml_of_free_insurance(fi)
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
            xml.Code ''
          }
          xml.TSR {
            xml.Code '805095'
          }
          xml.DonateTime fi.created_at
          xml.SMS '1'
          xml.FlightNo
          xml.ValidTime
        }
      }
    }

    return xml
  end

  # Send the xml via SOAP
  def self.send_to_metlife(fi)
    # Connect to MetLife SOAP API via wsdl.
    client = Savon::Client.new(wsdl: "http://icare-uat.metlife.com.cn/services/YSW2ICareSave?wsdl")
    msg = FreeInsurance.build_xml_of_free_insurance(fi)
    puts '-----'
    puts msg
    puts '-----'
    response = client.call(:do_request, xml: msg)

    return response
  end
end
