module Stat
  def sum(data)
    data.inject(0){|accum, i| accum + i }
  end

  def mean(data)
    sum(data)/data.length.to_f
  end

  def sample_variance(data)
    m = mean(data)
    sum = data.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(data.length - 1).to_f
  end

  def standard_deviation(data)
    return Math.sqrt(sample_variance(data))
  end
end

