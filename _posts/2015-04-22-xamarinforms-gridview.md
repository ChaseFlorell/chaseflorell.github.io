---
layout: post
title: Xamarin.Forms GridView
date: 2015-04-22 10:53:22
categories: [xamarin], [xamarin-forms]
tags: [xamarin], [xamarin-forms], [gridview]
---

So I've decided to take a stab at blogging. Not sure how well I'll do, but I get asked often enough for help that I figure I ought to share the knowledge as best I can.

I get asked on a semi-regular basis on how to implement a GridView on Xamarin.Forms. I've done this successfully in two projects now, and although it's not totally bindable, it'll get the job done for most use cases.  I tried using the [XLabs](https://github.com/XLabs/Xamarin-Forms-Labs) GridView, but I really had a difficult time getting it to [work properly](https://forums.xamarin.com/discussion/30612/cant-xlabs-gridview-to-update-binding).

So here it is, it's fully implemented in the PCL, so there is **no custom renderer** to deal with.

**XAML**

     <ctrl:GridView
          HorizontalOptions="FillAndExpand"
          VerticalOptions="FillAndExpand"
          x:Name="GrdView"
          RowSpacing="5"
          ColumnSpacing="5"
          MaxColumns="2"
          TileHeight="120"
          CommandParameter="{Binding}"
          Command="{Binding StartTaskCommand}" 
          IsClippedToBounds="False">
      </ctrl:GridView>

**XAML.cs**

        public ProjectPage()
        {
            InitializeComponent();
            
            // not sure how to define this in XAML
            GrdView.ItemTemplate = typeof(TaskTileTemplate);
        }

        protected override async void OnAppearing()
        {
            base.OnAppearing();
            await GrdView.BuildTiles(taskPageViewModel.Tasks);
        }

**GridView**

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Windows.Input;
    using Xamarin.Forms;
    
    namespace TimeTracker.Controls
    {
        public class GridView : Grid
        {
            public static readonly BindableProperty CommandParameterProperty = BindableProperty.Create<GridView, object>(p => p.CommandParameter, null);
            public static readonly BindableProperty CommandProperty = BindableProperty.Create<GridView, ICommand>(p => p.Command, null);
            private int _maxColumns = 2;
            private float _tileHeight = 100;
    
            public GridView()
            {
                for (var i = 0; i < MaxColumns; i++)
                {
                    ColumnDefinitions.Add(new ColumnDefinition());
                }
            }
    
            public Type ItemTemplate { get; set; }
    
            public int MaxColumns
            {
                get { return _maxColumns; }
                set { _maxColumns = value; }
            }
    
            public float TileHeight
            {
                get { return _tileHeight; }
                set { _tileHeight = value; }
            }
    
            public object CommandParameter
            {
                get { return GetValue(CommandParameterProperty); }
                set { SetValue(CommandParameterProperty, value); }
            }
    
            public ICommand Command
            {
                get { return (ICommand) GetValue(CommandProperty); }
                set { SetValue(CommandProperty, value); }
            }
    
            public async Task BuildTiles<T>(IEnumerable<T> tiles)
            {
                // Wipe out the previous row definitions if they're there.
                if (RowDefinitions.Any())
                {
                    RowDefinitions.Clear();
                }
                var enumerable = tiles as IList<T> ?? tiles.ToList();
                var numberOfRows = Math.Ceiling(enumerable.Count/(float) MaxColumns);
                for (var i = 0; i < numberOfRows; i++)
                {
                    RowDefinitions.Add(new RowDefinition {Height = TileHeight});
                }
    
                for (var index = 0; index < enumerable.Count; index++)
                {
                    var column = index%MaxColumns;
                    var row = (int) Math.Floor(index/(float) MaxColumns);
    
                    var tile = await BuildTile(enumerable[index]);
    
                    Children.Add(tile, column, row);
                }
            }
    
            private async Task<Layout> BuildTile(object item1)
            {
                return await Task.Run(() =>
                {
                    var buildTile = (Layout) Activator.CreateInstance(ItemTemplate, item1);
                    var tapGestureRecognizer = new TapGestureRecognizer
                    {
                        Command = Command,
                        CommandParameter = item1
                    };
    
                    buildTile.GestureRecognizers.Add(tapGestureRecognizer);
                    return buildTile;
                });
            }
        }
    }

Your template can be any Layout or ContentPage

    <?xml version="1.0" encoding="utf-8"?>
    <AbsoluteLayout xmlns="http://xamarin.com/schemas/2014/forms"
                    xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
                    x:Class="TimeTracker.Pages.Templates.TaskTileTemplate"
                    BackgroundColor="{Binding Color, Converter={StaticResource HexToColorConverter}}"
                    HorizontalOptions="CenterAndExpand" 
                    VerticalOptions="CenterAndExpand">
    
        <Label FontSize="20" Text="{Binding Name}"
               TextColor="{Binding Color, Converter={StaticResource BrightnessInversionConverter}}"
               AbsoluteLayout.LayoutBounds=".5,.5,-1,-1" 
               AbsoluteLayout.LayoutFlags="PositionProportional" />
    
        <ActivityIndicator IsRunning="{Binding IsBusy}" 
                           IsVisible="{Binding IsBusy}"
                           AbsoluteLayout.LayoutBounds=".5,.5,-1,-1" 
                           AbsoluteLayout.LayoutFlags="PositionProportional" />
    </AbsoluteLayout>

If anyone is up for adding full Binding support, I'd be more than thrilled.

--- 

here are a few examples of my last two apps using a gridview.

![Imgur](https://i.imgur.com/Qd8alh7.png) 
![Imgur](https://i.imgur.com/tCzBPc0.png) 
![Imgur](https://i.imgur.com/JFxguYL.png)