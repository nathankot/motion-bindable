# Motion Bindable

[![Build Status](https://travis-ci.org/nathankot/motion-bindable.png?branch=master)](https://travis-ci.org/nathankot/motion-bindable)
[![Code Climate](https://codeclimate.com/github/nathankot/motion-bindable.png)](https://codeclimate.com/github/nathankot/motion-bindable)

A simple two-way data binding library for RubyMotion.

## NOTICE

Version `0.3.0` introduces breaking changes and deprecations. If you're upgrading, please check the [release
notes](nathankot/motion-bindable/releases/tag/v0.3.0).

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
  MotionBindable::Strategies.apply
  true
end
```

## Terminology

| Name    | Definition                                                                                                             |
| ---     | ---                                                                                                                    |
| Object  | Refers to the _parent_ object that can have many bindings. Usually a model of some sort.                               |
| Binding | The connection between an object and it's bound children. Observes and updates both sides. Represented as a `Strategy` |
| Bound   | Usually an _input_ object, like a `UITextField` or a `Proc`.                                                           |

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
  end

  def viewWillAppear(animated)
    @item.bind_attributes({
      name: @name_field,
      location: {
        address: @address_field
      }
    })
  end

  # Recommended: Clean everything up when the view leaves
  def viewWillDisappear(animated)
    @item.unbind_all
  end
end
```

When `@name_field.text` or `@address_field.text` changes, so will your model!

### Custom Strategies

The above example uses the `MotionBindable::Strategies::UITextField`.  which
comes with MotionBindable. Take a look in `lib/motion_bindable/strategies` for
the available defaults. You can implement your own strategies by extending
`MotionBindable::Strategy`. Please use the existing strategies as a guideline.

### Default Strategies

The following strategies come with motion-bindable and are setup when
`MotionBindable::Strategies.apply` is called.

| Name                                      | Object Candidates | Direction           |
| ----------------------------------------- | ----------------- | ------------------- |
| `MotionBindable::Strategies::UITextField` | Any `UITextField` | Bound <-> Attribute |
| `MotionBindable::Strategies::Proc`        | Any `Proc`        | Bound --> Attribute |
| `MotionBindable::Strategies::UILabel`     | Any `UILabel`     | Bound <-- Attribute |

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
