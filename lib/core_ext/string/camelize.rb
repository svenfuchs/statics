class String
  def camelize
    to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  end
end unless ''.respond_to?(:camelize)
