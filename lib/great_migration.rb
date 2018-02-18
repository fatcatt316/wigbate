require 'watir'

module GreatMigration
  extend self

  START_URL = 'https://www.wigbate.com/1---joker.html'
  HEADER_IMAGE = '1427127701.png'

  def run(start_url: START_URL, limit: nil)
    original_logger_level = Rails.logger.level
    Rails.logger.level = :warn
    import_count = 0

    browser = Watir::Browser.start(start_url)

    while(true) # TODO: Not this
      break if limit && import_count > limit
      import_post!(browser)

      next_link = browser.span(text: 'NEXT').try(:parent)
      break unless next_link
      import_count += 1
      next_link.click # Loads next page
    end

    puts 'Done!'
  ensure
    Rails.logger.level = original_logger_level
  end

  private def import_post!(browser)
    url = browser.url
    page = Nokogiri::HTML.parse(browser.html)
    puts "Copying #{url}..."

    post = Post.create!(
      title: page_title(page),
      slug: page_slug(url),
      description: comic_description(page),
      remote_comics_urls: comic_image_urls(page, browser)
    )

    import_comments!(post, page)
  end

  private def import_comments!(post, page)
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

  private def comic_description(page)
    page.css('.wsite-image').css('div').last&.text
  end

  private def comment_date(comment) # E.g., (Feb 27, 2013)
    Date.parse(comment.css('span.date').text)
  end

  private def comic_image_urls(page, browser)
    urls = page.css('img')
      .map { |img| "https://www.wigbate.com#{img['src']}" if valid_comic_url?(img['src']) }
      .compact

    urls + background_image_urls(browser)
  end

  # Add images from background
  # E.g., "url(\"http://www.wigbate.com/uploads/1/2/4/3/12434276/header_images/1390837983.jpg\")"
  private def background_image_urls(browser)
    image_css = browser.div(class: 'wsite-header').style('background-image')
    if image_css == 'none'
      []
    else
      [image_css.match(/(https:\/\/www\.wigbate\.com\/uploads.+\.jpg)/)[1]]
    end
  end

  private def page_title(page)
    page.css('title').text
      .sub(/\d+ - /, '')
      .sub(' - wigbate - updated triweekly','')
  end

  private def page_slug(url)
    url.sub('https://www.wigbate.com/', '')
  end

  private def valid_comic_url?(url)
    url.start_with?('/uploads/') && !url.end_with?(HEADER_IMAGE)
  end
end