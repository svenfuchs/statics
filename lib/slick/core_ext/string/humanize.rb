class String
  def humanize
    to_s.gsub(/_id$/, "").gsub(/_/, " ").capitalize
  end
end unless ''.respond_to?(:humanize)

