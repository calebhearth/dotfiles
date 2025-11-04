#!/usr/bin/ruby

Pry.config.prompt_name = begin
  app = ENV['APP_NAME']
  app ||= File.basename(Rails.root) if defined?(Rails)
  app ||= File.basename(`git rev-parse --show-toplevel`)
  app ||= File.basename(Dir.pwd)

  env = ENV.fetch('RAILS_ENV') { ENV['RACK_ENV'] }
  env = case env
        when 'development' then ''
        when 'production' then ' 􀐟 ' # 􀧘  􀅮
        when 'test' then ' 􂟦 '
        else " #{env}"
        end
  "#{Pry::Helpers::Text.bold(app.strip)}(#{Pry::Helpers::Text.blue('pry')}#{env})"
end

Pry::Prompt.add(:pry_and_branch, '', ['❯', '∙']) do |context, nesting, pry_instance, separator|
  [
    '􀩼  ', # 􀆃 􀆀
    pry_instance.config.prompt_name,
    ("/#{context}" unless context.nil? || context.to_s == 'main'),
    (unless nesting.zero?
       "/#{ pry_instance.binding_stack.map do |b|
         Pry.view_clip(format(
                         '%<class>s#%<method>s:%<line>s',
                         class: b.eval('self.class'),
                         method: b.eval('__method__'),
                         line: b.source_location.last
                       ))
       end.join(' / ') }"
     end),
    " #{Pry::Helpers::Text.blue(separator)} "
  ].compact.join
end
Pry.config.prompt = Pry::Prompt[:pry_and_branch]
