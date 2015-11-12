module SemanticRange
  VERSION = "0.1.0"

  class Version
    def initialize(version, loose)
      @raw = version
      @loose = loose

      match = version.strip.match(loose ? LOOSE : FULL)

      # TODO error handling

      @major = match[1].to_i
      @minor = match[2].to_i
      @patch = match[3].to_i

      # TODO error handling

      if !match[4]
        @prerelease = []
      else
        @prerelease = match[4].split('.').map do |id|
          if /^[0-9]+$/.match(id)
            num = id.to_i
            # TODO error handling
          else
            id
          end
        end
      end

      @build = match[5] ? match[5].split('.') : []
      @version = format
    end

    def version
      @version
    end

    def major
      @major
    end

    def minor
      @minor
    end

    def patch
      @patch
    end

    def format
      v = "#{@major}.#{@minor}.#{@patch}"
      if @prerelease.length > 0
        v += '-' + @prerelease.join('.')
      end
      v
    end

    def to_s
      @version
    end

    def compare(other)
      other = Version.new(other, @loose) unless other.is_a?(Version)
      compare_main(other) || compare_pre(other)
    end

    def compare_main(other)
      other = Version.new(other, @loose) unless other.is_a?(Version)
      compare_identifiers(@major, other.major) || compare_identifiers(@minor, other.minor) || compare_identifiers(@patch, other.patch)
    end

    def compare_pre(other)
      other = Version.new(other, @loose) unless other.is_a?(Version)

      return -1 if @prerelease.any? && !other.prerelease.any?
      return 1 if !@prerelease.any? && other.prerelease.any?
      return 0 if !@prerelease.any? && !other.prerelease.any?

      i = 0
      while true
        a = @prerelease[i]
        b = other.prerelease[i]

        if a.nil? && b.nil?
          return 0
        elsif b.nil?
          return 1
        elsif a.nil?
          return -1
        elsif a == b
          i += 1
        else
          return compareIdentifiers(a, b)
        end
      end
    end

    def compare_identifiers(a,b)
      anum = /^[0-9]+$/.match(a)
      bnum = /^[0-9]+$/.match(b)

      if anum && bnum
        a = a.to_i
        b = b.to_i
      end

      return (anum && !bnum) ? -1 :
             (bnum && !anum) ? 1 :
             a < b ? -1 :
             a > b ? 1 :
             0;
    end
  end
end