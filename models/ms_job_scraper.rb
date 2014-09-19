class MsJobScraper
  attr_reader :last_known_url_jid
  attr_accessor :current_url_jid, :nokogirified_job_posting, :csv_file

  def initialize(beggining_url_jid, last_known_url_jid=160500)
    @current_url_jid = beggining_url_jid
    @last_known_url_jid = last_known_url_jid
    create_new_csv
  end

  def scrape
    @nokogirified_job_posting = visit_job_posting
    actual_opennings = 0
    while more_jobs?
      if job_we_want?
        job_info_arr = [
          job_title,
          job_category,
          job_division,
          job_product,
          job_location[0],
          job_location[1],
          job_location[2],
          job_description,
          job_url(current_url_jid),
          job_id
        ]
        csv_file << job_info_arr 
        actual_opennings += 1 #extraneous
        puts "Current Job: #{job_title}" #extraneous
      end
      puts "Current Job ID: #{current_url_jid}" #extraneous
      @current_url_jid += 1
      @nokogirified_job_posting = visit_job_posting
    end
    puts "Total Openings: #{actual_opennings}" #extraneous
  end

  private

  def create_new_csv
    @csv_file = CSV.open("ms-job-listings-#{Time.now}.csv", "wb")
    @csv_file << ["Title", "Category", "Division", "Product", "Country", "State", "City", "Description", "URL", "Job ID"]
  end

  def more_jobs?
    current_url_jid <= last_known_url_jid ||
      nokogirified_job_posting.url ||
        visit_job_posting(current_url_jid + 1).url ||
          visit_job_posting(current_url_jid + 3).url ||
            visit_job_posting(current_url_jid + 7).url || 
              visit_job_posting(current_url_jid + 11).url ||
                visit_job_posting(current_url_jid + 13).url
  end

  def job_we_want?
    job_title != "This Job is no longer available." && 
      nokogirified_job_posting.url && 
        job_location.include?("United States") &&
          job_category.include?("Software")
  end

  def visit_job_posting(jid = nil)
    Nokogiri::HTML( open( job_url( jid || current_url_jid ) ) )
  end

  def job_url(job_url_jid)
    # jID is not the same as the job ID
    "https://careers.microsoft.com/jobdetails.aspx?ss=&pg=0&so=&rw=1&jid=#{job_url_jid}&jlang=EN&pp=SS"
  end
  
  def nokogiri_job_detail_text_selector(css_id_sub_text)
    node_arr = nokogirified_job_posting.css("span#ctl00_ContentPlaceHolder1_JobDetails2_lbl#{css_id_sub_text}Text")
    if !node_arr.empty?
      node_arr.text
    else
      "N/A"
    end
  end

  def job_title
    nokogiri_job_detail_text_selector('JobTitle')
  end

  def job_id
    nokogiri_job_detail_text_selector('JobCode')
  end

  def job_location
    nokogiri_job_detail_text_selector('Location').split(", ")
  end

  def job_category
    nokogiri_job_detail_text_selector('JobCategory')
  end

  def job_product
    nokogiri_job_detail_text_selector('JobProduct')
  end

  def job_division
    nokogiri_job_detail_text_selector('JobDivision')
  end

  def job_description
    nokogirified_job_posting.css("div.jobDetails_jobDesc").text.scan(/qualification.+/i).first
  end


end
















