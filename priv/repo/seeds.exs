# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LargeListDemo.Repo.insert!(%LargeListDemo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias LargeListDemo.Repo
alias LargeListDemo.MyList.Record

Enum.each(0..4000, fn x ->
  Repo.insert!(%Record{name: "record #{x}", value: x})
end)
