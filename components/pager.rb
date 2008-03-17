class Pager

  def initialize params, results, params_key = :id, actual_page = nil, results_per_page = 10
    @params = params
    @results = results
    @params_key = params_key
    @actual_page = actual_page.nil? ? @params[params_key] : actual_page.to_i
    @results_per_page = results_per_page  
  end
  
  def params_key
    @params_key
  end
  
  def count
      (@results.length.to_f / @results_per_page.to_f).ceil    
  end
  
  def array_of_pages page_number = nil, pages_padding = 1
    if page_number.nil?
      page_number = actual_page
    end
    number_of_pages = count
    # and here goes a magic formula... :-)
    pages_array = (
      ((page_number - pages_padding)..(page_number + pages_padding)).to_a +
      ((number_of_pages - pages_padding)..number_of_pages).to_a +
      (1..(1 + pages_padding)).to_a
    ).uniq.sort.delete_if { |x| x > number_of_pages or x < 1 }
    pages_array.insert(1 + pages_padding, '...') if (page_number - pages_padding) > (pages_padding + 2)
    pages_array.insert(-pages_padding - 2, '...') if (number_of_pages - pages_padding) > (pages_padding + page_number + 1)
    return pages_array
  end
  
  def last_page
    (((actual_page - 1 ) * 10 + 10) - 1) > results_count ? results_count : (((actual_page - 1 ) * 10 + 10) - 1)
  end
  
  def results
    @results[((actual_page - 1) * 10)..last_page]
  end
  
  def all_results
    @results
  end
  
  def results_count
    @results.length
  end
  
  def results_range separator = ' - '
    [((actual_page - 1) * 10) + 1, last_page].join separator
  end
  
  def actual_page
    check_page @actual_page
  end
  
  def next_page
    check_page(@actual_page + 1)
  end

  def previous_page
    check_page(@actual_page - 1)
  end
  
  def check_page page
    ((page.to_i < 1 or 
     page.to_i > count
    ) ? 1 : page).to_i
  end
  
  def url_for_page page = nil
    page = page.nil? ? actual_page : page
    @params[@params_key] = page
    @params
  end
  
  def url_for_next_page
    url_for_page check_page(actual_page + 1)
  end

  def url_for_previous_page
    url_for_page check_page(actual_page - 1)
  end
  
  def first_page?
    actual_page == 1
  end
  
  def last_page?
    actual_page == count
  end
  
end
