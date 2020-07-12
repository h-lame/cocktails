module FractionHelpers
  LOOKUP = {
    "\uF041" => "1/2",
    "\uF042" => "1/3",
    "\uF043" => "2/3",
    "\uF044" => "1/4",
    "\uF045" => "3/4",
    "\uF046" => "1/5",
    "\uF047" => "2/5",
    "\uF048" => "3/5",
    "\uF049" => "4/5",
    "\uF04A" => "1/6",
    "\uF04B" => "5/6",
    "\uF04C" => "1/8",
    "\uF04D" => "7/8",
    "\uF04E" => "3/8",
    "\uF04F" => "5/8",
    "\uF050" => "1/16",
    "\uF051" => "3/16",
    "\uF052" => "5/16",
    "\uF053" => "7/16",
    "\uF054" => "9/16",
    "\uF055" => "11/16",
    "\uF056" => "13/16",
    "\uF057" => "15/16"
  }

  def stringify_fractions(fraction_container)
    LOOKUP.inject(fraction_container) do |output, (fraction_unicode, fraction_string)|
      output.gsub(fraction_unicode, fraction_string)
    end
  end
end
