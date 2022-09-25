defmodule TodosWeb.CalendarDayComponent do
  use Phoenix.LiveComponent
  use Timex
  use Phoenix.LiveView

  def render(assigns) do
    assigns = Map.put(assigns, :day_class, day_class(assigns))

    ~L"""
    <td phx-click="pick-date" phx-value-date="<%= Timex.format!(@day, "%Y-%m-%d", :strftime) %>" class="<%= @day_class %>">
      <%= Timex.format!(@day, "%d", :strftime) %>
    </td>
    """
  end

  def put_color(date) do
    cond do
          date.status == "Red" ->
              "text-xs p-2 text-gray-600 border border-gray-200 bg-red-100 hover:bg-blue-100 cursor-pointer"
          date.status == "Green" ->
              "text-xs p-2 text-gray-600 border border-gray-200 bg-green-100 hover:bg-blue-100 cursor-pointer"

          date.status == "Yellow" ->
                "text-xs p-2 text-gray-600 border border-gray-200 bg-yellow-100 hover:bg-blue-100 cursor-pointer"
      end
  end


  defp day_class(assigns) do
    cond  do
      TodosWeb.TaskController.find_date(assigns.day.day, assigns.day.month, assigns.day.year) == nil ->
        "text-xs p-2 text-gray-600 border border-gray-200 bg-white hover:bg-blue-100 cursor-pointer"
      true -> 
        put_color(TodosWeb.TaskController.find_date(assigns.day.day, assigns.day.month, assigns.day.year))
        
      # today?(assigns) ->
      #   "text-xs p-2 text-gray-600 border border-gray-200 bg-green-200 hover:bg-green-300 cursor-pointer"
      # current_date?(assigns) ->
      #   "text-xs p-2 text-gray-600 border border-gray-200 bg-blue-100 cursor-pointer"
      # other_month?(assigns) ->
      #   "text-xs p-2 text-gray-400 border border-gray-200 bg-gray-200 cursor-not-allowed"
      # true ->
      #   "text-xs p-2 text-gray-600 border border-gray-200 bg-white hover:bg-blue-100 cursor-pointer"
    end
  end
  


  defp current_date?(assigns) do
    Map.take(assigns.day, [:year, :month, :day]) == Map.take(assigns.current_date, [:year, :month, :day])
  end

  defp today?(assigns) do
    Map.take(assigns.day, [:year, :month, :day]) == Map.take(Timex.now, [:year, :month, :day])
  end

  defp other_month?(assigns) do
    Map.take(assigns.day, [:year, :month]) != Map.take(assigns.current_date, [:year, :month])
  end
end