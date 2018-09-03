import Integer

defmodule Project do
  def testing(n, k) do
    Enum.reduce(1..n, [], fn x, acc ->
      sqRoot = :math.sqrt((k - 1) * k * (2 * k - 1) / 6 + k * (x * x) + k * (k - 1) * x)
      (sqRoot - trunc(sqRoot) == 0 && acc ++ [x]) || acc
    end)
  end

  def cases(n, k) do
    case1 = twelveLambdaCase(k)
    IO.puts("Case1: " <> "#{inspect(case1)}")
    case2 = eightLambda(k)
    IO.puts("Case2: " <> "#{inspect(case2)}")
    case3 = twelveLambda(k)
    IO.puts("Case3: " <> "#{inspect(case3)}")
    case4 = evenTwoThreePowerCase(k)
    IO.puts("Case4: " <> "#{inspect(case4)}")
    case5 = onlyTwoThreeCase(k)
    IO.puts("Case5: " <> "#{inspect(case5)}")
    case6 = onlyTwoThreeCase(k)
    IO.puts("Case5: " <> "#{inspect(case5)}")
  end

  def eightLambda(k) do
    rem(k, 8) == 4 || rem(k, 8) == 5 || rem(k, 8) == 6
  end

  def twelveLambda(k) do
    rem(k, 12) == 5 or rem(k, 12) == 7
  end

  def onlyTwoThreeCase(k) do
    primeFactors = factorize(k, 2, [])
    IO.puts("prime factors: " <> "#{inspect(primeFactors)}")
    unique = Enum.uniq(primeFactors)
    IO.puts("uniques: " <> "#{inspect(unique)}")
    ofForm = Enum.filter(unique, fn x -> x == 2 || x == 3 end)
    IO.puts("of form: " <> "#{inspect(ofForm)}")

    if(ofForm == unique) do
      powers =
        Enum.reduce(ofForm, [], fn x, acc ->
          acc ++ [{x, Enum.count(primeFactors, fn t -> t == x end)}]
        end)

      IO.puts("powers: " <> "#{inspect(powers)}")

      powersOnly =
        Enum.reduce(ofForm, [], fn x, acc ->
          acc ++ [Enum.count(primeFactors, fn t -> t == x end)]
        end)

      IO.puts("\n\npowersOnly: " <> "#{inspect(powersOnly)}")

      Enum.any?(powersOnly, fn power -> Integer.is_even(power) end) ||
        (powers == [{2, 1}] && false)
    end
  end

  @spec twelveLambdaCase(pos_integer) :: [pos_integer]
  def twelveLambdaCase(k) do
    primeFactors = factorize(k, 2, [])
    IO.puts("prime factors: " <> "#{inspect(primeFactors)}")
    unique = Enum.uniq(primeFactors)
    IO.puts("uniques: " <> "#{inspect(unique)}")
    ofForm = Enum.filter(unique, fn x -> rem(x, 12) == 5 or rem(x, 12) == 7 end)
    IO.puts("of form: " <> "#{inspect(ofForm)}")

    powers =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [{x, Enum.count(primeFactors, fn t -> t == x end)}]
      end)

    IO.puts("powers: " <> "#{inspect(powers)}")

    powersOnly =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [Enum.count(primeFactors, fn t -> t == x end)]
      end)

    IO.puts("powersOnly: " <> "#{inspect(powersOnly)}")
    Enum.any?(powersOnly, fn power -> Integer.is_odd(power) end)
  end

  @spec evenTwoThreePowerCase(pos_integer) :: [pos_integer]
  def evenTwoThreePowerCase(k) do
    IO.puts("inside evenTwoThreePowerCase")
    primeFactors = factorize(k, 2, [])
    IO.puts("prime factors: " <> "#{inspect(primeFactors)}")
    unique = Enum.uniq(primeFactors)
    IO.puts("uniques: " <> "#{inspect(unique)}")

    ofForm = Enum.filter(unique, fn x -> x == 2 || x == 3 end)
    IO.puts("of form: " <> "#{inspect(ofForm)}")

    powers =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [{x, Enum.count(primeFactors, fn t -> t == x end)}]
      end)

    IO.puts("powers: " <> "#{inspect(powers)}")

    powersOnly =
      Enum.reduce(ofForm, [], fn x, acc ->
        acc ++ [Enum.count(primeFactors, fn t -> t == x end)]
      end)

    IO.puts("powersOnly: " <> "#{inspect(powersOnly)}")
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
