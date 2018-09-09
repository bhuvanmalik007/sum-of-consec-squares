defmodule SupervisorModule do
  def supervisor(n, k) do
    # Total intervals are either k or k + 1
    # singleProcessPID = n < k && spawn(SupervisorModule, :sumOfSquares, [%{start: 1, end: n}, k, self()])
    # n < k && send singleProcessPID, []
    intervalListLength = trunc(n / k)
    totalIntervals = (rem(n, k) == 0 && k) || k + 1

    # Complex array defining interval ranges
    intervalList =
      Enum.reduce(1..k, [], fn intervalNo, acc ->
        startNo = (intervalNo - 1) * intervalListLength + 1
        endingNo = intervalNo * intervalListLength
        acc ++
          Keyword.put_new([], :"interval#{inspect(intervalNo)}", %{start: startNo, end: endingNo})
      end)

      # Adding remaining elements into another interval if totalIntervals = k + 1
      intervalList = (totalIntervals == ((k + 1)) &&
      (intervalList ++
        Keyword.put_new([], :"interval#{inspect(k + 1)}", %{start: ((k * trunc(n / k)) + 1), end: n}))) || intervalList

      # Creating, initializing calculations by passing aruguments and linking processes to each other
      # Spawning half the process in a remote node if it is connected
      # Storing lastProcessPID
      lastProcessPID = Enum.reduce(1..length(intervalList), self(), fn(i, acc) ->
        (Node.alive?() && (rem(i, 2) == 0) && Node.spawn_link(:"madhukar@10.20.217.252", SupervisorModule, :sumOfSquares, [Keyword.get(intervalList, :"interval#{inspect(i)}"), k, acc]))
        ||
        spawn(SupervisorModule, :sumOfSquares, [Keyword.get(intervalList, :"interval#{inspect(i)}"), k, acc])
      end) # end of reduce

      # Initializing message passing from the last process created
      send lastProcessPID, []

      # Receiving final result from the first process that was created
      receive do
        final_answer ->
          (final_answer == [] && IO.puts("Result: No sequence")) || IO.puts("Result is #{inspect(final_answer)}")
      end
  end # end of supervisor

  # This process computes a sequence within the interval range it was given and validates if the result is a perfect square
  def sumOfSquares(interval, k, next_pid) do
    # IO.puts("Running on bhuvan's machine")
    result = resultCalc(Map.get(interval, :start), Map.get(interval, :end), k)

    # Adding result of this process to overall result
    receive do
      resultFromPrevious -> send next_pid, result ++ resultFromPrevious
    end
  end

  def resultCalc(start, finish, k) do
    Enum.reduce(start..finish, [], fn x, acc ->
      sqRoot = :math.sqrt((k - 1) * k * (2 * k - 1) / 6 + k * (x * x) + k * (k - 1) * x)
      (sqRoot - trunc(sqRoot) == 0 && acc ++ [x]) || acc
    end)
  end

  # Spawns the supervisor process
  def run(n, k) do
    if n < k do
      final_answer = resultCalc(1, n, k)
        (final_answer == [] && IO.puts("Result: No sequence")) || IO.puts("Result is #{inspect(final_answer)}")
      else
        IO.puts inspect :timer.tc(SupervisorModule, :supervisor, [n, k])
    end
  end

end # SupervisorModule end

# Handling if remote nodes are used or not. This enables us to to use the command "mix run project.exs arg1 arg2" if remote nodes are not being used.
if(!Node.alive?()) do
  {_, options, _} = OptionParser.parse(System.argv(), switches: [ help: :boolean],aliases: [ h: :help ])
  SupervisorModule.run(String.to_integer(Enum.at(options, 0)), String.to_integer(Enum.at(options, 1)))
end

