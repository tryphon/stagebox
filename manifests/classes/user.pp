class users { 
  user { stream:
    groups => [audio, www-data]
    # www-data: to insert Events in the StreamControl db
  }
}

