local domain_style = {}

local function extract_domain(url)
  local domain = url:match("://([^/]+)")

  if domain then
    domain = domain:gsub("^www%.", "")
  end
  return domain
end

return {
  {
    Meta = function(m)
    
      if m.domain_style then
        domain_style.color = pandoc.utils.stringify(m.domain_style.color) or "black"  -- Default color to black if not set
        domain_style.font_size = pandoc.utils.stringify(m.domain_style.font_size) or "12px"  -- Default font size to 12px if not set
      else
        domain_style.color = "black"
        domain_style.font_size = "12px"
      end
      return m
    end 
  },

  {
    Link = function(el)
    
      local domain = extract_domain(el.target)

      local color = domain_style.color
      local font_size = domain_style.font_size

      local modified_link = pandoc.Link(el.content, el.target)

      local domain_style_str = 'style="color:' .. color .. '; font-size:' .. font_size .. ';"'

      return pandoc.RawInline('html', 
        '<a href="' .. el.target .. '">' .. pandoc.utils.stringify(el.content) .. '</a>' ..
        '<span ' .. domain_style_str .. '>[' .. domain .. ']</span>'
      )
    end
  }
}