---
layout: post
title: Rating filter module for Drupal
author: alastairs
nid: 18
created: 1215643488
---
One of the things I do with my blog is to review stuff that I've bought or seen or read or listened to.  As a result, I wanted to be able to rate this stuff as a concise summary of my view of it.  

There are a couple of Drupal modules available that could help me out with this, such as review, bookreview and moviereview, but these are all in various stages of death, and I didn't necessarily want all the extra, sometimes stuff-specific, functionality of those modules, so I sat down last night and wrote myself a little filter module that nicely converts ratings of the form [x/y] to stars.  It handles half stars and everything.

The following implementation is a <em>very</em> simple one: it deliberately doesn't expose any settings to the administrator or the user.  As such, the default out-of-the-box behaviour is all that is available.  No, you can't customise or change the images.  No, you can't customise the ratings input formats (e.g., using percentages).  No, you can't do anything but replace the [x/y] with x whole stars and y-x empty stars.  However, it's a pretty good introduction to developing for Drupal, so here goes.
<!--break-->
I've included the code below, and I'll dissect it along the way for our mutual benefit.  Before I do that, though, I should probably explain a couple of important Drupal concepts.  Drupal uses "nodes" for displaying content; nodes can be images, "stories" (posts like this blog entry), pages (for static content, like my <a href="/about" title="About Me">About Me</a> page), comments, forum posts, etc., etc., etc.  Any bit of content that is the main focus of the current page is a node.  Filters search the node content for patterns it recognises and does something with those patterns (e.g., stripping out disallowed HTML tags, syntax highlighting code, etc.).  Input formats are a collection of filters and control how a user can post content to the site in relation to the user's permissions and the node type.  For example, I have two input formats defined "Filtered HTML" and "Full HTML".  The names are fairly self-explanatory, and they both have all filters enabled (although "Full HTML" has the HTML filter turned off).  I could define a more restrictive "Filtered HTML" input format (or disable HTML entirely) for comments and enable this filter for anonymous users.  I could install a <abbr title="What You See Is What You Get">WYSIWYG</abbr> editor and enable it only for my own use when writing image descriptions (although that would be fairly useless).  

Anyway, on to the code.  First of all, I defined some constants representing the star images (full star, half star and "empty" star to give the total number of stars available for the rating), and one for the regular expression used to match the textual ratings.  This is fairly simple, standard PHP stuff:
<?php
define('STAR', '<img src="/sites/default/files/ratingfilter/images/star.gif" alt="Star" />');
define('HALF_STAR', '<img src="/sites/default/files/ratingfilter/images/half_star.gif" alt="Half-star" />');
define('EMPTY_STAR', '<img src="/sites/default/files/ratingfilter/images/empty_star.gif" />');
define('RATING_REGEX', "#\[(\d+)(\.5)?/(\d+)\]#");
?>

The regular expression is hopefully fairly self-explanatory, but in the interests of completeness, it matches the following sequence of characters:
<ol>
  <li>an opening square bracket</li>
  <li>one or more digits (\d+)</li>
  <li>an optional decimal point and number five for half stars (\.5)?</li>
  <li>a forward slash</li>
  <li>one or more digits</li>
  <li>a closing square bracket</li>
</ol>

Next, I implemented the <a href="http://api.drupal.org/api/function/hook_filter" title="Drupal API documentation for hook_filter">hook_filter()</a> function exposed by the Drupal API.  The $op parameter specifies what the filter should do; the $delta parameter specifies the "offset" of the filter (so multiple filters can be specified in one module; I ignored this); the $format parameter specifies the input format in use (I ignored this too); the $text parameter specifies the input text, e.g., the node body text that you're currently reading.  
<?php
function ratingfilter_filter($op, $delta = 0, $format = -1, $text = "") {
  switch($op) {
    // Expose the rating filter to the filter system
    case "list":
      return array('Rating Filter');
    break;
  
    // Provide a description of the filter, used on the Input Formats administration page
    case "description":
      return t("Allows the insertion of graphical ratings (e.g. 4 stars out of 5) for the subject of the node.  Ratings are inserted as [x/y], i.e., x stars out of y.  ");
    break;

    // Prepare the text for filtering.  Usually used for escaping characters.  
    case "prepare":
      return ratingfilter_filter_prepare($text);
    break;

    // Apply the filter to the text.  
    case "process":
      return ratingfilter_filter_process($text);
    break;
  }
}
?>

