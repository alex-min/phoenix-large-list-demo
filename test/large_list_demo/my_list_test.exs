defmodule LargeListDemo.MyListTest do
  use LargeListDemo.DataCase

  alias LargeListDemo.MyList

  describe "records" do
    alias LargeListDemo.MyList.Record

    @valid_attrs %{name: "some name", value: 42}
    @update_attrs %{name: "some updated name", value: 43}
    @invalid_attrs %{name: nil, value: nil}

    def record_fixture(attrs \\ %{}) do
      {:ok, record} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MyList.create_record()

      record
    end

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert MyList.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert MyList.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      assert {:ok, %Record{} = record} = MyList.create_record(@valid_attrs)
      assert record.name == "some name"
      assert record.value == 42
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MyList.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()
      assert {:ok, %Record{} = record} = MyList.update_record(record, @update_attrs)
      assert record.name == "some updated name"
      assert record.value == 43
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = MyList.update_record(record, @invalid_attrs)
      assert record == MyList.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = MyList.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> MyList.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = MyList.change_record(record)
    end
  end
end
