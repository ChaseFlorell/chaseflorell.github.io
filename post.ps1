param (
  # A user has to provide the post title as a -Post parameter in order 
  # for script to work.
  [string]$post = $(throw "-post is required"),
  [switch]$draft
)
 
# Convert any text to a URL friendly string.
#
# $title - String to convert.
#
# Examples:
#
#   parameterize("Šis ir gadījuma teksts!")
#   #=> sis-ir-gadijuma-teksts
#
# Returns a String.
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
 
$current_datetime = get-date
$current_date = $current_datetime.ToString("yyyy-MM-dd")
$current_time = $current_datetime.ToString("HH:mm:ss")
$url_title = parameterize($post)
$filename = "{0}-{1}.md" -f $current_date, $url_title
 
# Jekyll and Pretzel stores posts in a _posts directory,
# therefore we have to make sure this directory exists.
if (-not (test-path _posts)) {
  new-item -itemtype directory _posts
}
 
 $path = if($draft.IsPresent){"_drafts/{0}" -f $filename} else {"_posts/{0}" -f $filename}
 
new-item -itemtype file $path
 
# Add the default YAML Front Matter at the top of the file.
"---" >> $path
"layout: post" >> $path
"title: " + $post >> $path
"date: "  + "$current_date $current_time" >> $path
"categories: " >> $path
"tags: " >> $path
"---" >> $path