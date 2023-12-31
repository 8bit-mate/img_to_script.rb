# frozen_string_literal: true

module ImgToScript
  #
  # See https://dry-rb.org/gems/dry-system/main/container/
  #
  class Container < Dry::System::Container
    configure do |config|
      use :zeitwerk

      config.root = Pathname(__dir__).join("../../")

      config.component_dirs.add "lib" do |dir|
        dir.namespaces.add "img_to_script", key: nil
      end

      config.inflector = Dry::Inflector.new do |inflections|
        inflections.acronym("MK90")
      end
    end

    register("utils.logger", Logger.new($stdout, level: Logger::ERROR))

    add_to_load_path! "lib"
  end
end
