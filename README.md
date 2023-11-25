# ImgToScript

## Introduction

**img_to_script** is a tool to convert images to executable scripts that plot the binary version of the image using the simple commands e.g. “draw a line”, “draw a dot”, etc..

The tool was initially developed to convert binary images to the build-in BASIC interpreter of the Soviet vintage portable computer **Elektronika MK90**. Yet it is possible to expand it to support other similar hardware and script languages (e.g. the build-in TI-BASIC on the Z80-based TI calculators).

![Elektronika MK90](/data/lain-mk90.jpg)

*Elektronika MK90 runs a BASIC program that was generated from an image by the **img_to_script** tool.*

## Installation

Add this line to your application's Gemfile:

```ruby
gem "img_to_script"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install img_to_script

## Modules

Four steps are required to complete the conversion. There’s a dedicated module for each step: 

- **Image processor** prepares the image for the conversion, e.g. scales the image down, converts it to a binary format, etc..

- **Generator** reads the image data and creates an array of the abstract tokens. Each token represents a simple command to the interpreter, e.g.: “draw a line”, “draw a dot”, etc..

- **Translator** is a mediator between a generator and a formatter. It translates abstract tokens to the specific statements of the target programming language. Translator chooses keywords, separators and handles other syntax issues.

- **Formatter** takes input from the translator and formats it into the executable script (a target language code). It can serve a function of a prettier or a minificator. Another common formatter’s task is to track down and to label BASIC line numbers.

## Usage

1. Read an image:

```ruby
image = Magick::BinMagick::Image.from_file("my_file.png")
```

2. Create a generator instance. You can also provide options via a configuration block:

```ruby
generator = ImgToScript::Generators::RunLengthEncoding::Horizontal.new.configure do |config|
  config.x_offset = -10
  config.y_offset = 15
  # etc.
end
```

3. Create an image processor instance, e.g.:

```ruby
image_processor = ImgToScript::ImageProcessors::ForceResizeAndToBinary.new
```

4. Create a translator instance, e.g.:

```ruby
translator = ImgToScript::Languages::MK90Basic::Translators::MK90Basic10.new
```

5. Create a formatter instance. You can also provide options via a configuration block:

```ruby
formatter = ImgToScript::Languages::MK90Basic::Formatters::Minificator.new.configure do |config|
  config.line_offset = 10
  config.line_step = 5
  config.max_chars_per_line = 60
  # etc.
end
```

6. Create a task instance and pass created instances as the task’s dependencies:

```ruby
task = ImgToScript::Task.new(
  generator: generator,
  image_processor: image_processor,
  translator: translator,
  formatter: formatter
)
```

Note that you can also provide your own custom objects as long as they respond to the required public interface.

In case of the Elektronika MK90 BASIC you can omit any dependency (i.e. skip any step from the 2nd to the 5th), since these are optional arguments. When a default object with a default configuration will be used.

You can also re-configure any dependency of an existing task object, e.g.:

```ruby
task.formatter.configure do |config|
  # your config...
end
```

7. Run conversion to get a script. You need to provide the image and the target device resolution:

```ruby
script = task.run(
  image: image,
  scr_width: 120,
  scr_height: 64
)
```

## Build-in objects

### Image processors

- **ImgToScript::ImageProcessors::ImageProcessor**

   Base class all image processors inherit from.

   **Public interface**: #call(image:, scr_width:, scr_height:, **kwargs)

- **ImgToScript::ImageProcessors::ForceResizeAndToBinary**

   Forcibly crops image to the provided dimensions, forcibly converts image to a binary format.

- **ImgToScript::ImageProcessors::PassAsIs**

   Returns unedited image. This is useful when the image is already complies with the hardware restrictions.

### Generators

- **ImgToScript::Generators::Generator**

   Base class all generators inherit from.

   **Public interface**: #generate(image:, scr_width:, scr_height:)

   **Configuration options**:

   - x_offset, default: 0

      Offset the X point on the screen.

   - y_offset, default: 0

      Offset the Y point on the screen.

   - clear_screen, default: true

      Add a statement to clear the screen at the begin of the script.

   - pause_program, default: true

      Add a statement to pause the program at the end of the script.

   - program_begin, default: false

      Add a statement that marks the begin of the program.

   - program_end, default: false

      Add a statement that marks the end of the program.

- **ImgToScript::Generators::HexMask::Default**

   Specific for the Elektronika MK90 BASIC.

   MK90's BASIC has a balanced build-in method to encode and render images. The Elektronika MK90's manual refer to it as the *hex-mask rendering* method. Each 8x1 px block of a binary image is being represented as a hex value (e.g. '00' for a tile of the 8 white pixels in a row, 'FF' for a tile of the 8 black pixels in a row, etc.). Then these hex values are being passed as arguments to the DRAM/M BASIC statement that renders the image according to the provided data.

   Due to the logic of the DRAM/M operator, only vertical scan lines are supported.

- **ImgToScript::Generators::HexMask::Enhanced**

   Specific for the Elektronika MK90 BASIC.

   Hex-mask encoding with modifications what make output BASIC code more compact.

   Due to the logic of the DRAM/M operator, only vertical scan lines are supported.

- **ImgToScript::Generators::RunLengthEncoding::Horizontal**

   RLE, horizontal scan lines.

- **ImgToScript::Generators::RunLengthEncoding::Vertical**

   RLE, horizontal vertical lines.

- **ImgToScript::Generators::Segmental::DirectDraw::Horizontal**

   Directly plot segments, horizontal scan lines.

- **ImgToScript::Generators::Segmental::DirectDraw::Vertical**

   Directly plot segments, vertical scan lines.

- **ImgToScript::Generators::Segmental::DataReadDraw::Horizontal**

   Store and read segments' coordinates, when use them to plot segments. Horizontal scan lines.

- **ImgToScript::Generators::Segmental::DataReadDraw::Vertical**

   Store and read segments' coordinates, when use them to plot segments. Vertical scan lines.

### Elektronika MK90 BASIC

#### Translators

- **ImgToScript::Languages::MK90Basic::Translators::Translator**

   Base class all MK90 translators inherit from.

   **Public interface**: #translate(abstract_tokens, **kwargs)

- **ImgToScript::Languages::MK90Basic::Translators::MK90Basic10**

   Translates abstract tokens to the MK90 BASIC v1.0 statements.

- **ImgToScript::Languages::MK90Basic::Translators::MK90Basic20**

   Translates abstract tokens to the MK90 BASIC v2.0 statements.

#### Formatters

- **ImgToScript::Languages::MK90Basic::Formatters::Formatter**

   Base class all MK90 formatters inherit from.

   **Public interface**: #format(tokens)

   **Configuration options**:

   - line_offset, default: DEF_LINE_OFFSET (1)

      First BASIC line number.

   - line_step, default: DEF_LINE_STEP (1)

      Step between two neighbor BASIC lines.

   - max_chars_per_line, default: MAX_CHARS_PER_LINE (80)

      Note: MK90 BASIC doesn’t accept more than 80 characters per line.

   - number_lines, default: true


- **ImgToScript::Languages::MK90Basic::Formatters::Minificator**

   The aim of the minificator is to make the output script as compact as possible, and so to save space at the MPO-10 cart.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/8bit-mate/img_to_script.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
