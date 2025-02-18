-- -- Function to extract the domain from a URL using regex
-- local function extract_domain(url)
--   -- Match the domain part of the URL using a regex
--   local domain = url:match("://([^/]+)")  -- Extract the part after "://", before any "/" (i.e., the domain)
--   return domain
-- end

-- -- Pandoc filter function for processing links
-- function Link(el)
--   -- Extract the domain from the URL
--   local domain = extract_domain(el.target)

--   -- Create the anchor link
--   local modified_link = pandoc.Link(el.content, el.target)

--   -- Now, separate the link content and the domain in square brackets
--   -- The link will be placed outside, and the domain will be placed after
--   return pandoc.RawInline('html', '<a href="' .. el.target .. '">' .. pandoc.utils.stringify(el.content) .. '</a>[' .. domain .. ']')
-- end

-- Global variable to store metadata parameters
local domain_style = {}

-- Function to extract the domain from a URL using regex
local function extract_domain(url)
  -- Match the domain part of the URL using a regex
  local domain = url:match("://([^/]+)")  -- Extract the part after "://", before any "/" (i.e., the domain)
  return domain
end

return {
-- Meta function to process metadata
{Meta = function(m)
  
  -- Check if 'domain_style' is defined in the metadata
  if m.domain_style then
    domain_style.color = pandoc.utils.stringify(m.domain_style.color) or "black"  -- Default color to black if not set
    domain_style.font_size = pandoc.utils.stringify(m.domain_style.font_size) or "12px"  -- Default font size to 12px if not set
  else
    domain_style.color = "black"
    domain_style.font_size = "12px"
  end
  return m
end },

-- Pandoc filter function for processing links
{Link = function(el)
  -- Extract the domain from the URL
  local domain = extract_domain(el.target)

  -- Get the custom styling parameters from the global 'domain_style' table
  local color = domain_style.color
  local font_size = domain_style.font_size

  -- Create the anchor link
  local modified_link = pandoc.Link(el.content, el.target)

  -- Create the domain style as inline CSS
  print(color)
  local domain_style_str = 'style="color:' .. color .. '; font-size:' .. font_size .. ';"'

  -- Now, separate the link content and the domain in square brackets, with styling
  return pandoc.RawInline('html', 
    '<a href="' .. el.target .. '">' .. pandoc.utils.stringify(el.content) .. '</a>' ..
    '<span ' .. domain_style_str .. '>[' .. domain .. ']</span>'
  )
end}
}