# LargeListDemo for Phoenix Live View

This is a demo project for https://alex-min.fr/phoenix-live-view-very-large-list-hook/.

It demonstrates how a hook to show large lists can work.

In order to use this project, please run the seeds beforehand:

```
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

This will create the database along with 4000 test items, it's useful to visualize the list.