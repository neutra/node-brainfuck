exports.run = (source) ->
  throw new Error 'invalid source' unless typeof(source) is 'string'
  throw new Error "invalid char '#{m[0]}'" if (m=/[^+-.<>[\]]/.exec source)?
  [i,buf,jmp] = [0,[],[]]
  for ch,p in source when ch is '[' or ch is ']'
    switch ch
      when '[' then buf[i++]=p
      when ']'
        if buf[i-1]?
          jmp[buf[--i]]=p
          jmp[p]=buf[i]
          delete buf[i]
        else
          throw new Error "unexpect ']' at pos #{p}"
  unless i is 0
    throw new Error "expect ']' to match '[' at pos #{buf[i-1]}"
  [p,len]=[-1,source.length]
  while ++p<len
    ch = source[p]
    switch ch
      when '+' then buf[i]=(buf[i] ? 0)+1
      when '-' then buf[i]=(buf[i] ? 0)-1
      when '>' then ++i
      when '<' then --i
      when '.' then process.stdout.write String.fromCharCode buf[i] ? 0x30
      when '[' then p=jmp[p] if not buf[i]? or buf[i] is 0
      when ']' then p=jmp[p] if buf[i]? and buf[i] isnt 0

exports.run "++++++++++[>++++++++++<-]>++++.+."  # print "hi"