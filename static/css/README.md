# Site stylesheet for Web of Tomorrow

Author: Jake Hickenlooper

This site is rather simple in its design and all the CSS could be managed in
one or two files.  However, this organization scheme is experimental to test
ideas on how to manage a much more complex web site.

Specificity ordered stylesheet (ITCSS).  Sections are designated with a digit
in relation to the order they are imported. 

**0-generic**: For reset styles. (usually just the normalize.css)

**1-elements**: Only plain element selectors with no class or id used. Should
rarely be nested.

**2-objects**: These are design agnostic and are used in a wide range of
websites.  Mostly for commonly used layouts and such. Most should follow
a naming convention.

**3-components**: Components follow a naming convention to isolate them from
other elements. A test page describing the intended use should be made for
each. If a component is not like to be reusable, then it's likely it should be
in the theme section.

**4-theme**: *Still experimenting.* Sorta following the ECSS naming convention.
Can wrap components for additional styling if the key selector rule is applied.
`.sw-Header-Menu.Grid-cell` would be common to setting width on a Grid-cell.

**5-utilities**: A utility should rarely need to be overridden. It should only
be for simple things.

**6-settings**:  Define the variables used for custom media queries,
typography, image sizes, and other general settings that are used throughout.
Not all variables are defined here, just the ones that should preserve their
value.  This is why it's last. 

## Component versus Theme

The rule of thumb for deciding whether a stylesheet should go in components or
theme section.

**Stylesheets within the *4-components* directory:**

* Designed to be potentially reusable in different contexts.
* Should have a test page where the styles are developed in isolation.


**Stylesheets within the *4-theme* directory:**

* Not likely to be used elsewhere.
* Part of the name might have location attributes. For example: top-nav,
  sidebar, footer-content.
* May be used to modify the styles of a component by wrapping or hijacking.
* Are usually developed on the site and not in a isolated test page.
