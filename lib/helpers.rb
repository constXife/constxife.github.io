module BlogHelpers
  def time_tag(date, msg)
    "<time datetime=\"#{date}\">#{msg}</time>"
  end
end