As you can see, I chose to pass the grunt work out to a pair of helper methods.  There's no particular reason to do so &mdash; indeed, the example filter in the Drupal API documentation doesn't bother &mdash; but I prefer the modularity of this approach.  Judging by the example, this should help me should I decide to add further filters to the module (although this is unlikely).  I also think that keeping the grunt work out of this method improves the readability of the code.  This particular hook seems a little too general-purpose; personally I think I would have provided separate hooks for each filter operation, or for the prepare and process operations at the very least.  

The next function is an implementation of <a href="http://api.drupal.org/api/function/hook_filter_tips" title="Drupal API documentation for hook_filter_tips">hook_filter_tips()</a>.  This method is used on the node creation pages for the input formats for which the filter is enabled, and provides hints to the user on how the filter works.  Again, $delta refers to the "offset" of the filter in the module, $format refers to the input format in use, and $long specifies whether a summary or full description should be displayed.  This is another very simple function.  

<?php
function ratingfilter_filter_tips($delta, $format, $long = false) {
  if ($long) {
    return t('Ratings of the form [x/y] will be replaced with an image-based representation of the score.');
  } else {
    return t('Use [x/y] to display a score.');
  }
}
?>

On to the meat of the module.  I've grouped the prepare and process function together here, as the prepare function does nothing at all.  According to the <a href="http://api.drupal.org/api/function/hook_filter" title="Drupal API documentation for hook_filter">API documentation</a>, the prepare step should <em>only</em> do escaping of text.  As my filter has no need for this ability (currently, at least), the method simply returns the input as-is.  

I'll let you have a read over the process function before dissecting it.

<?php
function ratingfilter_filter_prepare($input) {
  // This method should only do escaping, which isn't required for this simple filter.  
  return $input;
}

// Replaces a rating of the form [x/y] with the appropriate number of stars.
function ratingfilter_filter_process($input) {
  $output = $input;

  while (preg_match(RATING_REGEX, $output, $matches) > 0) {
    $rating = "";
    $numStars = (int) $matches[1];

    // Create the numerator stars
    for ($i = 0; $i < $numStars; $i++) {
      $rating .= STAR;
    }

    // Add a half star if required, and count this as an extra whole star for the sake of the overall total.
    if ($matches[2] == ".5") {
      $rating .= HALF_STAR;
      $numStars += 1;
    }

    // Create the (remaining) denominator stars
    for ($i = 0; $i < (int)$matches[3] - $numStars; $i++) {
      $rating .= EMPTY_STAR;
    }

    // Replace the textual ratings one at a time
    $output = preg_replace(RATING_REGEX, $rating, $output, 1);
  }

  return $output;
}
?>

First of all, I copy the input to an output variable.  This may seem a bit odd, based on the rest of the function's code: surely we could just use $input throughout?  This is, in many respects, a matter of style, but I prefer the fact that the parameter is left unchanged, thereby preserving the data that was passed into the function.  Yes, it increases memory usage, but we're rather beyond the days where memory usage was a real concern (unless you're running Windows Vista with 1GB RAM).  

We then run the regular expression defined above over the text until it no longer matches (i.e., all scores have been replaced).  The $matches array stores a number of items: $matches[0] is the entire text that the regex matched (i.e., the full textual rating, square brackets and all), and each subsequent element in $matches represents the text matching one of the parenthesised sub-expressions in RATING_REGEX.  That is to say, for a rating of 3.5 out of 5, $matches[1] = 3, $matches[2] = .5 and $matches[3] = 5.  I then cast the numerator ($matches[1]) to an integer to ensure that I've got the right datatype for the following <tt>for</tt> loop which then creates the right number of "whole" stars.  The cast isn't strictly necessary, but I like being type-safe, and I need the figure later anyway.  If a half star is required, I create the half star and increment the number of stars by one so that I don't end up with the wrong total number of stars (effectively rounding up the number of stars).  Finally the required number of empty stars are created to bring the total number of stars to equal the denominator ($matches[3]).  The <tt>preg_match</tt> function runs the RATING_REGEX again, this time replacing the matched text with the image-based rating.  The final parameter, $limit, specifies the number of occurrences that should be replaced; passing in 1 here ensures that the ratings are processed individually and in turn.  <tt>str_replace</tt> can also be used, passing in $matches[0] rather than the regex.  

The code is entirely public domain; I'm not even fussed about attribution in this instance!  Please feel free to copy it off this page and put it to use in your own site, but also note that I offer absolutely no warranty on it whatsoever, not even that it is fit for purpose.  

I hope this has been a useful exercise, and, as always, please leave me comments below as you see fit.
