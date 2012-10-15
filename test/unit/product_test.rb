require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any? 
  end

  test "product price must be positive" do
    product = Product.new(title: "mlx",
    					  description: "mlx", 
    					  image_url: "mlx.jpg")
    product.price=-1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",product.errors[:price].join(';')

    product.price=0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",product.errors[:price].join(';')
    
    product.price=1
    assert product.valid?
 
  end

  def new_product(image_url)
    Product.new(title: "mlx",
                description: "mlx",
                price:1,
                image_url: image_url)
  end
  test "image_url" do
    ok = %w{ mlx.gif mlx.jpg mlx.png MLX.JPG MLX.Jpg http://a.b.c/x/y/z/mlx.gif }
    bad = %w{ mlx.doc mlx.gif/more mlx.gif.more }
    ok.each do |name|
        assert new_product(name).valid?, "#{name} should not be invalid"
    end

    bad.each do |name|
        assert new_product(name).invalid?, "#{name} should not be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "mlx.png")
    assert !product.save
    #assert_equal "has already been taken", product.errors[:title].join(';')
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join(';')
  end
end
