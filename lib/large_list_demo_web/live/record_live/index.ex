defmodule LargeListDemoWeb.RecordLive.Index do
  use LargeListDemoWeb, :live_view

  alias LargeListDemo.MyList
  alias LargeListDemo.MyList.Record

  @records_per_page 40
  @row_height 65

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       records_count: MyList.count_records(),
       records_per_page: @records_per_page,
       row_height: @row_height,
       records: MyList.list_records(page: 0, per_page: @records_per_page)
     ), temporary_assigns: [records: []]}
  end

  def handle_event(
        "load-table",
        %{"offset" => offset},
        socket
      ) do
    {:noreply,
     socket
     |> push_event(
       "records-receive-table-#{offset}",
       %{
         offset: offset,
         html:
           MyList.list_records(
             page: offset,
             per_page: @records_per_page
           )
           |> Enum.map(fn record ->
             render_to_string(LargeListDemoWeb.LayoutView, "record.html",
               conn: socket,
               record: record
             )
           end)
       }
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Record")
    |> assign(:record, MyList.get_record!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Record")
    |> assign(:record, %Record{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Records")
    |> assign(:record, nil)
  end
end
