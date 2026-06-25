-- flatten-layout.lua

-- 1. UTILITY: SCRUB BEAMER COMMANDS
-- This function removes "\pause" from Raw LaTeX blocks/inlines
-- if we are NOT in beamer mode.
local function scrub_beamer_commands(el)
  if FORMAT ~= "beamer" and el.format:match("tex") then
    -- Replace \pause with an empty string
    el.text = el.text:gsub("\\pause", "")
    return el
  end
  return nil -- keep original if no changes
end

-- Hook into RawBlock (standalone latex commands)
function RawBlock(el)
  return scrub_beamer_commands(el)
end

-- Hook into RawInline (latex commands inside paragraphs).
-- Handles three cases beyond \pause stripping:
--   a) HTML output: \autoref{label} → clickable anchor link
--   b) HTML/non-latex output: \citep{key1,key2} → pandoc Cite (NormalCitation)
--   c) HTML/non-latex output: \citet{key} → pandoc Cite (AuthorInText)
-- Cases (b) and (c) convert to pandoc's native Cite nodes so that
-- --citeproc can render them as a proper bibliography in HTML output.
-- LaTeX and Beamer outputs are left untouched — natbib handles \citep there.
function RawInline(el)
  if not el.format:match("tex") then return nil end

  -- (a) \autoref{label} → HTML anchor link (HTML output only)
  if FORMAT:match("html") then
    local label = el.text:match("^\\autoref{([^}]+)}$")
    if label then
      return pandoc.RawInline("html",
        '<a href="#' .. label .. '">Figure</a>')
    end
  end

  -- (b,c) Citation conversion for non-LaTeX, non-Beamer formats.
  -- Converts to pandoc Cite nodes so --citeproc (used in chapter-html)
  -- renders proper formatted citations. Without --citeproc (html target),
  -- the fallback display text "[key]" is shown instead of disappearing.
  if FORMAT ~= "beamer" and FORMAT ~= "latex" then
    -- \citep{key1,key2,...} → parenthetical citation
    local keys_str = el.text:match("^\\citep{([^}]+)}$")
    if keys_str then
      local citations = {}
      local display_parts = {}
      for key in keys_str:gmatch("[^,%s]+") do
        table.insert(citations,
          pandoc.Citation(key, "NormalCitation", {}, {}, 0, 0))
        table.insert(display_parts, key)
      end
      local fallback = {pandoc.Str("[" .. table.concat(display_parts, "; ") .. "]")}
      return pandoc.Cite(fallback, citations)
    end

    -- \citet{key1,...} → author-in-text citation
    keys_str = el.text:match("^\\citet{([^}]+)}$")
    if keys_str then
      local citations = {}
      local display_parts = {}
      for key in keys_str:gmatch("[^,%s]+") do
        table.insert(citations,
          pandoc.Citation(key, "AuthorInText", {}, {}, 0, 0))
        table.insert(display_parts, key)
      end
      local fallback = {pandoc.Str("[" .. table.concat(display_parts, "; ") .. "]")}
      return pandoc.Cite(fallback, citations)
    end
  end

  return scrub_beamer_commands(el)
end


-- 2. LAYOUT: FLATTEN COLUMNS
function Div(div)
  -- If we are creating Beamer slides, do nothing (keep the columns)
  if FORMAT == "beamer" then
    return nil
  end

  -- If we are in any other format (Article, Book, HTML, etc.)
  if div.classes:includes("column") or div.classes:includes("columns") then
    
    -- Check for "spacer" columns (width < 10%) and discard them
    local width = div.attributes['width']
    if width and width:match("%%") then
        local num = tonumber(width:match("(%d+)"))
        if num and num < 10 then
            return {} 
        end
    end

    -- "Unwrap" the div: return the content without the container
    return div.content
  end
end


-- 3. LISTS: SUPPRESS IN BOOK / HTML
-- Slide bullet points duplicate content already written as prose in
-- ::: notes blocks. Remove them in non-beamer formats so the chapter
-- and HTML contain only the polished paragraph text, not raw slide lists.
function BulletList(el)
  if FORMAT ~= "beamer" then
    return {}
  end
end

function OrderedList(el)
  if FORMAT ~= "beamer" then
    return {}
  end
end


-- 4. IMAGES: RESIZE FOR BOOK / HTML
-- Slide images at 90% of a Beamer column look fine on slides but are
-- enormous in a book chapter (90% of textwidth ≈ full page).
--
-- Two problems to solve:
--   (a) Width: cap anything above 55% to 55% of textwidth.
--   (b) Height: pandoc's LaTeX writer ALWAYS emits height=\textheight
--       even when the attribute is cleared. Setting an explicit height
--       of 40% makes pandoc emit height=0.4\textheight instead, which
--       combined with keepaspectratio (injected by header-chapter.tex)
--       prevents tall/portrait images from filling the page, and
--       prevents landscape images from being distorted.
function Image(img)
  if FORMAT ~= "beamer" then
    local w = img.attributes['width']
    local pct = w and tonumber(w:match("^(%d+)%%$"))
    -- Cap width: anything above 55% → 55%; unspecified → 55%
    if pct == nil or pct > 55 then
      img.attributes['width'] = "55%"
    end
    -- Override height to a bounded fraction of the page height.
    -- keepaspectratio (see header-chapter.tex) ensures the more
    -- restrictive of width and height wins, never distorting the image.
    img.attributes['height'] = "40%"
  end
  return img
end