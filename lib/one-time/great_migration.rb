require 'watir-webdriver'

module GreatMigration
  extend self

  START_URL = 'http://www.wigbate.com/1---joker.html'

  def run
    browser = Watir::Browser.start(START_URL)

    i = 0 # TODO: Remove
    # while(true) # TODO: Not this
    while(i < 3)
      import_post!(browser)

      next_link = browser.span(text: 'NEXT').try(:parent)
      break unless next_link
      next_link.click # Loads new browser page
      i += 1
    end

    puts "Done!"
  end

  # def copy_comments
  #   browser = Watir::Browser.start(START_URL)

  #   comment_divs = browser.divs(class: 'comment')

  # end

  private

  def import_post!(browser)
    url = browser.url
    puts "Copying #{url}..."
    page = Nokogiri::HTML.parse(browser.html)

    Post.create!(
      title: page_title(page),
      slug: page_slug(url),
      remote_comic_url: comic_image_url(page, browser)
    )

    # TODO: Import comments
  rescue => e
    debugger
    puts "WHY"
  end

  def comic_image_url(page, browser)
    comic_url = page.css('img').map{|img| img['src']}.find do |url| url.start_with?('/uploads/') && !url.end_with?('1427127701.png') end
    return "http://www.wigbate.com#{comic_url}" if comic_url

    # else, have to find it through background image
    # E.g., "url(\"http://www.wigbate.com/uploads/1/2/4/3/12434276/header_images/1390837983.jpg\")"
    image_css = browser.div(class: 'wsite-header').style('background-image')
    if image_css and m = image_css.match(/(http:\/\/www\.wigbate\.com\/uploads.+\.jpg)/)
      return m[1]
    end

    debugger
    puts "Where is the comic???"
  end

  def page_title(page)
    page.css('title').text
      .sub(/\d+ - /, '')
      .sub(' - wigbate - updated triweekly','')
  end

  def page_slug(url)
    url.sub("http://www.wigbate.com/",'')
  end

  # Mechanize
  # def import_post!(page)
  #   post = Post.create!(
  #     title: page_title(page),
  #     slug: page.uri.to_s.sub("http://www.wigbate.com/",''),
  #     remote_comic_url: comic_image_url(page)
  #   )
  # rescue => e
  #   debugger
  #   puts "WHY"
  # end

  # Mechanize
  # def comic_image_url(page)
  #   # If it has div.wsite-image, use the inner img src
  #   comic_url = page.image_urls.map(&:to_s).find do |url|
  #     url.start_with?('http://www.wigbate.com/uploads/') && !url.end_with?('1427127701.png')
  #   end
  #   return comic_url if comic_url
  # end

  # E.g., "1 - Joker - wigbate - updated triweekly"
  # Mechanize
  # def page_title(page)
  #   page.title.to_s
  #     .sub(/\d+ - /, '')
  #     .sub(' - wigbate - updated triweekly','')
  # end

  # Mechanize
  # def run
  #   mechanize = Mechanize.new
  #   mechanize.history_added = Proc.new { sleep 0.5 } # rate limiting
  #   page = mechanize.get(START_URL)

  #   # Go through them and copy 'em
  #   i = 0
  #   while(page)
  #     i += 1
  #     puts "Copying #{page.uri}..."
  #     import_post!(page)
  #     next_link = page.links.find{|link| link.text == "\r\nNEXT\r\n"}
  #     page = next_link.try(:click)
  #     break if i >= 10 # TODO: Remove
  #   end
  #   puts "Done!"
  # end
end