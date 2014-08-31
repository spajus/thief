require 'thief/version'
require 'parallel'
require 'ruby-progressbar'

module Thief
  class << self
    def install
      gemfile = resolve_gemfile
      gems = parse_gemfile(gemfile)
      if gems.size > 0
        puts "Getting #{gems.size} missing gems"
        Parallel.map(gems, in_processes: cpu_count, progress: 'Getting missing gems') do |gem|
          install_gem(gem)
        end
      else
        puts 'You have all the gems you need'
      end
    end

    private

    def install_gem(gem)
      cmd = ''
      cmd << 'yes | ' if system 'yes | echo 1'
      cmd = "gem install #{gem[:gem]}"
      cmd << " -v '#{gem[:version]}'" if gem[:version]
      cmd << ' --no-verbose -q --no-rdoc --no-ri --conservative --minimal-deps'
      system cmd
    end

    def parse_gemfile(gemfile)
      missing = `bundle check --gemfile=#{gemfile}`
      gems = missing.split("\n").map(&:strip).select { |l| l.start_with?('*') }
      result = []
      gems.map do |gem|
        gem, version = gem.gsub('* ', '').split(' (')
        result << { gem: gem, version: version.gsub(')', '') }
      end
      result
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
      return if File.exist?(gemfile)
      puts 'Run thief in a directory that contains a Gemfile'
      exit 1
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
