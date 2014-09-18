require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pry'

class MsJobScraper

  attr_reader :ending_url_jid
  attr_accessor :current_url_jid, :current_job_posting, :csv_file

  def initialize(beggining_url_jid, ending_url_jid)
    @current_url_jid = beggining_url_jid
    @ending_url_jid = ending_url_jid
    @csv_file = 
  end

  private

  def scrape
    @current_job_posting = visit_job_posting
    current_job_posting.
  end

  def visit_job_posting
    Nokogiri::HTML( open( job_url( current_url_jid ) ) )
  end

  def job_url(job_url_jid)
    # jID is not the same as the job ID
    "https://careers.microsoft.com/jobdetails.aspx?ss=&pg=0&so=&rw=1&jid=#{job_url_jid}&jlang=EN&pp=SS"
  end

  def job_title
    
  end

end