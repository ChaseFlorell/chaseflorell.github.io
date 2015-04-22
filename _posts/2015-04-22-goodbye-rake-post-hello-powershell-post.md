---
layout: post
title: Goodbye [rake post], Hello PowerShell [post]
date: 2015-04-22 14:28:16
categories: [devops, powershell]
tags: [personal-blog, devops, jekyll]
---

Since I just got all setup with my [jekyll](http://jekyllrb.com/) on my [Github Pages](https://pages.github.com) personal blog, I was trying to figure out a quick way to generate new blog entries from the command line. I'm a huge fan of PowerShell, and therefore have made a personal decision to not install [ruby](https://www.ruby-lang.org/en/) on my personal dev machine. See, in the template for jekyll that I found, there's a nice little `rakefile` that has made it super simple to create new entries by simply calling `rake post title="Hello World"`... but alas, I don't have rake available to me.

My solution was to first ask the almighty Google if anyone had already made a powershell module for this... guess what, there is.

So I based my initial idea off of the [aigarsdz/create.ps1](https://gist.github.com/aigarsdz/6071059) gist, and then modified it a little. I decided to make it a module that I can drop into my `$env:USERPROFILE\Documents\WindowsPowerShell\Modules` folder. This way it can be called from anywhere, and doesn't need to be checked into the repository. Doing this also allows me to create an alias for it (read: I'm lazy).

-----

The first thing to do was add it to my "personal" modules. So inside the `Modules` directory is a folder called `Personal`, and inside that is a powershell module called `personal.psm1`. I've shortened it for clarity.

<!-- language: lang-posh -->

    if (Get-Module personal) { return }

    Push-Location $psScriptRoot

    . .\jekyll.ps1

    Pop-Location

    Export-ModuleMember `
        -Alias @(
            '*') `
        -Function @('Add-Post')

All it's doing id dot-invoking the jekyll.ps1 script and exporting the modules (currently only one). From here I've modified the script referenced above.

    function Add-Post {
      param (
        [parameter(Mandatory=$true, Position=0)][string]$post,
        [parameter(Mandatory=$false, Position=1)][switch]$draft
      )

      if(!(Assert-IsGitRepo)) {
        throw 'you are currently not in a git repository.'
      }   
      
      push-location "$(git rev-parse --show-toplevel)"

      $current_datetime = get-date
      $current_date = $current_datetime.ToString("yyyy-MM-dd")
      $current_time = $current_datetime.ToString("HH:mm:ss")
      $url_title = parameterize($post)
      $filename = "{0}-{1}.md" -f $current_date, $url_title
       
      # the target dir is either _drafts or _posts based on the $draft flag set by the user.
      $dir = if($draft.IsPresent){ "_drafts" } else { "_posts" }

      # Jekyll and Pretzel stores posts in a _posts directory,
      # therefore we have to make sure this directory exists.
      if (-not (test-path $dir)) {
        new-item -itemtype directory $dir
      }
       
      $path = "$dir/{0}" -f $filename
      new-item -itemtype file $path
       
      # Add the default YAML Front Matter at the top of the file.
      "---" >> $path
      "layout: post" >> $path
      "title: " + $post >> $path
      "date: "  + "$current_date $current_time" >> $path
      "categories: " >> $path
      "tags: " >> $path
      "---" >> $path

      # Force UTF-8 Encoding
      $MyFile = Get-Content $path
      $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
      [System.IO.File]::WriteAllLines($path, $MyFile, $Utf8NoBomEncoding)

      pop-location
    }
    Set-Alias post Add-Post

    function parameterize($title) {
      $parameterized_title = $title.ToLower()
      $words = $parameterized_title.Split()
      $normalized_words = @()
      
      foreach ($word in $words) {
        # Convert a Unicode string into its ASCII counterpart, e.g. māja -> maja.
        $normalized_word = $word.Normalize([Text.NormalizationForm]::FormD)
        
        # Normalize method returns ASCII letters together with a symbol that "matches"
        # the diacritical mark used in the Unicode. These symbols have to be removed
        # in order to get a valid string.
        $normalized_words += $normalized_word -replace "[^a-z0-9]", [String]::Empty
      }
      
      $normalized_words -join "-"
    }

    function Assert-IsGitRepo {
      try {
        git status
        return $true
      } catch {
        return $false
      }
    }

Simply drop this script into your `Modules\Personal` directory, invoke it from your `personal.psm1`, and reload your shell. Now you can easily add a new post by entering the following command (with the optional `$draft` parameter).

    > post "name of my post" [-draft]