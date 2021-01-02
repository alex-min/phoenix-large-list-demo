defmodule LargeListDemoWeb.RecordLiveTest do
  use LargeListDemoWeb.ConnCase

  import Phoenix.LiveViewTest

  alias LargeListDemo.MyList

  @create_attrs %{name: "some name", value: 42}
  @update_attrs %{name: "some updated name", value: 43}
  @invalid_attrs %{name: nil, value: nil}

  defp fixture(:record) do
    {:ok, record} = MyList.create_record(@create_attrs)
    record
  end

  defp create_record(_) do
    record = fixture(:record)
    %{record: record}
  end

  describe "Index" do
    setup [:create_record]

    test "lists all records", %{conn: conn, record: record} do
      {:ok, _index_live, html} = live(conn, Routes.record_index_path(conn, :index))

      assert html =~ "Listing Records"
      assert html =~ record.name
    end

    test "saves new record", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.record_index_path(conn, :index))

      assert index_live |> element("a", "New Record") |> render_click() =~
               "New Record"

      assert_patch(index_live, Routes.record_index_path(conn, :new))

      assert index_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#record-form", record: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.record_index_path(conn, :index))

      assert html =~ "Record created successfully"
      assert html =~ "some name"
    end

    test "updates record in listing", %{conn: conn, record: record} do
      {:ok, index_live, _html} = live(conn, Routes.record_index_path(conn, :index))

      assert index_live |> element("#record-#{record.id} a", "Edit") |> render_click() =~
               "Edit Record"

      assert_patch(index_live, Routes.record_index_path(conn, :edit, record))

      assert index_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#record-form", record: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.record_index_path(conn, :index))

      assert html =~ "Record updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes record in listing", %{conn: conn, record: record} do
      {:ok, index_live, _html} = live(conn, Routes.record_index_path(conn, :index))

      assert index_live |> element("#record-#{record.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#record-#{record.id}")
    end
  end

  describe "Show" do
    setup [:create_record]

    test "displays record", %{conn: conn, record: record} do
      {:ok, _show_live, html} = live(conn, Routes.record_show_path(conn, :show, record))

      assert html =~ "Show Record"
      assert html =~ record.name
    end

    test "updates record within modal", %{conn: conn, record: record} do
      {:ok, show_live, _html} = live(conn, Routes.record_show_path(conn, :show, record))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Record"

      assert_patch(show_live, Routes.record_show_path(conn, :edit, record))

      assert show_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#record-form", record: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.record_show_path(conn, :show, record))

      assert html =~ "Record updated successfully"
      assert html =~ "some updated name"
    end
  end
end
