require 'test/unit'
require 'tmpdir'

require 'rubygems'
require 'gd2-ffij'

require './test/test_helper'

class ImageTest < Test::Unit::TestCase
	include TestHelper

	def test_image_new_and_release
		img = Gd2::Image.new(50, 50)
	end

	def test_image_true_color_new_and_release
		img = Gd2::Image::TrueColor.new(50, 50)
	end

	def test_image_indexed_color_new_and_release
		img = Gd2::Image::IndexedColor.new(50, 50)
	end

	[ :png, :gif, :jpg, :wbmp, :gd2 ].each do |ext|
		self.class_eval(<<-EOF)
			def test_load_#{ext}_from_file
				img = Gd2::Image.load(File.open(File.join(PATH_TO_IMAGES, 'test.#{ext}')))
			end

			def test_load_#{ext}_from_string
				img = Gd2::Image.load(File.read(File.join(PATH_TO_IMAGES, 'test.#{ext}')))
			end
		EOF
	end

	# TODO: add xbm, xpm and wbmp tests
	[ :png, :gif, :jpg, :gd, :gd2 ].each do |ext|
		self.class_eval(<<-EOF)
			def test_import_#{ext}_from_file
				img = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
			end

			def test_export_#{ext}
				img = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.gd2'))
				out = File.join(Dir.tmpdir, 'test.#{ext}')
				img.export(out)

				assert(File.exists?(out))

				imgA = Gd2::Image.import(out)
				imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))

				assert(imgA == imgB)

				File.unlink(out)
			end

			def test_compare_#{ext}
				imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				assert_equal(imgA.compare(imgB), 0)
				assert_equal(imgA.compare(imgA.dup), 0)
			end

			def test_eqeq_#{ext}
				imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				assert(imgA == imgB)
				assert(imgA == imgA.dup)
			end

			def test_height_#{ext}
				img = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				assert_equal(img.height, 256)
			end

			def test_width_#{ext}
				img = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				assert_equal(img.width, 256)
			end

			def test_size_#{ext}
				img = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				assert_equal(img.size, [ 256, 256 ])
			end

			def test_aspect_#{ext}
				img = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.#{ext}'))
				assert_in_delta(img.aspect, 1.0, 0.00000001)
			end
		EOF
	end

	def test_rotate
		imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.gd2')).rotate!(Math::PI)
		imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_rotated_180.gd2'))

		assert(imgA == imgB)
	end

	def test_crop
		imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.gd2')).crop!(64, 64, 128, 128)
		imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_cropped.gd2'))

		assert(imgA == imgB)
	end

	def test_uncrop
		img = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.gd2')).crop!(64, 64, 128, 128)
		img.uncrop!(64)

		assert_equal(img.size, [ 256, 256 ])
	end

	def test_resize
		imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.gd2')).resize!(512, 512)
		imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_resized.gd2'))

		assert(imgA == imgB)
	end

	def test_resampled
		imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.gd2')).resize!(512, 512, true)
		imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_resampled.gd2'))

		assert(imgA == imgB)
	end

	def test_polar_transform
		imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test.gd2')).polar_transform!(100)
		imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_polar_transform.gd2'))

		assert(imgA == imgB)
	end

	def test_color_sharpened
		imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_color.gd2')).sharpen(100)
		imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_color_sharpened.gd2'))

		assert(imgA == imgB)
	end

	def test_resampled
		imgA = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_color.gd2')).to_indexed_color
		imgB = Gd2::Image.import(File.join(PATH_TO_IMAGES, 'test_color_indexed.gd2'))

		assert(imgA == imgB)
	end
end
