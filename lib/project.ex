import Integer

defmodule Project do
  def testing(n, k) do
    Enum.reduce(1..n, [], fn x, acc ->
      sqRoot = :math.sqrt((k - 1) * k * (2 * k - 1) / 6 + k * (x * x) + k * (k - 1) * x)
      (sqRoot - trunc(sqRoot) == 0 && Process.exit(self, [x])) || acc
    end)
  end

  def cases(n, k) do
    case1 = twelveLambdaCase(k)
    IO.puts("\nCase1: " <> "#{inspect(case1)}")
    case2 = eightLambda(k)
    IO.puts("\nCase2: " <> "#{inspect(case2)}")
    case3 = twelveLambda(k)
    IO.puts("\nCase3: " <> "#{inspect(case3)}")
    case4 = evenTwoThreePowerCase(k)
    IO.puts("\nCase4: " <> "#{inspect(case4)}")
    case5 = onlyTwoThreeCase(k)
    IO.puts("\nCase5: " <> "#{inspect(case5)}")

    IO.puts(
      "\n\nFINAL ANSWER: " <>
        "#{
          inspect(((case1 || case2 || case3 || case4 || case5) && "no solution") || testing(n, k))
        }"
    )
  end

  def eightLambda(k) do
    rem(k, 8) == 4 || rem(k, 8) == 5 || rem(k, 8) == 6
  end

  def twelveLambda(k) do
    rem(k, 12) == 5 or rem(k, 12) == 7
  end

  def onlyTwoThreeCase(k) do
    primeFactors = factorize(k, 2, [])
    # IO.puts("prime factors: " <> "#{inspect(primeFactors)}")
    unique = Enum.uniq(primeFactors)
    # IO.puts("uniques: " <> "#{inspect(unique)}")
    ofForm = Enum.filter(unique, fn x -> x == 2 || x == 3 end)
    # IO.puts("of form: " <> "#{inspect(ofForm)}")
    if(ofForm == unique) do
      powers =
        Enum.reduce(ofForm, [], fn x, acc ->
          acc ++ [{x, Enum.count(primeFactors, fn t -> t == x end)}]
        end)

      # IO.puts("powers: " <> "#{inspect(powers)}")
      powersOnly =
        Enum.reduce(ofForm, [], fn x, acc ->
          acc ++ [Enum.count(primeFactors, fn t -> t == x end)]
        end)

      # IO.puts("\n\npowersOnly: " <> "#{inspect(powersOnly)}")
      Enum.any?(powersOnly, fn power -> Integer.is_even(power) end) || (k == 2 && false)
    end
  end

  @spec twelveLambdaCase(pos_integer) :: [pos_integer]
  def twelveLambdaCase(k) do
    primeFactors = factorize(k, 2, [])
    # IO.puts("prime factors: " <> "#{inspect(primeFactors)}")
    unique = Enum.uniq(primeFactors)
    # IO.puts("uniques: " <> "#{inspect(unique)}")
    ofForm = Enum.filter(unique, fn x -> rem(x, 12) == 5 or rem(x, 12) == 7 end)
    # IO.puts("of form: " <> "#{inspect(ofForm)}")
    powers =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [{x, Enum.count(primeFactors, fn t -> t == x end)}]
      end)

    # IO.puts("powers: " <> "#{inspect(powers)}")
    powersOnly =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [Enum.count(primeFactors, fn t -> t == x end)]
      end)

    # IO.puts("powersOnly: " <> "#{inspect(powersOnly)}")
    Enum.any?(powersOnly, fn power -> Integer.is_odd(power) end)
  end

  @spec evenTwoThreePowerCase(pos_integer) :: [pos_integer]
  def evenTwoThreePowerCase(k) do
    primeFactors = factorize(k, 2, [])
    # IO.puts("prime factors: " <> "#{inspect(primeFactors)}")
    unique = Enum.uniq(primeFactors)
    # IO.puts("uniques: " <> "#{inspect(unique)}")
    ofForm = Enum.filter(unique, fn x -> x == 2 || x == 3 end)
    # IO.puts("of form: " <> "#{inspect(ofForm)}")
    powers =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [{x, Enum.count(primeFactors, fn t -> t == x end)}]
      end)

    # IO.puts("powers: " <> "#{inspect(powers)}")
    powersOnly =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [Enum.count(primeFactors, fn t -> t == x end)]
      end)

    # IO.puts("powersOnly: " <> "#{inspect(powersOnly)}")
    Enum.any?(powersOnly, fn power -> Integer.is_even(power) end)
  end

  # keep which are in the form

  defp factorize(number, factor, prime_factors) when number < factor do
    prime_factors
  end

  defp factorize(number, factor, prime_factors) when rem(number, factor) == 0 do
    [factor | factorize(div(number, factor), factor, prime_factors)]
  end

  defp factorize(number, factor, prime_factors) do
    factorize(number, factor + 1, prime_factors)
  end
end
