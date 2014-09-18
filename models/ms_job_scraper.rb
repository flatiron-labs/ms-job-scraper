class MsJobScraper

  attr_accessor :current_url_jid, :nokogirified_job_posting, :csv_file

  def initialize(beggining_url_jid)
    @current_url_jid = beggining_url_jid
    # @csv_file = CSV.new
    scrape
  end

  private

  def scrape
    @nokogirified_job_posting = visit_job_posting
    actual_opennings = 0
    while nokogirified_job_posting.url != nil
      if job_title != "This Job is no longer available."
        actual_opennings += 1
      end
      puts job_title
      @current_url_jid += 1
      @nokogirified_job_posting = visit_job_posting
    end
    puts "Total Openings: #{actual_opennings}" 
  end

  def visit_job_posting
    Nokogiri::HTML( open( job_url( current_url_jid ) ) )
  end

  def job_url(job_url_jid)
    # jID is not the same as the job ID
    "https://careers.microsoft.com/jobdetails.aspx?ss=&pg=0&so=&rw=1&jid=#{job_url_jid}&jlang=EN&pp=SS"
  end

  def job_title
    nokogirified_job_posting.css('span#ctl00_ContentPlaceHolder1_JobDetails2_lblJobTitleText').text
  end

end