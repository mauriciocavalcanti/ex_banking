# ExBanking

Simple OTP application, using GenServer and DynamicSupervisor to create users, 
deposit in any currency, withdraw, send from one user to another and get the current balance.
Currently, limited to 10 operations per user. Each user is a supervised process.
Using virtual memory shared between process states.
 

## Installation

Running the project:\
Make sure to have [elixir](https://elixir-lang.org) installed.\
To run test cases, open terminal on root directory and write:
```
$ mix deps.get
$ mix test
```
To run project via command line:
```
$ iex -S mix
```
For more information about function specs, view docs:
```
$ mix deps.get
$ mix docs
$ start doc/index.html
```