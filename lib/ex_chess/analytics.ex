defmodule ExChess.Analytics do
  @moduledoc false

  alias ExChess.Analytics.Online

  defdelegate online_stats, to: Online
end
