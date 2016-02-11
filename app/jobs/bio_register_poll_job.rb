# polls authentify until out-of-band registration is no longer in progress
class BioRegisterPollJob
  attr_reader :poll, :teid

  @queue = :bio_register_polling

  def self.perform(opts)
    BioRegisterJob.new(opts).perform
  end

  def initialize(opts = {})
    @options = opts
    raise 'missing parameter teid' unless @options.key? :teid
    raise 'missing parameter endpoint' unless @options.key? :endpoint
    raise 'missing service type' unless @options.key? :service_type
    @teid = @options[:teid]
    @endpoint = @options[:endpoint]
    @application = @options[:service_type]
    self
  end

  def perform
    @poll = Authentify::CallFlow::Poll.new teid: @teid,
                                           endpoint: @endpoint,
                                           service_type: @application
    wait_for_result
    @poll
  end

  def wait_for_result
    poll_request = lambda do
      @poll.submit_request
      @poll
    end

    sleep(5) while poll_request.call.status_code == '7000'

    @poll
  end

  def status_text
    @poll.try(:status_text)
  end

  def status_code
    @poll.try(:status_code)
  end
end
