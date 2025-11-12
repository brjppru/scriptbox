local last = hs.pasteboard.changeCount()
local watcher = hs.pasteboard.watcher.new(function()
  local now = hs.pasteboard.changeCount()
  if now ~= last then
    last = now
    hs.sound.getByFile(os.getenv("HOME") .. "/.hammerspoon/Click.aif"):play()
  end
end)
watcher:start()
