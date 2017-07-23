module Concerns
  module CouponCampaignApiHelper
    extend ActiveSupport::Concern

    METHOD = {
      "create" => "alipay.marketing.campaign.cash.create",
      "trigger" => "alipay.marketing.campaign.cash.trigger",
      "detail" => "alipay.marketing.campaign.cash.detail.query",
      "modify" => "alipay.marketing.campaign.cash.status.modify",
      "list" => "alipay.marketing.campaign.cash.list.query"
    }

    RESPONSE = {
      "create" => "alipay_marketing_campaign_cash_create_response",
      "trigger" => "alipay_marketing_campaign_cash_trigger_response",
      "detail" => "alipay_marketing_campaign_cash_detail_query_response",
      "modify" => "alipay_marketing_campaign_cash_status_modify_response",
      "list" => "alipay_marketing_campaign_cash_list_query_response"
    }

    module ClassMethods
      # 接口创建红包活动
      def api_create(campaign)
        biz_content = {
          "coupon_name" => campaign.coupon_name,
          "prize_type" => "fixed",
          "total_money" => campaign.total_amount,
          "total_num" => campaign.total_num,
          "prize_msg" => campaign.prize_msg,
          "start_time" => campaign.begin_at.strftime("%F %T"),
          "end_time" => campaign.end_at.strftime("%F %T"),
          "send_freqency" => "L100"  #最大领取次数为100次
        }

        rsp = Alipay::CouponCampaign.execute(METHOD["create"], biz_content)[RESPONSE["create"]]
        { "is_success" => ("10000" == rsp["code"]), "rsp" => rsp  }
      end

      # 查看活动列表
      def api_list(camp_status = nil, page_index = nil, page_size = nil)
        biz_content = {
          "capm_status" => camp_status,
          "page_index" => page_index,
          "page_size" => page_size
        }

        rsp = Alipay::CouponCampaign.execute(METHOD["list"], biz_content)[RESPONSE["list"]]
        { "is_success" => ("10000" == rsp["code"]), "rsp" => rsp  }
      end
    end

    # 用创建好的红包活动发送红包给支付宝用户, 重复发送算失败
    def api_trigger(alipay_no, out_biz_no)
      biz_content = {
        "crowd_no" => self.crowd_no,
        "login_id" => alipay_no,
        "out_biz_no" => out_biz_no
      }

      rsp = Alipay::CouponCampaign.execute(METHOD["trigger"], biz_content)[RESPONSE["trigger"]]
      is_success = ("10000" == rsp["code"] && "false" == rsp["repeat_trigger_flag"])
      { "is_success" => is_success, "rsp" => rsp }
    end

    # 接口查询活动信息
    def api_detail
      biz_content = { "crowd_no" => self.crowd_no }
      rsp = Alipay::CouponCampaign.execute(METHOD["detail"], biz_content)[RESPONSE["detail"]]
      { "is_success" => ("10000" == rsp["code"]), "rsp" => rsp  }
    end

    # 修改活动状态
    def api_modify(status)
      biz_content = {
        "crowd_no" => self.crowd_no,
        "camp_status" => status
      }
      rsp = Alipay::CouponCampaign.execute(METHOD["modify"], biz_content)[RESPONSE["modify"]]
      { "is_success" => ("10000" == rsp["code"]), "rsp" => rsp  }
    end

  end
end

