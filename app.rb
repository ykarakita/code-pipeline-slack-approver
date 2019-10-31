def handler(event:, context:)
  puts event
  puts context

  {
    event: event,
    context: context,
  }
end