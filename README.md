# Motion Bindable

A simple data binding library for RubyMotion.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'motion_bindable'
```

And then execute:

```sh
$ bundle
```

If you want to use the default strategies that come with MotionBindable add
this to your `app_delegate.rb`:

``` ruby
def application(application, didFinishLaunchingWithOptions: launch_options)
  MotionBindable::Strategies.use
  true
end
```

## Usage

Add `include MotionBindable::Bindable` to make an object bindable:

```ruby
# Models

class Item
  include MotionBindable::Bindable
  attr_accessor :name
  attr_accessor :location

  def location
    @address ||= Address.new
  end
end

class Address
  attr_accessor :address
end
```

In your view controller, you can bind the object to a set of Views or any
other object:

```ruby
class ItemListViewController
  def viewDidLoad
    super
    @name_field = UITextField.alloc.initWithFrame [[110, 60], [100, 26]]
    @name_field.placeholder = "Name"
    view.addSubview @name_field

    @address_field = UITextField.alloc.initWithFrame [[110, 100], [100, 26]]
    @address_field.placeholder = "Address"
    view.addSubview @address_field

    @item = Item.new
    @item.bind_attributes({
      name: @name_field,
      location: {
        address: @address_field
      }
    })
  end
end
```

When `@name_field.text` or `@address_field.text` changes, so will your model!

### Refresh

To refresh the values on your bindable object use this:

```ruby
@bindable.refresh
```

Some strategies only make an update when a `#refresh` is called. See the
_Frequency_ column in the table below.

### Custom Strategies

The above example uses the `MotionBindable::Strategies::UITextField`.
which comes with MotionBindable. Take a look in
`lib/motion_bindable/strategies` for the available defaults. You can implement
your own strategies by extending `MotionBindable::Strategy` like so:

```ruby
class CustomBindableStrategy < MotionBindable::Strategy

  def on_bind
    # This runs once when the object is bound.
  end

  def refresh
    # This runs when the object is bound, and each time `@bindable.refresh`
    # is called.
  end

end
```

### Defaults Strategies

The following strategies come with motion-bindable and are setup when
`MotionBindable::Strategies.use` is called.

| Name                                      | Object Candidates | Direction | Frequency  |
| ----------------------------------------- | ----------------- | --------- | ---------- |
| `MotionBindable::Strategies::UITextField` | Any `UITextField` | Two-way   | On Change  |
| `MotionBindable::Strategies::Proc`        | Any `Proc`        | One-way   | On Refresh |

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
