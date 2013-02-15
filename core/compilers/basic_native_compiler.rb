require 'open3'
require 'fileutils'

module BasicNativeCompiler
  include Compiler

  private

  @tmp_dir_location = File.join File.dirname(__FILE__), '../tmp/'

  def prepare_compile_command(source_file, destination)
    @compiler_command_options.map do |option|
      option.gsub /%SOURCE%|%DESTINATION%/,
        '%SOURCE%' => source_file.path, '%DESTINATION%' => destination
    end
  end

  def create_command(executable)
    executable.to_s
  end

  def create_runnable(command, destination)
    Runnable.new command, File.dirname(destination)
  end

  def prepare_executable
    executable = Random.new(Time.now.to_i).rand.to_s
    return File.join(create_directory, executable), executable
  end

  def create_directory
    directory = File.join @tmp_dir_location, "#{Time.now.to_i}_#{Process.pid}"
    if File.exists? directory
      raise CompilationError, "Destination directory already exists."
    else
      FileUtils.mkdir_p directory
    end
    File.absolute_path directory
  end
end