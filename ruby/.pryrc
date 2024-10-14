#!/usr/bin/ruby

class String
  def levenshtein(other)
    matrix = [(0..length).to_a]
    (1..other.length).each do |j|
      matrix << [j] + [0] * (length)
    end

    (1..other.length).each do |i|
      (1..length).each do |j|
        if self[j - 1] == other[i - 1]
          matrix[i][j] = matrix[i - 1][j - 1]
        else
          matrix[i][j] = [
            matrix[i - 1][j],
            matrix[i][j - 1],
            matrix[i - 1][j - 1],
          ].min + 1
        end
      end
    end
    matrix.last.last
  end
end

Pry.config.prompt_name = begin
  app = ENV["APP_NAME"]
  if defined?(Rails)
    app ||= File.basename(Rails.root)
  end
  app ||= File.basename(`git rev-parse --show-toplevel`)
  app ||= File.basename(Dir.pwd)

  env = ENV.fetch("RAILS_ENV") { ENV["RACK_ENV"] }
  if env == "development"
    env = ""
  elsif env != "" && env != nil
    env = " #{env}"
  end
  "pry(#{Pry::Helpers::Text.blue(app.strip)}#{env})"
end

Pry::Prompt.add(:pry_and_branch, "", ["❯", "∙"]) do |context, nesting, pry_instance, separator|
  [
    pry_instance.config.prompt_name,
    ("/#{context.to_s}" unless context.nil? || context.to_s == "main"),
    ("/#{ pry_instance.binding_stack.map { |b| Pry.view_clip(format(
      "%<class>s#%<method>s:%<line>s",
      class: b.eval("self.class"),
      method: b.eval("__method__"),
      line: b.source_location.last
    )) }.join(" / ") }" unless nesting.zero?),
    " #{Pry::Helpers::Text.blue(separator)} ",
  ].compact.join
end
Pry.config.prompt = Pry::Prompt[:pry_and_branch]
