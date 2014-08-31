require 'thief/version'
require 'parallel'
require 'ruby-progressbar'

module Thief
  class << self
    def install
      gemfile = resolve_gemfile
      gems = parse_gemfile(gemfile)
      Parallel.map(gems, in_processes: cpu_count, progress: 'Getting gems') do |gem|
        install_gem(gem)
      end
    end

    private

    def install_gem(gem)
      cmd = "gem install #{gem[:gem]}"
      cmd << " -v '#{gem[:version]}'" if gem[:version]
      cmd << ' --no-verbose -q --no-rdoc --no-ri --conservative --minimal-deps'
      system cmd
    end

    def parse_gemfile(gemfile)
      result = []
      line_num = 0
      File.open(gemfile).each do |line|
        line_num += 1
        parse_line(result, line, line_num)
      end
      result
    end

    def parse_line(result, line, num)
      line = line.strip
      if line.include?(':path =>') || line.include?('path: ')
        puts "WARNING: Skipping local: #{line}"
        return
      end
      if line.include?('#')
        line, _ = line.split('#')
      end
      if line.start_with?('gem')
        gem, version = line.gsub(/['"]/, '').split(',')
        gem_def = { gem: gem.gsub(/^gem\s+/, '').strip }
        if version && version.include?('require')
          version.gsub!(/:?require.+/, '').strip
        end
        if version && version.strip.length > 0
          gem_def[:version] = version.strip
        end
        result << gem_def
      end
    rescue => e
      puts "WARNING: Could not parse line: #{num}: #{line}: #{e}"
    end

    def resolve_gemfile
      gemfile_path = ARGV[0] || 'Gemfile'
      if gemfile_path.start_with?('~') || gemfile_path.start_with?('/')
        gemfile = File.expand_path(gemfile_path)
      else
        gemfile = File.join(Dir.pwd, gemfile_path)
      end
      puts "Running thief install for: #{gemfile}"
      check_gemfile(gemfile)
      gemfile
    end

    def check_gemfile(gemfile)
      unless File.exist?(gemfile)
        puts 'Run thief in a directory that contains a Gemfile'
        exit 1
      end
    end

    def cpu_count
      case RbConfig::CONFIG['host_os']
      when /darwin9/
        `hwprefs cpu_count`.to_i
      when /darwin/
        ((`which hwprefs` != '') ? `hwprefs thread_count` : `sysctl -n hw.ncpu`).to_i
      when /linux/
        `cat /proc/cpuinfo | grep processor | wc -l`.to_i
      when /freebsd/
        `sysctl -n hw.ncpu`.to_i
      when /mswin|mingw/
        require 'win32ole'
        wmi = WIN32OLE.connect('winmgmts://')
        cpu = wmi.ExecQuery('select NumberOfCores from Win32_Processor')
        cpu.to_enum.first.NumberOfCores
      end
    end
  end
end
