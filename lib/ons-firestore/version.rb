# frozen_string_literal: true

module ONSFirestore
  module Version
    MAJOR = 1
    MINOR = 3
    TINY  = 0
  end
  VERSION = [Version::MAJOR, Version::MINOR, Version::TINY].compact * '.'
end
