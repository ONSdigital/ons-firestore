# frozen_string_literal: true

module ONSFirestore
  module Version
    MAJOR = 1
    MINOR = 1
    TINY  = 2
  end
  VERSION = [Version::MAJOR, Version::MINOR, Version::TINY].compact * '.'
end
