The `Task` module is an amazing tool packed with functionality that can both improve the performance of our application and be used as a part of our system architecture. This article is all about exploring the different ways `Task` can be used and why we would want to use it in the first place.

### Using the Task module for Parallelization
In a lot of languages, setting a bunch of heavy tasks to run in parallel isn't usually the simplest of things, however, in Elixir,  it's no more complex than wrapping our function with  `Task.async_stream`.

For example, take a long-running task

```elixir
def func(i) do
  Process.sleep(:timer.seconds(i))
end
```
Running this function sequentially would take around 55 seconds  if we were to do 

```elixir
Enum.each(1..10, &func/1)
```
however, with a simple swap, we can bring this time down to 10 seconds or a 5x  reduction in time to complete with nothing more than a change of the function used to iterate.

```elixir
Task.async_stream(1..10, &func/1, max_concurrency: 10)
```

***Note***: *without the `max_concurrency` option the number of processes at once is limited to the number of CPU's on our machine*

There are a few options to be aware of when using this function which is [well documented here](https://hexdocs.pm/elixir/Task.html#async_stream/3 ).

### Using the Task module to start side effects
There are plenty of cases in Elixir we still need side effects, for example perhaps we get some input from a client and we need to update the database, but don't want to wait for that update to return a response, this can easily be done by `Task.start`. However, what if we want the task to be restarted on failure? This is a job for a `Task.Supervisor` which can have customized restart options and also keeps the Task under supervision so that it can be restarted on failure. If it crashes fully the supervisor can handle its exit gracefully, which removes the chance of it leaving [dangling processes](https://elixirforum.com/t/when-are-agent-and-task-supervisor-useful/896/4).

To use the `Task.Supervisor` module we must first start the task supervisor to our application module

```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [{Task.Supervisor,
      name: Task.SomeThingSupervisor,
      # this will cause our tasks to restart on non normal exit
      restart: :transient
    }]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
```

Then we can use the `Task.Supervisor` module to start our tasks under the supervisor

```elixir
Task.Supervisor.async_stream(Task.SomeThingSupervisor,  &do_some_thing/1)
```

### Using Task.async to speed up multiple long synchronous functions
Occasionally, we have multiple functions that are  long-running and still require the response of them all for our final response. Take a case where we need to get multiple aggregates and aggregate those or even just return them, we could have a function like this:

```elixir
def super_aggregate do
  agg1 = some_long_running_aggregate_task()
  agg2 = another_long_running_aggregate_task()
  agg3 = final_long_running_aggregate_task()

  combine_aggregates(agg1, agg2, agg3)
end
```

If each aggregate task takes 3 seconds, we're now waiting 9 seconds to run these aggregates. Instead, we could use `Task.async` to run the 3 tasks and `Task.await` to wait for them before combining the aggregates.

```elixir
def super_aggregate do
  agg1 = Task.async(fn -> some_long_running_aggregate_task() end)
  agg2 = Task.async(fn -> another_long_running_aggregate_task() end)
  agg3 = Task.async(fn -> final_long_running_aggregate_task() end)

  combine_aggregates(
    Task.await(agg1),
    Task.await(agg2),
    Task.await(agg3)
  )
end
```

This reduces the time by 3x and now we're only taking 3 seconds to run all the aggregates before combining, much better!

### Using Task.Supervisor.async_nolink to set state in a GenServer
Using `Task.async_nolink`  we can send messages on completion back to a GenServer,  or any OTP conformant module. This can be used to set state asynchronously and run long-running tasks on another thread, which keeps the GenServer free to respond to other requests. Take this for example:

```elixir
defmodule SomeServer do
  use GenServer

  @default_name :some_server

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)

    GenServer.start_link(SomeServer, %{}, opts)
  end

  def init(state) do
    # Make sure Task.MySupervisor is created in Application
    Task.Supervisor.async_nolink(Task.MySupervisor, fn ->
      Process.sleep(1000)
      {:set_state, :first, "First"}
    end)

   Task.Supervisor.async_nolink(Task.MySupervisor, fn ->
      Process.sleep(2000)
      {:set_state, :second, "Second"}
    end)

    {:ok, state}
  end

  def get_state, do: :sys.get_state(@default_name)

  def handle_info({_ref, {:set_state, key, new_state}}, state) do
    {:noreply, Map.put(state, key, new_state)}
  end
end
```

This allows us to always query `get_state` with quick response times while still allow for an expensive computation to run and then set the values to state when they're available.

Calling this while it's running would return `%{}` instantly. However, one second in another call to `get_state` will show `%{first: "First"}` and another second later `%{first: "First", second: "Second"}`

***Note:*** *Our `get_state` funciton is using  [`:sys.get_state`](http://www.erlang.org/doc/man/sys.html#get_state-1) which allows us to get the state of any process by name* 

### Using Task instead of GenServer when state or messaging isn't required
Sometimes, we want a function to run every interval over and over for all time, this is known as [polling](https://en.wikipedia.org/wiki/Polling_(computer_science)). Polling can often have no state at all, for example, we could want to find all the users and check if they're valid, if not send an email every day, in this, we wouldn't need to keep a list of all users in the state but fetch them all from the database. To do this with a GenServer we would end up with something like this:

#### Example of converting a GenServer into a Task
```elixir
defmodule MyPeriodicChecker do
  use GenServer
  require Logger

  @interval :timer.hours(24)

  def start_link(opts \\ [name: MyPeriodicChecker]) do
    GenServer.start_link(MyPeriodicChecker, opts, args)
  end

  def init(_) do
    send(self(), :run)

    {:ok, %{}}
  end

  def handle_info(:run, state) do
    Logger.info("1 day is up, I'm running...")
    email_user_verification_messages(get_unverified_users())

    Process.send_after(self, :run, @interval)
    {:noreply, state}
  end
end
```

A second look at this GenServer implementation and we realize that the state is unused and we have a pretty much useless init function! In these cases we could use an  alternative:


```elixir
defmodule MyPeriodicChecker do
  use Task
  require Logger

  @interval :timer.hours(24)

  def start_link(args \\ []) do
    Task.start_link(MyPeriodicChecker, :run, [])
  end

  def run do
    email_user_verification_messages(get_unverified_users())

    Process.sleep(@interval)

    Logger.info("1 day is up, I'm running...")
    run()
  end
end
```

For more complex options and ensuring tasks are only run once per interval including on restart, [quantum](https://github.com/quantum-elixir/quantum-core) exists, which has many more options and can run over a distributed cluster with many different configuration options.

###  Distributing Task load across a cluster
Distribution is important, making sure that no one node is doing all the work allows for each node to do less and have more space to process other things or respond to requests quickly. The task module provides a really quick way to do this, while still being able to await their responses:

```elixir
nodes = [node() | Node.list()]
tasks = Enum.map(1..100, fn i ->
  Task.async({Task.MySupervisor, Enum.random(nodes)}, fn ->
    some_expensive_task()
  end)
end

Task.yield_many(tasks)
```

This spawns 100 tasks each going to a random node from our cluster and then is awaited at the end to return the result.


### Conclusion

The `Task` module is capable of many things when working with expensive tasks or when we want to run things in parallel, it's a fantastic tool to learn and can speed up your application with little effort.