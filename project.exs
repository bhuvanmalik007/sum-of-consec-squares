defmodule SupervisorModule do
  def supervisor(n, k) do
    truncatedLength = trunc(n / k)
    totalIntervals = (rem(n, k) == 0 && k) || k + 1

    intervalList =
      Enum.reduce(1..k, [], fn intervalNo, acc ->
        startNo = (intervalNo - 1) * truncatedLength + 1
        endingNo = intervalNo * truncatedLength

        acc ++
          Keyword.put_new([], :"interval#{inspect(intervalNo)}", %{start: startNo, end: endingNo})
      end)

      intervalList = (totalIntervals == ((k + 1)) &&
      (intervalList ++
        Keyword.put_new([], :"interval#{inspect(k + 1)}", %{start: ((k * trunc(n / k)) + 1), end: n}))) || intervalList

      last = Enum.reduce(1..length(intervalList), self(), fn(i, acc) ->
        (Node.alive?() && (rem(i, 2) == 0) && Node.spawn_link(:"madhukar@10.20.217.252", SupervisorModule, :sumOfSquares, [Keyword.get(intervalList, :"interval#{inspect(i)}"), k, acc]))
        ||
        spawn(SupervisorModule, :sumOfSquares, [Keyword.get(intervalList, :"interval#{inspect(i)}"), k, acc])
      end) # end of reduce

      send last, []

      receive do
        final_answer ->
          IO.puts("Result is #{inspect(final_answer)}")
      end
  end # end of supervisor

  def sumOfSquares(interval, k, next_pid) do
    IO.puts("Running on bhuvan's machine")
    start = Map.get(interval, :start)
    finish = Map.get(interval, :end)
    result = Enum.reduce(start..finish, [], fn x, acc ->
      sqRoot = :math.sqrt((k - 1) * k * (2 * k - 1) / 6 + k * (x * x) + k * (k - 1) * x)
      (sqRoot - trunc(sqRoot) == 0 && acc ++ [x]) || acc
    end)
    receive do
      resultFromPrevious -> send next_pid, result ++ resultFromPrevious
  end
end

def run(n, k) do
  IO.puts inspect :timer.tc(SupervisorModule, :supervisor, [n, k])
end

end # SupervisorModule end

if(!Node.alive?()) do
  {_, options, _} = OptionParser.parse(System.argv(), switches: [ help: :boolean],aliases: [ h: :help ])
  SupervisorModule.run(String.to_integer(Enum.at(options, 0)), String.to_integer(Enum.at(options, 1)))
end

