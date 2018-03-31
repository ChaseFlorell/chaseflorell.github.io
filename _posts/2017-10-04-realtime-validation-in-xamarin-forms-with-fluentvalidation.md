---
layout: post
title: Realtime Validation in Xamarin Forms with FluentValidation
date: 2017-10-04
tags: [xamarin-forms, xamarin, inotifydataerrorinfo]
categories: [xamarin]
---

Xamarin Forms doesn't have anything baked into the framework to handle data validation, but it's actually possible to do in your cross platform code without any renderers.

Microsoft has had for a long time the interface [INotifyDataErrorInfo](https://msdn.microsoft.com/en-us/library/system.componentmodel.inotifydataerrorinfo(v=vs.110).aspx). You're going to want to implement this on your ViewModel (or better yet, your base view model) whereby you can notify the View whenever there are errors. On top of this, you want to also bring in Jeremy Skinner's [FluentValidation](https://github.com/JeremySkinner/FluentValidation) library to handle your validation rules. 

Let's start by wiring up our BaseViewModel. This will implement the INotifyDataErrorInfo as well as INotifyPropertyChanged. You'll notice in here the `SetProperty` method that simply helps us invoke validation in our subsequest ViewModel.
{% gist 37ec1062b9bd367c67ad56f8d93fc30a BasePageModel.cs %}

Next we want to set up all of our validation rules. Using FluentValidation is super cool because it allows us to separate out the logic cleanly and also makes validation fully testable. Here's a super simple example of our validator.
{% gist 37ec1062b9bd367c67ad56f8d93fc30a MainPageModelValidator.cs %}

From here, all of our ViewModels will be implemented as follows. 
*note: ValidateProperty will get called every time the setter updates the value*
{% gist 37ec1062b9bd367c67ad56f8d93fc30a MainPageModel.cs %}

Now that our ViewModel is wired up, we need to build out our View. The problem that exists with XamarinForms as it stands right now is that there is not out-of-the-box error messaging built into any of the controls. To enable this, we need to first build a custom control to handle it. Here's a simple `ExtendedEntry` that will get you started.

{% gist 37ec1062b9bd367c67ad56f8d93fc30a ExtendedEntry.xaml.cs %}
{% gist 37ec1062b9bd367c67ad56f8d93fc30a ExtendedEntry.cs %}

In here we're leveraging a `ControlTemplate` to watch our bindings and we have a special extension method to extract the binding `Path`

{% gist 37ec1062b9bd367c67ad56f8d93fc30a BindingExtensions.cs %}

The last step is the implementation on the View.

{% gist 37ec1062b9bd367c67ad56f8d93fc30a MainPage.xaml %}

And that's it. If you run this in your simulator, you'll be able to see real time error messages appearing benieth your Entry fields.