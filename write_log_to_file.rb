def log(body)
  logger = ActiveSupport::Logger.new('log/code.log')
  logger.info body
end
