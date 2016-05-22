require 'watir-webdriver'

module GreatMigration
  extend self

  START_URL = 'http://www.wigbate.com/1---joker.html'

  # TODO: Figure out multi-image posts (e.g., 'http://www.wigbate.com/458---462---pigs-1-7.html')

  def run
    original_logger_level = Rails.logger.level
    Rails.logger.level = :warn

    browser = Watir::Browser.start(START_URL)

    while(true) # TODO: Not this
      import_post!(browser)

      next_link = browser.span(text: 'NEXT').try(:parent)
      break unless next_link
      next_link.click # Loads new browser page
    end

    puts "Done!"
  ensure
    Rails.logger.level = original_logger_level
  end

  private

  def import_post!(browser)
    url = browser.url
    page = Nokogiri::HTML.parse(browser.html)
    puts "Copying #{url}..."

    post = Post.create!(
      title: page_title(page),
      slug: page_slug(url),
      description: comic_description(page),
      remote_comic_url: comic_image_url(page, browser)
    )

    import_comments!(post, page)
  end

  def import_comments!(post, page)
    comments = page.css('div#comments_list').css('div.comment')
    puts "Importing #{comments.size} comments..."

    comments.each do |comment|
      post.comments.create!(
        author: comment.css('span.author b').text.strip,
        body: comment.css('blockquote').text.strip,
        created_at: comment_date(comment)
      )
    end
  end

  def comic_description(page)
    description = page.css('.wsite-image').css('div').last.text
    description if description.present?
  end

  def comment_date(comment) # E.g., (Feb 27, 2013)
    Date.parse(comment.css('span.date').text)
  end

  def comic_image_url(page, browser)
    comic_url = page.css('img').map{|img| img['src']}.find do |url| url.start_with?('/uploads/') && !url.end_with?('1427127701.png') end
    return "http://www.wigbate.com#{comic_url}" if comic_url

    # ... or, have to find it through background image
    # E.g., "url(\"http://www.wigbate.com/uploads/1/2/4/3/12434276/header_images/1390837983.jpg\")"
    image_css = browser.div(class: 'wsite-header').style('background-image')
    image_css.match(/(http:\/\/www\.wigbate\.com\/uploads.+\.jpg)/)[1]
  end

  def page_title(page)
    page.css('title').text
      .sub(/\d+ - /, '')
      .sub(' - wigbate - updated triweekly','')
  end

  def page_slug(url)
    url.sub("http://www.wigbate.com/",'')
  end
end