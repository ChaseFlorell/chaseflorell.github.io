---
layout: post
title: How and When to use Control Templates in Xamarin Forms
date: 2018-03-31 13:35:22
categories: [xamarin]
tags: [xamarin, xamarin-forms, C#]
---

In my attempt build clean and more re-usable UI, I've been using a `ContentView` to wrap multiple Controls into a single re-usable control. The problem with this is that you have to manage the BindingContext and all of your custom controls get the following *noise*...

```
protected override void OnBindingContextChanged()
{
    base.OnBindingContextChanged();
    Control.BindingContext = this;
}
```

This was until I saw the light when researching the Xamarin Forms [ControlTemplate](https://docs.microsoft.com/en-us/xamarin/xamarin-forms/app-fundamentals/templates/control-templates/creating)s. The problem that I ran into however was that I didn't love the way all of the examples were defining the `ControlTemplate` within the `App.xaml`. I felt it didn't follow a clean pattern and also didn't love that it was constructed globally instead of when needed.

The use case that I have is that I needed a persistant button fixed to the bottom right corner of my page and need to be able to put whatever content on the page itself. This is a perfect scenario for a control template, so let's dive in.

First we define our new custom control. I'm calling this one an "ActionButtonLayout". It's sort of like a [FAB](https://developer.android.com/reference/android/support/design/widget/FloatingActionButton.html) but not really, so I'm ommitting the "Floating" ;). The great part here is that you can in fact still use a `ContentView` as a wrapper and define your ControlTemplate within.
{% gist daabc0b5d695c0be226d5eba91a7067c ActionButtonLayout.xaml %}

The super cool thing that I want you to notice is the `ContentPresenter`. We can define it's positioning and even apply some styling to it, and whenever we set the `Content` property of the ActionButtonLayout, the Content will get applied within the ContentPresenter. One caveat to remember with a Control Template however is that there's no way to locate any views within the template. This means that it's pointless to give any inner controls an `x:Name` unless you have additional controls that will be referencing it via `x:Reference`.

Now there are some bindings applied to the control template, so look at how the Xaml uses `TemplateBinding` instead of `Binding`. Xamarin Forms knows that a `TemplateBinding` uses properties on the code behind class as opposed to the `BindingContext`. Here's what the code behind looks like.
{% gist daabc0b5d695c0be226d5eba91a7067c ActionButtonLayout.xaml.cs %}

It's completely boiler plate bindable properties and nothing fancy is going on.

But here's the cool bit; Since Xamarin Forms knows to apply the "Content" to the `ContentPresenter`, and the framework also knows that the inner XAML of the template is automatically "Content", we can define our page with minimal bloat.
{% gist daabc0b5d695c0be226d5eba91a7067c Implementation.xaml %}

And here you have it. Notice the "Save" button on the bottom right
![Imgur](https://i.imgur.com/unTgBY3.png)
