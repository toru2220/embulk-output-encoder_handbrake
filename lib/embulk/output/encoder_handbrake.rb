module Embulk
  module Output

    class EncoderHandbrake < OutputPlugin
      Plugin.register_output("encoder_handbrake", self)
      
      require 'open3'
      require 'fileutils'

      def self.transaction(config, schema, count, &control)
        # configuration code:
        task = {
          "command" => config.param("command", :string, default: "/usr/bin/HandBrakeCLI"), 
          "option" => config.param("option", :string, default: "--all-audio --all-subtitles -O --pfr -E copy:mp3 -B 128 -6 -X 512 -Y 288 --h264-profile baseline --h264-level 3.0 -q 24.0"),
          "filename" => config.param("filename", :string, default: "filename"),  
          "outputext" => config.param("outputext", :string, default: "mp4"),
          "outputdir" => config.param("outputdir", :string),
          "successful" => config.param("successful", :string),
          "failure" => config.param("failure", :string),
          "run" => config.param("run", :string, default: ""),
          "limit" => config.param("limit", :integer, default: 99999),
          "useffmpeg" => config.param("useffmpeg", :string, default: ""),
        }

        # resumable output:
        # resume(task, schema, count, &control)

        # non-resumable output:
        task_reports = yield(task)
        next_config_diff = {}
        return next_config_diff
      end

      # def self.resume(task, schema, count, &control)
      #   task_reports = yield(task)
      #
      #   next_config_diff = {}
      #   return next_config_diff
      # end

      def init
        # initialization code:
        @command = task["command"]
        @option = task["option"]
        @outputdir = task["outputdir"]
      end

      def close
      end

      def add(page)
        
        command = @task[:command]   
        option = @task[:option]    
        outputdir = @task[:outputdir]
        outputext = @task[:outputext]
        filename_column = @task[:filename]
        successful = @task[:successful]
        failure = @task[:failure]
        run = @task[:run]
        limit = @task[:limit]
        useffmpeg = @task[:useffmpeg]
     
        # output code:
        page.each_with_index do |record,i|
          
          puts "record count:%s" % i
          if i >= limit then
            puts "encode limit(%d). exit done." % limit
            break
          end
          
          puts "filename_column:%s" % filename_column
   
          hash = Hash[schema.names.zip(record)]
          originalfile = hash[filename_column]
          
          puts "originalfile:%s" % originalfile
          
          basename = File.basename(originalfile, ".*")
          output = [basename,outputext].join(".")
          
          outputfile = File.join(outputdir, output)
          successfulfile = File.join(successful, File.basename(originalfile))
          failurefile = File.join(failure, File.basename(originalfile))

          puts originalfile
          puts outputfile

          encode_command = ""

          if useffmpeg == "" then
            
            encode_command = [command,"-i","\"%s\"" % originalfile,option,"-o","\"%s\"" % outputfile].join(" ")
          
          else
            
            encode_command = [command,"-i","\"%s\"" % originalfile,option,"\"%s\"" % outputfile].join(" ")
          
          end
          
          puts "encode-command:%s" % encode_command
 
          if run == "" then
            puts "encoded skipped. reason:dry run mode"
            next
          end
          
          begin

            FileUtils.mkdir_p(File.dirname(outputfile))
            
            Open3.popen3(encode_command) do |stdin, stdout, stderr, wait_thr|
              puts stdout.read
              puts stderr.read
            end        

            FileUtils.mkdir_p(File.dirname(successfulfile))
            FileUtils.mv(originalfile, successfulfile)  
            
            puts "successful encoded:encode %s to %s" % [originalfile,outputfile]
            puts "move original file:move %s to %s" % [originalfile,successfulfile]
            
          rescue => error
          
            FileUtils.mkdir_p(File.dirname(failurefile))
            FileUtils.mv(originalfile, failurefile)
            
            puts "failure encoded:move %s to %s" % [originalfile,failurefile]
            puts error

          end          
    
        end
      end

      def finish
      end

      def abort
      end

      def commit
        task_report = {}
        return task_report
      end
    end

  end
end
