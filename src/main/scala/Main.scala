package org.otus.irvind.second

object Main {
  def main(args: Array[String]): Unit = {
    val experiments = (1 to 10000).toList.map({_ => new Experiment()})
    val result = experiments.map((exp) => exp.run())
      .map((boolRes) => if (boolRes) 1 else 0)
    val resultSum = result.sum.toDouble
    val prob = resultSum / 10000
    // Точное значение вероятности вытащить хотя бы один белый шарик = 0.8
    println("Result probability: " + prob.toString)
  }
}

class Experiment {
  private var items: List[Int] = List(1, 1, 1, 0, 0, 0)

  def run(): Boolean = {
    val rand = new scala.util.Random
    val firstIdx = rand.nextInt(6)
    if (items(firstIdx) == 1)
      return true

    items = items.patch(firstIdx, List.empty, 1)
    val secondIdx = rand.nextInt(5)
    items(secondIdx) == 1
  }
}
