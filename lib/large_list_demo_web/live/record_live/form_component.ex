defmodule LargeListDemoWeb.RecordLive.FormComponent do
  use LargeListDemoWeb, :live_component

  alias LargeListDemo.MyList

  @impl true
  def update(%{record: record} = assigns, socket) do
    changeset = MyList.change_record(record)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"record" => record_params}, socket) do
    changeset =
      socket.assigns.record
      |> MyList.change_record(record_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"record" => record_params}, socket) do
    save_record(socket, socket.assigns.action, record_params)
  end

  defp save_record(socket, :edit, record_params) do
    case MyList.update_record(socket.assigns.record, record_params) do
      {:ok, _record} ->
        {:noreply,
         socket
         |> put_flash(:info, "Record updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_record(socket, :new, record_params) do
    case MyList.create_record(record_params) do
      {:ok, _record} ->
        {:noreply,
         socket
         |> put_flash(:info, "Record created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
