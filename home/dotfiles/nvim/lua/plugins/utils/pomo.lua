return {
  "epwalsh/pomo.nvim",
  version = "*",  -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    -- Optional, but highly recommended if you want to use the "Default" timer
    "rcarriga/nvim-notify",
  },
  opts = {
    update_interval = 1000,
    notifiers = {
      {
        name = "Default",
        opts = {
          sticky = true,
          title_icon = "T",
          text_icon = "t",
        },
      },
      { name = "System" },
    },
    timers = {
      Break = {
        { name = "System" },
      },
    },
    sessions = {
      pomodoro = {
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Long Break", duration = "15m" },
      },
      deep_work = {
        { name = "Focus", duration = "50m" },
        { name = "Break", duration = "10m" },
      },
    },
  },
}
