---@diagnostic disable: undefined-global

--------------------------------------------------
-- Session
--------------------------------------------------

require("session"):setup {
  sync_yanked = true,
}

--------------------------------------------------
-- Header: user@host (LEFT)
--------------------------------------------------

Header:children_add(function()
  if ya.target_family() ~= "unix" then
    return ui.Line {}
  end

  return ui.Line {
    ui.Span("  "), -- padding
    ui.Span(ya.user_name() .. "@" .. ya.host_name())
      :fg("lightgreen")
      :bold(true),
    ui.Span("  "),
  }
end, 500, Header.LEFT)

--------------------------------------------------
-- Header: cwd + hovered (SAFE override)
--------------------------------------------------

function Header:cwd()
  local max = self._area.w - self._right_width
  if max <= 0 then
    return ""
  end

  local cwd = ya.readable_path(tostring(self._current.cwd)) .. self:flags()
  local hovered = ""

  if cx.active.current.hovered then
    hovered = tostring(cx.active.current.hovered.name or "")
  end

  return ui.Line {
    ui.Span("  "), -- left padding

    ui.Span(cwd):fg("blue"):bold(true),
    ui.Span(" / "):fg("darkgray"),

    ui.Span(hovered):fg("white"):bold(true),

    ui.Span("  "), -- right padding
  }
end

--------------------------------------------------
-- Divider (SAFE)
--------------------------------------------------

Header:children_add(function()
  return ui.Line {
    ui.Span(string.rep("─", 100)):fg("darkgray")
  }
end, 1000)

--------------------------------------------------
-- Status cleanup
--------------------------------------------------

function Status:size()
end

function Status:percent()
end

--------------------------------------------------
-- Symlink display
--------------------------------------------------

function Status:name()
  local h = self._tab.current.hovered
  if not h then
    return ui.Line {}
  end

  local linked = ""
  if h.link_to ~= nil then
    linked = " -> " .. tostring(h.link_to)
  end

  return ui.Line(" " .. h.name .. linked)
end
